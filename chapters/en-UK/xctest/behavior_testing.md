### Behaviour  Driven Development

Behaviour Driven Development (BDD) is something that grew out of Test Driven Development (TDD). TDD is a practice and BDD expands on it, but only really is about trying to provide a consistent vocabulary for how tests are described.

This is easier to think about when you compare the same tests wrote in both XCTest ( which has it's own structure for writing tests) and move towards a BDD appraoch. So lets take some tests from the Swift Package Manager [ModuleTests.swift](https://github.com/apple/swift-package-manager/blob/5040f9ebe6686e7f07be6fbae50dcf942584902c/Tests/Transmute/ModuleTests.swift#L35) which uses plain old XCTest.

```swift
class ModuleTests: XCTestCase {

    func test1() {
        let t1 = Module(name: "t1")
        let t2 = Module(name: "t2")
        let t3 = Module(name: "t3")

        t3.dependsOn(t2)
        t2.dependsOn(t1)

        XCTAssertEqual(t3.recursiveDeps, [t2, t1])
        XCTAssertEqual(t2.recursiveDeps, [t1])
    }

    func test2() {
        let t1 = Module(name: "t1")
        let t2 = Module(name: "t2")
        let t3 = Module(name: "t3")
        let t4 = Module(name: "t3")

        t4.dependsOn(t2)
        t4.dependsOn(t3)
        t4.dependsOn(t1)
        t3.dependsOn(t2)
        t3.dependsOn(t1)
        t2.dependsOn(t1)

        XCTAssertEqual(t4.recursiveDeps, [t3, t2, t1])
        XCTAssertEqual(t3.recursiveDeps, [t2, t1])
        XCTAssertEqual(t2.recursiveDeps, [t1])
    }

    func test3() {
        let t1 = Module(name: "t1")
        let t2 = Module(name: "t2")
        let t3 = Module(name: "t3")
        let t4 = Module(name: "t4")

        t4.dependsOn(t1)
        t4.dependsOn(t2)
        t4.dependsOn(t3)
        t3.dependsOn(t2)
        t3.dependsOn(t1)
        t2.dependsOn(t1)

        [...]
        This pattern of adding an extra `dependsOn`,
        and new t`X`s continues till it gets to test6
}
```

Note: They are split up in Act, Arrange, Assert, but they do an awful lot of repeating themselves. As test bases get bigger, maybe it makes sense to start trying to split out some of the logic in your tests.

So what about if we moved some of the logic inside each test out, into a section before, this simplifies out tests, and allows each test to have more focus.

```swift
class ModuleTests: XCTestCase {
    let t1 = Module(name: "t1")
    let t2 = Module(name: "t2")
    let t3 = Module(name: "t3")
    let t4 = Module(name: "t4")

    func test1() {
        t3.dependsOn(t2)
        t2.dependsOn(t1)

        XCTAssertEqual(t3.recursiveDeps, [t2, t1])
        XCTAssertEqual(t2.recursiveDeps, [t1])
    }

    func test2() {
        t4.dependsOn(t2)
        t4.dependsOn(t3)
        t4.dependsOn(t1)
        t3.dependsOn(t2)
        t3.dependsOn(t1)
        t2.dependsOn(t1)

        XCTAssertEqual(t4.recursiveDeps, [t3, t2, t1])
        XCTAssertEqual(t3.recursiveDeps, [t2, t1])
        XCTAssertEqual(t2.recursiveDeps, [t1])
    }

    func test3() {
        t4.dependsOn(t1)
        t4.dependsOn(t2)
        t4.dependsOn(t3)
        t3.dependsOn(t2)
        t3.dependsOn(t1)
        t2.dependsOn(t1)
        [...]
}
```

This is great, we're not quite doing so much arranging, but we're definitely doing some obvious Acting and Asserting. The tests are shorter, more concise, and nothing is lost in the refactor. This is easy when you have a few immutable `let` variables, but gets complicated once you want to have your Arrange steps perform actions.

Behaviour Driven Development is about being able to have a consistent vocabulary in your test-suites. BDD defines the terminology, so they're the same between BDD libraries. This means, if you use [Rspec](https://github.com/rspec/rspec), [Specta](https://github.com/specta/specta/), [Quick](https://github.com/quick/quick), [Ginkgo](https://github.com/onsi/ginkgo) and many others you will be able to employ similar testing structures.

So what are these words?

* `describe` - used to collate a collection of tests under a descriptive name.
* `it` - used to set up a unit to be tested
* `before/after` - callbacks to code that happens before, or after each `it` or `describe` within the current `describe` context.
* `beforeAll/afterAll` - callbacks to run logic at the start / end of a describe context.

They combine like this psuedocode version of [these tests: ARArtworkViewControllerBuyButtonTests.m](https://github.com/artsy/eigen/blob/2a14463c0bb1a14e9709496261f74622cca8b1e5/Artsy_Tests/View_Controller_Tests/Artwork/ARArtworkViewControllerBuyButtonTests.m#L16-L121):

``` swift
describe("buy button") {
  beforeAll {
    // sets up a mock for a singleton object
  }

  afterAll {
    // stops mocking
  }

  before {
    // ensure we are in a logged out state
  }

  after {
    // clear all user credentials
  }

  it("posts order if artwork has no edition sets") {
    // sets up a view controller
    // taps a button
    // verifies what routes have been called
  }

  it("posts order if artwork has 1 edition set") {
    // [...]
  }

  it("displays inquiry form if artwork has multiple sets") {
    // [...]
  }

  it("displays inquiry form if request fails") {
    // [...]
  }
}
```

By using BDD, we can effectively tell a story about what expectations there are within a codebase, specifically around this buy button. It tells you:

* In the context of Buy button, it posts order if artwork has no edition sets
* In the context of Buy button, it posts order if artwork has 1 edition set
* In the context of Buy button, it displays inquiry form if artwork has multiple sets
* In the context of Buy button, it displays inquiry form if request fails

Yeah, the English gets a bit janky, but you can easily read these as though they were english sentences. That's pretty cool. These describe blocks can be nested, this makes contextualising different aspects of your testing suite easily. So you might end up with this in the future:

* In the context of Buy button, when logged in, it posts order if artwork has no edition sets
* In the context of Buy button, when logged in, it posts order if artwork has 1 edition set
* In the context of Buy button, when logged in, it displays inquiry form if artwork has multiple sets
* In the context of Buy button, when logged in, it displays inquiry form if request fails
* In the context of Buy button, when logged out, it asks for a email if we don't have one
* In the context of Buy button, when logged out, it posts order if no edition sets and we have email

Where you can split out the `it` blocks into different `describes` called `logged in` and `logged out`.

#### So what does this pattern give us?

Well, first up, tests are readable, and are obvious in their dependents.

The structure of how you make your tests becomes a matter of nesting `context` or `describes`s. This  it's much harder to just name your tests: `test1`, `test2`, `test3` because you should easily be able to say them out loud.

Being able to structure your tests as a hierarchy, making it easy to structure code to run `before`/`after` or `beforeAll`/`afterAll` at different points can be much simpler than having a collection of setup code in each test. This makes it easier for each `it` block to be focused on just the `arrange` and `assert`.

I've never felt comfortable writing plain old XCTest formatted code, and so from this point on, expect to not see any more examples in that format.

#### Matchers

BDD only provides a lexicon for structuring your code, in all of the examples further on you'll see things like:

```
// Objective-C
expect([item.attributeSet title]).to.equal(artist.gridTitle);

// Swift
expect(range.min) == 500
```

These types of expectations are not provided as a part of XCTest. XCTest provides a collection of ugly macros/functions like `XCTFail`, `XCTAssertGreaterThan` or `XCTAssertEqual` which does some simple logic and raises an error denoting the on the line it was called from.

As these are pretty limited in what they can do, and are un-aesthetically pleasing, I don't use them. Instead I use a matcher library. For example Expecta, Nimble or OCHamcrest. These provide a variety of tools for creating test assertions.

It's common for these libraries to be separate from the libraries doing BDD, in the Cocoa world, only Kiwi aims to do both BDD structures and matchers.

From my perspective, there's only one major advantage to bundling the two, and that is that you can fail a test if there were no matchers ran ( e.g. an async test never called back in time. ) To my knowledge, only Rspec for ruby provides that feature.
