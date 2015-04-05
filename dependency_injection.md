# Dependency Injection

Dependency Injection (DI, from here on in) is a way of dealing with how you keep your code concerns separated. On a more pragmatic level it is expressed elegantly in [Jame Shore's blog post](http://www.jamesshore.com/Blog/Dependency-Injection-Demystified.html)

> Dependency injection means giving an object its instance variables. Really. That's it.

This alone isn't really enough to get started though. So let's get out some code and investigate what that really means.

### DI in a function

Lets start with the smallest possible example, a single function:

``` objc
- (void)saveUserDetails
{
	User *user = [[User currentUser] dictionaryRepresentation];
	[[NSUserDefaults standardUserDefaults] setObject:user forKey:@"user"];
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"injected"];
}
```

Testing this code can be tricky, as it relies on functions inside the `NSUserDefaults` and `User` class. These are the dependencies inside this function. Ideally when we test this code we want to be able to replace the dependencies with something specific to the test. There are many ways to start applying DI, but I think the easiest way here is to try and make it so that the function takes in it's dependencies. In this case we are giving the function both the `NSUserDefaults` object and a `User` model.

 ``` objc
 - (void)saveUser:(User *)user inDefaults:(NSUserDefaults *)defaults
 {
	 [defaults setObject:[user dictionaryRepresentation] forKey:@"user"];
	 [defaults setBool:YES forKey:@"injected"];
 }
 ```

 This means that in order to test this function, we can inject a new instance of both arguments and test the end results of them. Something like:

 ``` objc
it(@"saves user defaults", ^{
	NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
	User *user = [User stubbedUser];
	UserArchiver *archiver = [[UserArchiver alloc] init];

	[archiver saveUser:user inDefaults:defaults];

	expect([user dictionaryRepresentation]).to.equal([defaults objectForKey:@"user"]);
	expect([defaults boolForKey:@"injected"]).to.equal(YES);
});
 ```

 We can now easily test the changes from the function.

## DI in an object

 Let's expand out a bit more into an object, this is going to require a bit more code.

 ``` objc

@interface ORUserNameTableViewController: UITableViewController
@property (nonatomic, copy) NSArray *names;
@end

@implementation ORUserNameTableViewController

...

@end

```

...


http://www.bignerdranch.com/blog/dependency-injection-ios/
[http://www.objc.io/issue-15/dependency-injection.html](http://www.objc.io/issue-15/dependency-injection.html)
