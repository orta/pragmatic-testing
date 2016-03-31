# Dependency Injection

Dependency Injection (DI, from here on in) is a way of dealing with how you keep your code concerns separated. On a more pragmatic level it is expressed elegantly in [Jame Shore's blog post](http://www.jamesshore.com/Blog/Dependency-Injection-Demystified.html)

> Dependency injection means giving an object its instance variables. Really. That's it.

This alone isn't really enough to show the problems that DI solves. So, let's look at some code and investigate what DI really means in practice.

### Dependency Injection in a function

Lets start with the smallest possible example, a single function:

``` objc
- (void)saveUserDetails
{
	User *user = [[User currentUser] dictionaryRepresentation];
	[[NSUserDefaults standardUserDefaults] setObject:user forKey:@"user"];
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"injected"];
}
```

Testing this code can be tricky, as it relies on functions inside the `NSUserDefaults` and `User` class. These are the dependencies inside this function. Ideally when we test this code we want to be able to replace the dependencies with something specific to the test. There are many ways to start applying DI, but I think the easiest way here is to try and make it so that the function takes in it's dependencies as arguments. In this case we are giving the function both the `NSUserDefaults` object and a `User` model.

 ``` objc
 - (void)saveUser:(User *)user inDefaults:(NSUserDefaults *)defaults
 {
	 [defaults setObject:[user dictionaryRepresentation] forKey:@"user"];
	 [defaults setBool:YES forKey:@"injected"];
 }
 ```

In Swift we can use default arguments to acknowledge that we'll most often be using the `sharedUserDefaults`as the `defaults` var:

``` swift
func saveUser(user: User, defaults: Defaults = .standardUserDefaults()){
	 defaults.setObject(user.dictionaryRepresentation, forKey:"user")
	 defaults.setBool(true, forKey:"injected")
}
```

This little change in abstraction means that we can now insert our own custom objects inside this function. Thus, we can inject a new instance of both arguments and test the end results of them. Something like:

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

 We can now easily test the changes via inspecting our custom dependencies.

## Dependency Injection at Object Level

 Let's expand our scope of using DI, a single function can use DI via it's arguments, so then an object can expand it's scope via instance variables. As the initial explanation said.

``` swift
class UserNameTableVC: UITableViewController {
   var names: [String] = [] {
     didSet {
       tableView.reloadData()
     }
   }
   override func viewDidLoad() {
     super.viewDidLoad()
     MyNetworkingClient.sharedClient().getUserNames { newNames in
       self.names = newNames
     }
   }
}
```

This example grabs some names via an API call, then sets the instance variable `names` to be the new value from the network. In this example the object that is outside of the scope of the `UserNameTableVC` is the `MyNetworkingClient`.

This means that in order to easily test the view controller, we would need to stub or mock the `sharedClient()` function to return a different version based on each test.

The easiest way to simplify this, would be to move the networking client into an instance variable. We can use Swift's default initialisers to set it as the app's default which means less glue code ( in Objective-C you would override a property's getter function with a default unless the instance variable has been set. )

``` swift
class UserNameTableVC: UITableViewController {
   var names: [String] = [] {
     [...]
   }

   var network: MyNetworkingClient = .sharedClient()

   override func viewDidLoad() {
     super.viewDidLoad()
     network.getUserNames { newNames in
       self.names = newNames
     }
   }
}
```
This can result in simpler app code, and significantly easier tests. Now you can init a `UITableViewController` and set the `.network` with any version of the `MyNetworkingClient` before `viewDidLoad` is called, and you're all good.

## Dependency Injection at Global Scope

#### Ambient Context

When you have a group of objects that all need access to the same kind of dependencies. It can makes sense to bundle those dependencies into a single object. I generally call these context objects. Here's an example, directly from from [Artsy Folio](TODO_get_link):

``` objc
[...]

@interface ARSyncConfig : NSObject

  - (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
                                      defaults:(NSUserDefaults *)defaults
                                       deleter:(ARSyncDeleter *)deleter;

  @property (nonatomic, readonly, strong) NSManagedObjectContext *managedObjectContext;
  @property (nonatomic, readonly, strong) NSUserDefaults *defaults;
  @property (nonatomic, readonly, strong) ARSyncDeleter *deleter;

@end
```

This object wraps a `NSManagedObjectContext`, a `NSUserDefaults` and a `ARSyncDeleter` into a single class. This means it can provide an ambient context for other objects. For example, this is a class that performs the analytics on a sync.

``` objc
@implementation ARSyncAnalytics

- (void)syncDidStart:(ARSync *)sync
{
    [sync.config.defaults setBool:YES forKey:ARSyncingIsInProgress];

    BOOL completedSyncBefore = [sync.config.defaults boolForKey:ARFinishedFirstSync];
    [ARAnalytics event:@"sync_started" withProperties:@{
        @"initial_sync" : @(completedSyncBefore)
    }];
}

[...]
```

The `ARSyncAnalytics` doesn't have any instance variables at all, the sync object is DI'd in as a function argument. From there the analytics are set according to the `defaults` provided inside the `ARSync`'s context object. I believe the official name for this pattern is ambient context.


Read more:

http://www.bignerdranch.com/blog/dependency-injection-ios/
[http://www.objc.io/issue-15/dependency-injection.html](http://www.objc.io/issue-15/dependency-injection.html)
