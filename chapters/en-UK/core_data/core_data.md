# Core Data

Core Data is just another dependency to be injected. It's definitely out of your control, so in theory you could be fine using stubs and mocks to control it as you would like.

From my perspective though, I've been creating a blank in-memory `NSManagedObjectContext` for every test, for years, and I've been happy with this.

### Memory Contexts

An in-memory context is a managed object context that is identical to your app's main managed object context, but instead of having a SQL `NSPersistentStoreCoordinator` based on the file system it's done in-memory and once it's out of scope it disappears.

Here's the setup for our in-memory context in Folio:

```objectivec
+ (NSManagedObjectContext *)stubbedManagedObjectContext
{
    NSDictionary *options = @{
      NSMigratePersistentStoresAutomaticallyOption : @(YES),
      NSInferMappingModelAutomaticallyOption : @(YES)
    };

    NSManagedObjectModel *model = [CoreDataManager managedObjectModel];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    [... Add a memory store to the coordinator]

    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = persistentStoreCoordinator;
    return context;
}
```

This context will act the same as your normal context, but it's cheap and easy to fill. It's also going to run functions on the main-thread for you to if you use `NSMainQueueConcurrencyType` simplifying your work further.

Having one of these is probably the first step for making tests against any code touching Core Data.

### Knowing when to DI functions

It's extremely common to wrap the Core Data APIs, they're similar to XCTest and Auto Layout in that Apple provides a low-level standard library then everyone builds their own wrappers above it.

The wrappers for Core Data tend to not be built with DI in mind, offering their own singleton access for a main managed object context. So you may need to send some PRs to allow passing an in-memory  `NSManagedObjectContext` instead of a singleton.

This means I ended up writing a lot of functions that looked like this:

```objectivec
@interface NSFetchRequest (ARModels)

/// Gets all artworks of an artwork container that can be found with current user settings with an additional scope predicate
+ (instancetype)ar_allArtworksOfArtworkContainerWithSelfPredicate:(NSPredicate *)selfScopePredicate inContext:(NSManagedObjectContext *)context defaults:(NSUserDefaults *)defaults;

[...]
```

Which, admittedly would be much simpler in Swift thanks to default initialiser. However, you get the point. Any time you need to do fetches you need to DI the in-memory version somehow. This could be as a property on an object, or as an argument in a function. I've used both, a lot.

### Asserting on the Main Managed Object Context

In my Core Data stack I use a `CoreDataManager` and the factory pattern. This means I can add some logic to my manager to raise an exception when it is running in tests. You can do this very easily by checking the `NSProcessInfo` class.

```objectivec

static BOOL ARRunningUnitTests = NO;

@implementation CoreDataManager

+ (void)initialize
{
	if (self == [CoreDataManager class]) {
	    NSString *XCInjectBundle = [[[NSProcessInfo processInfo] environment] objectForKey:@"XCInjectBundle"];
	    ARRunningUnitTests = [XCInjectBundle hasSuffix:@".xctest"];
	}
}

+ (NSManagedObjectContext *)mainManagedObjectContext
{
	if (ARRunningUnitTests) {
	    @throw [NSException exceptionWithName:@"ARCoreDataError" reason:@"Nope - you should be using a stubbed context in tests." userInfo:nil];
	}
	[...]
}
```

This is something you want to do early on in writing your tests. The later you do it, the larger the changes you will have to make to your existing code base.

This makes it much easier to move to all objects to accept in-memory `NSManagedObjectContext` via Dependency Injection. It took me two days to migrate all of the code currently covered by tests to do this. Every now and again, years later, I start adding tests to an older area of the code-base and find that `mainManagedObjectContext` was still being called in a test. It's a great way to save yourself and others some frustrating debugging time in the future.


### Advantages of Testing with Core Data

I like working with Core Data, remember that it is an object graph tool, and so being able to have a fully set up `NSManagedObjectContext` as a part of the arrangement in your test can make testing different states extremely easy, you can also save example databases from your app and move them into your tests as a version you could work against.

Straight after setting up an in-memory store, we wanted to be able to quickly throw example data into our `NSManagedObjectContext`. The way we choose to do it was via a factory object. Seeing as the factory pattern works pretty well here, here's the sort of interface we created:

```objectivec
@interface ARModelFactory : NSObject

+ (Artwork *)fullArtworkInContext:(NSManagedObjectContext *)context;
+ (Artwork *)partiallyFilledArtworkInContext:(NSManagedObjectContext *)context;
+ (Artwork *)fullArtworkWithEditionsInContext:(NSManagedObjectContext *)context;

[...]
@end
```

These would add an object into the context, and also let it return the newly inserted object in-case you had test-specific modifications to do.
