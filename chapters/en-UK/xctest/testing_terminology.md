# Useful Terminology

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
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

- (void)setDefaultUsername
{
  [self.defaults setObject:@"Danger" forKey:ARUsername];
}

- (NSUserDefaults *)defaults
{
	return _defaults ? : [NSUserDefaults standardUserDefaults];
}
```
This is a bit more code, but it has enabled me to pass my own standard user defaults object ( or API-complaint fake ) into the class at runtime. If I don't then it will fall back to the usual global object.
