# Useful Terminology

### Mocks and Stubs

A mock object is an object created by a library to emulate an existing object's API. In general there are two main types of mocks, nice/partial mocks which pass methods not stubbed to either an existing object or to nil and (not nice?) mocks which will assert when a method which isn't stubbed is called.

A stub is a method that is replaced at runtime with another implementation. It is common for a stub to not call the original method. It's useful in setting up context for when you want to use known a return value with a method.

From a personal opinion I try to avoid stubbing and mocking code which is under my control. When you first get started Mocks and Stubs feel like the perfect tool for testing code, but it becomes unweidly. Great examples of when to use stubbing is on

### Fakes

A Fake is an API compatible version of an object. That is it. Fakes are extremely easy to make in both Swift and Objective-C. Though the techniques to create them can be different.

In Objective-C fakes can be created easily using the loose typing at runtime. If you create an object that responds to the same selectors as the one you want to fake you can pass it instead by typecasting it to the original.

In Swift the use of `AnyObject` is discouraged so the use of fudging types doesn't work. Instead there is a higher use of protocols in the culture. This means that you can rely on a different object conforming to the same protocol to make test code run differently.

For my favourite use case of Fakes, look at the chapter on network models.

### Dependency Injection

Dependency Injection (DI) is a £25 name for a £5 concept. It means adding the dependencies from which your application relies on at runtime. One of the great examples here is the usage of a singleton. Let's show some code:

``` objc
- (void)setDefaultUsername
{
	[[NSUserDefaults standardUserDefaults] setObject:@"Danger" forKey:ARUsername];
}
```

In this example there is an implicit dependency on the `NSUserDefaults standardUserDefaults`, and if you wanted to test that it actually set the key as expected you would need to stub the class `NSUserDefaults`'s function `standardUserDefaults` to return your own class. DI is a way of thinking about this relationship and making it more explicit. Here is how I would write it so it can be easily tested.

``` objc
@interface ARAdminSettingsViewController ()
@property (nonatomic, strong) NSUserDefaults \*defaults;
@end

- (void)setDefaultUsername
{
  [self.defaults setObject:@"Danger" forKey:ARUsername];
}

- (NSUserDefaults \*)defaults
{
	return _defaults ? : [NSUserDefaults standardUserDefaults];
}
```
This is a bit more code, but it has enabled me to pass my own standard user defaults object ( or API-complaint fake ) into the class at runtime. If I don't then it will fall back to the usual global object.