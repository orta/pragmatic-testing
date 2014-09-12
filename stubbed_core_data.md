# Stubbed Core Data Contexts

When I introduced testing into a 3 year old Core Data based code base, I experienced a lot of strange errors when developing the app. In retrospect it is obvious, my tests were running on the main development Core Data instance.

This meant changes inside the tests would affect development. This is a big no-no, and it's easy to fix and to force yourself to move to a stay in that position. This can be done with two simple techniques: Asserting when in Tests and accessing the main Managed Object Context and Stubbed Managed Object Contexts.

### Asserting on the Main Managed Object Context

In my Core Data stack I use a `CoreDataManager` and the factory pattern. This means I can add some logic to my manager to raise an exception when it is running in tests. You can do this very easily by checking the `NSProcessInfo` class.

``` objc

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
    ...
}
```

This is something you want to do early on in writing your tests. The later you do it the large the changes you will have to make in your existing code base to move all objects to accept Stubbed Managed Object Contexts via Dependency Injection. It took me two days to migrate all of the code currently covered by tests to do this.

### Stubbed Managed Object Contexts

Databases are fast. Datastores are slow. You want to keep your tests fast. This means being able to create and destory whole Core Data stacks hundreds of times a second. The only way to do this reasonably is to store a copy of the Managed Object Store in memory, and to make the persistant store be memory based too. Lets look at an implementation:

```
+ (NSManagedObjectContext *)stubbedManagedObjectContext
{
    NSDictionary *options = @{
        NSMigratePersistentStoresAutomaticallyOption : @(YES),
        NSInferMappingModelAutomaticallyOption : @(YES)
    };

    NSError *error = nil;
    NSManagedObjectModel *model = [CoreDataManager managedObjectModel];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                  configuration:nil
                                                            URL:nil
                                                        options:options
                                                          error:&error];

    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = persistentStoreCoordinator;
    return context;
}

```

This returns a fast, empty core data stack.
