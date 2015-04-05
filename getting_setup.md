# Getting setup

We're pragmatic, so we use [CocoaPods](http://cocoapods.org). It is a dependency manager for Cocoa projects, we're going to use it to pull in the required dependencies. If you're new to CocoaPods then yours truely and the rest of the CocoaPods dev team have an [extensive guides website](http://guides.cocoapods.org) to help you get started.

### Adding a test Target

If you don't have a test target in your application then you need to add one. This can be done by opening Xcode, clicking File in the menu-bar then going to `New` \> `New Target`. You'll find the test target under Other in iOS. It's called `Cococa Touch Unit Testing Bundle`. Adding this to your project will add the required info files, and you should choose to test (be hosted by) your existing application.

### Setting up your Podfile

I'm presuming you already have a Podfile, if you don't consult the [CocoaPods Getting Started](http://guides.cocoapods.org/using/getting-started.html) guide. We're going to make changes to add testing tools. This means adding a new section in the Podfile. These typically look like the following:

``` ruby
pod 'ORStackView'
...

target :AppTests, :exclusive =\> true do
		pod 'Specta'
	pod 'Expecta'
	pod 'FBSnapshotTestCase'
end
```

This links the testing Pods to only the test target. This inherits the app's CocoaPods, in this case ORStackView. CocoaPods will generate a second library for the testing pods Specta, Expecta and FBSnapshotTestCase. This means there's no duplication of library symbols.

You can test that everything is working well together by either going to `Product > Test` in the menu or by pressing `⌘ + u`. This will compile your application, then run it and inject your testing bundle into the application.

If that doesn't happen, it's likely that your Scheme is not set up correctly. Go to `Product > Scheme > Edit Scheme..` or press `⌘ + ⇧ + ,`. Then make sure that you have a valid test target set up for that scheme.