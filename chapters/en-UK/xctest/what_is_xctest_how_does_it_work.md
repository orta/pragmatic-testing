# What is the XCTest framework?

Now as a default when you create a new Xcode project apple creates a test target for you. Testing has been a part of Xcode since [OCUnit](http://www.sente.ch/software/ocunit/) the predecessor to XCTest was included Xcode 2.1.

XCTest owes it's architectural decisions to [SUnit](http://sunit.sourceforge.net) the first testing framework, built for smalltalk apps. OCUnit is an Objective-C implementation of SUnit.

The <i>x</i>Unit format is quite simple. There are collections of test-suites, which contain test cases and test cases contain individual tests. A test runner is created which loops through all suites, their test cases and runs specific methods. If running the method raises an exception then that test is considered a failure, and the runner moves to the next method. The final part is a logger to output the results.

In XCTest the convention is that you subclass a XCTestCase object, and the test runner will call any method that begins with the word `test`. E.g. `- (void)testImageSpecifiesAspectRatio`.

The actual implementation of XCTest works by creating a bundle, which can optionally be injected into an application ( Apple calls this hosting the tests. ) The bundle contains test resources like dummy images or JSON, and your test code. There is a version of [XCTest open source'd](https://github.com/apple/swift-corelibs-xctest) by Apple.

XCTest provides a series of macros or functions [based on OCUnit's](https://github.com/jy/SenTestingKit/blob/master/SenTestCase_Macros.h#L82) for calling an exception when an expectation isn't met. For example `XCTAssertEqual`, `XCTFail` and `XCTAssertLessThanOrEqual`. You can explore how the XCT* functions work in [the OSS XCTest](https://github.com/apple/swift-corelibs-xctest/blob/96772ca6e01e664e153d0c844fff69e94605ef17/Sources/XCTest/XCTAssert.swift#L29-L45).

Here's a real example of an XCTest case subclass taken from the [Swift Package Manager](https://github.com/mxcl/swift-package-manager/blob/aa1700c0b7b94a5639c54d746e60404fbbda597f/Tests/Utility/ShellTests.swift):

``` swift
import Utility
import XCTest

class ShellTests: XCTestCase {

    func testPopen() {
        XCTAssertEqual(try! popen(["echo", "foo"]), "foo\n")
    }

    func testPopenWithBufferLargerThanThatAllocated() {
        let path = Path.join(#file, "../../Get/DependencyGraphTests.swift").normpath
        XCTAssertGreaterThan(try! popen(["cat", path]).characters.count, 4096)
    }

    func testPopenWithBinaryOutput() {
        if (try? popen(["cat", "/bin/cat"])) != nil {
            XCTFail("popen succeeded but should have failed")
        }
    }
}
```

It has three tests, that each test their own expectations.

- The first ensures that when `popen(["echo", "foo"])` is called, it returns `"foo\n"`
- The second ensures that when `popen(["cat", path])` is called, it returns a number of characters greater than `4096`
- Finally the third one checks an expectation, and if it's wrong, it will fail the test.

##### What is the difference between hosted test targets and unhosted

When talking pragmatically, we're really talking about writing tests against apps or libraries. Depending on whether you have dependencies on Cocoa or UIKit, you end up having to make a choice. Hosted, or not hosted.

The terminology has changed recently, a hosted test used to be known as Application Tests, and "unhosted" was known as Logic Tests. The older terminology gives a better hint at how the tests would be ran.

A hosted test is ran inside your application after `application:didFinishLaunchingWithOptions:` has finished. This means there is a fully running application, and your tests run with that happening around it. This gives you access to a graphics context, the application's bundle and other useful bits and pieces.

Un-hosted tests are useful if you're testing something very ephemeral/logical and relying only on Foundation, but anything related to UIKit/Cocoa subclasses will eventually require you to host the test bundle in an application. You'll see this come up every now and again when setting up test-suites.

Further reading:

* History of SenTestingKit on [objc.io](http://www.objc.io/issue-1/testing-view-controllers.html#sentestkit) by Daniel Eggert
* How XCTest works on [objc.io](http://www.objc.io/issue-15/xctest.html#how_xctest_works) by Daniel Eggert and Arne Schroppe
