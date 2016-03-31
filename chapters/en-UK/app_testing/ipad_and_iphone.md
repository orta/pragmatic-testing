### Multi-Device Support

There are mainly two ways to have a test-suite handle multiple device-types, and orientations. The easy way: Run your test-suite multiple times on multiple devices, simulators, and orientations.

The hard way: Mock and Stub your way to multi-device support in one single test-suite.

#### Device Fakes

Like a lot of things, this used to be easier in simpler times. When you could just set a device size, and go from there, you can see this in Eigen's - ARTestContext.m

TODO - Link ^

``` objc
static OCMockObject *ARPartialScreenMock;

@interface UIScreen (Prvate)
- (CGRect)_applicationFrameForInterfaceOrientation:(long long)arg1 usingStatusbarHeight:(double)arg2 ignoreStatusBar:(BOOL)ignore;
@end

+ (void)runAsDevice:(enum ARDeviceType)device
{
  [... setup]

  ARPartialScreenMock = [OCMockObject partialMockForObject:UIScreen.mainScreen];
  NSValue *phoneSize = [NSValue valueWithCGRect:(CGRect)CGRectMake(0, 0, size.width, size.height)];

  [[[ARPartialScreenMock stub] andReturnValue:phoneSize] bounds];
  [[[[ARPartialScreenMock stub] andReturnValue:phoneSize] ignoringNonObjectArgs] _applicationFrameForInterfaceOrientation:0 usingStatusbarHeight:0 ignoreStatusBar:NO];
}
```

This ensures all ViewControllers are created at the expected size. Then you can use your own logic to determine iPhone vs iPad. This works for simple cases, but it isn't optimal in the current landscape of iOS apps.

#### Trait Fakes

Trait collections are now the recommended way to distinguish devices, as an iPad could now be showing your app in a screen the size of an iPhone. You can't rely on having an application the same size as the screen. This makes it more complex. 🎉

This is not a space I've devoted a lot of time to, so consider this section a beta. If anyone wants to dig in, I'd be interested in knowing what the central point of knowledge for train collections is, and stubbing that in the way I did with `_applicationFrameForInterfaceOrientation:usingStatusbarHeight:ignoreStatusBar:`.

Every View or View Controller (V/VC) has a read-only collection of traits, the V/VCs  can listen for trait changes and re-arrange themselves. For example, we have a view that sets itself up on the collection change:

TODO: Link to AuctionBannerView.swift

``` swift
class AuctionBannerView: UIView {

  override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    // Remove all subviews and call setupViews() again to start from scratch.
    subviews.forEach { $0.removeFromSuperview() }
    setupViews()
  }
}
```

When we test this view we stub the `traitCollection` array and trigger `traitCollectionDidChange`, this is done in our [Forgeries](https://github.com/ashfurrow/forgeries) library. It looks pretty much like this, with the environment being the V/VC.

``` objc
void stubTraitCollectionInEnvironment(UITraitCollection *traitCollection, id<UITraitEnvironment> environment) {
    id partialMock = [OCMockObject partialMockForObject:environment];
    [[[partialMock stub] andReturn:traitCollection] traitCollection];
    [environment traitCollectionDidChange:nil];
}
```

Giving us the chance to make our V/VC think it's in any type of environment that we want to write tests for.
