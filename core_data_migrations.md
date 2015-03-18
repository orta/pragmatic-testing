# Testing Core Data Migrations

The first time I released a patch release for the first Artsy App it crashed instantly, on every install. It turned out I didn't understand [Core Data Model Versioning](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreDataVersioning/Articles/Introduction.html). Now a few years on I grok the migration patterns better but I've still lived with the memories of that dark, dark day. Since then I've had an informal rule of testing migrations with  all the old build of Folio using a tool I created called  [chairs](http://artsy.github.io/blog/2013/03/29/musical-chairs/) the day before submitting to the app store.

Chairs is a tool to back up your application's documents and settings. This meant I would have backups from different builds and could have a simulator with data from past versions without having to compile and older build.

The problem here is that the manual process takes a lot of time, is rarely done, and could be pretty easily automated. So I extracted the old sqlite stores from the older builds, added these files to my testing bundle as fixture data and starting writing tests that would run the migrations. Running the migration is a matter of applying the current `NSManagedObjectModel` to the old sqlite file if you are using lightweight migrations.

```objc
//
//  ARAppDataMigrationTests.m
//  Artsy Folio
//
//  Created by Orta on 12/05/2014.
//  Copyright (c) 2014 http://artsy.net. All rights reserved.
//

NSManagedObjectContext *ARContextWithVersionString(NSString *string);

SpecBegin(ARAppDataMigrations)

__block NSManagedObjectContext *context;

it(@"migrates from 1.3", ^{
    expect(^{
        context = ARContextWithVersionString(@"1.3");
    }).toNot.raise(nil);
    expect(context).to.beTruthy();
    expect([Artwork countInContext:context error:nil]).to.beGreaterThan(0);
});

...

it(@"migrates from  1.6", ^{
    expect(^{
        context = ARContextWithVersionString(@"1.4");
    }).toNot.raise(nil);
    expect(context).to.beTruthy();
    expect([Artwork countInContext:context error:nil]).to.beGreaterThan(0);
});

SpecEnd

NSManagedObjectContext *ARContextWithVersionString(NSString *string) {

    // Allow it to migrate
    NSDictionary *options = @{
        NSMigratePersistentStoresAutomaticallyOption: @YES,
        NSInferMappingModelAutomaticallyOption: @YES
    };

    // Open up the the _current_ managed object model
    NSError *error = nil;
    NSManagedObjectModel *model = [CoreDataManager managedObjectModel];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    // Get an older Core Data file from fixtures
    NSString *storeName = [NSString stringWithFormat:@"ArtsyPartner_%@", string];
    NSURL *storeURL = [[NSBundle bundleForClass:ARAppDataMigrationsSpec.class] URLForResource:storeName withExtension:@"sqlite"];

    // Set the persistent store to be the fixture data
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Error creating persistant store: %@", error.localizedDescription);
        @throw @"Bad store";
        return nil;
    }

    // Create a stubbed context, check give it the old data, and it will update itself
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = persistentStoreCoordinator;
    return context;
}

```

Nothing too surprising, but I think it's important to note that these tests are the slowest tests in the app that hosts them at a whopping 0.191 seconds. I'm very willing to trade a fraction of a second on every test run to know that I'm not breaking app migrations.

These are tests that presume you still have people using older builds, every now and again when I'm looking at Analytics I check to see if any of these test can be removed.

Finally, if you don't use Core Data you may still need to be aware of changes around model migrations when storing using `NSKeyedArchiver`. It is a lot harder to have generic future-proofed test cases like the ones described here however.
