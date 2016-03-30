## Techniques for avoiding Async Networking

We've already covered Network Models. So I need to delve a little bit harder in order to really drive this point home. Networking is one of the biggest reasons for needing to do async testing, and we want to do everything possible to stop that happening.

The way I deal with this, is a little hacky. However, it is the best technique I have come up with so far. [This is the PR](TODO_Eigen_Networking_PR) for when I added this technique to Eigen.

### Stubbed Networking Client

It's normal to create a centralised HTTP client, the HTTP client's responsibilities are generally:

* Convert a path to a `NSURL`
* Create `NSURLRequests` for` NSURL`s
* Create networking operations for `NSURLRequests`
* Start the networking operations

We care about taking the last two responsibilities and making them act differently when in testing.

### Eigen

Let's go through the process _simplified_ for how Eigen's stubbed networking HTTP client works.

We want to have a networking client that can act differently in tests, so create a subclass of your HTTP client, in my case, the client is called `ArtsyAPI`. I want to call the subclass `ArtsyOHHTTPAPI` - as I want to use the library [OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs) to make my work easier.

``` objc
@interface ArtsyOHHTTPAPI : ArtsyAPI
@end
```

You need to have a way to ensure in your tests that you are using this version in testing. This can be done via Dependency Injection, or as I did, by using different classes in a singleton method when the new class is available.

```objc
+ (ArtsyAPI *)sharedAPI
{
    static ArtsyAPI *_sharedController = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        Class klass = NSClassFromString(@"ArtsyOHHTTPAPI") ?: self;
        _sharedController = [[klass alloc] init];
    });
    return _sharedController;
}
```

Next up you need a _point of inflection_ with the generation of networking operations in the HTTP client. For `ArtsyAPI` that is this method: `- (AFHTTPRequestOperation *)requestOperation:(NSURLRequest *)request success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failureCallback`

We want to override this function to work synchronously. So let's talk a little about how this will work.

1. #### Request Lookup

   We need an API to be able to declare a stubbed route, luckily for me OHHTTPStubs has been working on this problem for years. So I want to be able to build on top of that work, rather than write my own stubbed `NSURLRequest` resolver.

   After some digging into OHHTTPStubs, I discovered that it has a private API that does exactly what I need.

  ``` objc
    @interface OHHTTPStubs (PrivateButItWasInABookSoItMustBeFine)
    + (instancetype)sharedInstance;
    - (OHHTTPStubsDescriptor *)firstStubPassingTestForRequest:(NSURLRequest *)request;
    @end
  ```

  This allows us to access all of the `OHHTTPStubsDescriptor` objects, and more importantly, find out which ones are in memory at the moment. We can use this lookup function to work with the `request` parameter in our inflection function. All in one simple line of code.

  ```objc
  OHHTTPStubsDescriptor *stub = [[OHHTTPStubs sharedInstance] firstStubPassingTestForRequest:request];
  ```

2. #### Operation Variables

  So we have request look-up working, next up is creating an operation. It's very likely that you will need to create an API compatible fake version of whatever you're working with. In my case, that's [AFNetworking](https://github.com/AFNetworking/AFNetworking) `NSOperation` subclasses.

  However, first, you'll need to pull out some details from the stub:

  ``` objc
  // Grab the response by putting in the request
  OHHTTPStubsResponse *response = stub.responseBlock(request);

  // Open the input stream for in JSON data
  [response.inputStream open];

  id json = @[];
  NSError *error = nil;
  if (response.inputStream.hasBytesAvailable) {
      json = [NSJSONSerialization JSONObjectWithStream:response.inputStream options:NSJSONReadingAllowFragments error:&error];
  }
  ```

  This gives us all the details we'll need, the `response` object will also contain things like `statusCode` and `httpHeaders` that we'll need for determining operation behaviour.

3. #### Operation Execution

  In my case, I wanted an operation that does barely anything. The best operation that does barely anything is the trusty `NSBlockOperation` - which is an operation which executes a block when something tells it to start. Easy.

  ``` objc
  @interface ARFakeAFJSONOperation : NSBlockOperation
  @property (nonatomic, strong) NSURLRequest *request;
  @property (nonatomic, strong) id responseObject;
  @property (nonatomic, strong) NSError *error;
  @end

  @implementation ARFakeAFJSONOperation
  @end
  ```

  Depending on how you use the `NSOperation`s in your app, you'll need to add more properties, or methods in order to effectively fake the operation.

  For this function to be completed it needs to return an operation, so lets `return` a `ARFakeAFJSONOperation`.

  ```objc
  ARFakeAFJSONOperation *fakeOp = [ARFakeAFJSONOperation blockOperationWithBlock:^{
      NSHTTPURLResponse *URLresponse = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:response.statusCode HTTPVersion:@"1.0" headerFields:response.httpHeaders];

      if (response.statusCode >= 200 && response.statusCode < 205) {
          if (success) { success(request, URLresponse, json); }
      } else {
          if (failureCallback) { failureCallback(request, URLresponse, response.error, json); }
      }
  }];

  fakeOp.responseObject = json;
  fakeOp.request = request;
  return (id)fakeOp;
  ```

  So we create an operation, that either calls the `success` or the `failure` block in the inflected method depending on the data from inside the stub. Effectively closing the loop on our synchronous networking. From here, in the case of `ArtsyAPI` another object will tell the `ARFakeAFJSONOperation` to start, triggering the callback synchronously.

4. #### Request Failure

  Having a synchronous networking lookup system means that you can also detect when networking is happening when you don't have a stubbed request.

  We have a lot of code here, in order to provide some really useful advice to programmers writing tests. Ranging from a copy & paste-able version of the function call to cover the networking, to a full stack trace showing what function triggered the networking call

  TODO: Example of what one looks like

With this in place, all your networking can run synchronously in tests. Assuming they all go through your point of inflection, it took us a while to iron out the last few requests that weren't.

### AROHHTTPNoStubAssertionBot

I used a simplification of the above in a different project, to ensure that all HTTP requests we're stubbed. By using the same `OHHTTPStubs` private API, I could detect when a request was being ignored by the `OHHTTPStubs` singleton. Then I could create a stack trace and give a lot of useful information.

```objc
@interface ARHTTPStubs : OHHTTPStubs
@end

@implementation ARHTTPStubs

- (OHHTTPStubsDescriptor *)firstStubPassingTestForRequest:(NSURLRequest *)request
{
    id stub = [super firstStubPassingTestForRequest:request];
    if (stub) { return stub; }

    [... Logging out here]

    _XCTPrimitiveFail(spectaExample, @"Failed due to unstubbed networking.");
    return nil;
}
```

Then I used "fancy" runtime trickery to change the class of the `OHHTTPStubs` singleton at runtime on the only part of the public API.

``` objc

@interface AROHHTTPNoStubAssertionBot : NSObject
+ (BOOL)assertOnFailForGlobalOHHTTPStubs;
@end

@implementation AROHHTTPNoStubAssertionBot

+ (BOOL)assertOnFailForGlobalOHHTTPStubs
{
    id newClass = object_setClass([OHHTTPStubs sharedInstance], ARHTTPStubs.class);
    return newClass != nil;
}

@end
```

This technique is less reliable, as it relies on whatever the underlying networking operation does. This is generally calling on a background thread, and so you lose a lot of the useful stack tracing. However, you do get some useful information.

### Moya

Given that we know asynchronous networking in tests is trouble, for a fresh project we opted to imagine what it would look like to have networking stubs as a natural part of the API description in a HTTP client. The end result of this is [Moya](https://github.com/moya/moya).

In Moya you have to provide stubbed response data for every request that you want to map using the API, and it provides a way to easily do synchronous networking instead.
