### What is the XCTest framework?

Now as a default when you create a new Xcode project apple creates a test target for you. Testing has been a part of Xcode since [OCUnit](http://www.sente.ch/software/ocunit/) the predecessor to XCTest was included Xcode 2.1.

XCTest owes it's architectural decisions to [SUnit](http://sunit.sourceforge.net) the first testing framework, built for smalltalk apps. OCUnit is an Objective-C implementation of SUnit. 

The <i>x</i>Unit format is quite simple, there are collections of test suites, which contain test cases. Test cases contain individual tests. A test runner is created which loops through all suites, their cases and runs known methods. If running the method raises an exception then that test is considered a failure, and the runner moves to the next method. The final part is a logger to output the results.

In XCTest the convention is that you subclass a XCTestCase object, and the test runner will call any method that begins with the word `test`. 

The actual implementation of XCTest works by creating a bundle, which can optionally be injected into an application ( Apple calls this hosting the tests. ) The bundle contains test resources like dummy images or JSON, and your test code. 

XCTest provides a series of macros [based on OCUnit's](https://github.com/jy/SenTestingKit/blob/master/SenTestCase_Macros.h#L82) for calling an exception unless an expectation isn't met. 

##### What is the difference between hosted test targets and unhosted

The terminology has changed recently, a hosted test used to be known as Application Tests, and unhosted was known as Logic Tests. The older terminolgy gives a better hint at how the tests would be ran. A hosted test is ran inside your application after it `application:didFinishLaunchingWithOptions:` has finished. 

Unhosted tests are useful if you're testing something very ephemeral and relying only on Foundation, but anything related to UIKit subclasses will eventually require you to host the test bundle in an application.

Further reading:

* History of SenTestingKit on [objc.io](http://www.objc.io/issue-1/testing-view-controllers.html#sentestkit) by Daniel Eggert
* How XCTest works on [objc.io](http://www.objc.io/issue-15/xctest.html#how_xctest_works) by Daniel Eggert and Arne Schroppe