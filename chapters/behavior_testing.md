### Behaviour  Driven Development

Behaviour Driven Development (BDD) is something that grew out of Test Driven Development. TDD is a practice and BDD expands on it, but only really is about trying to provide a consistent vocabulary for how tests are described.

This is easier when you compare the same tests, so lets take some tests from the Swift Package Manager [ModuleTests.swift](https://github.com/apple/swift-package-manager/blob/5040f9ebe6686e7f07be6fbae50dcf942584902c/Tests/Transmute/ModuleTests.swift#L35)

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
        This pattern of adding an extra depends,
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

Behaviour Driven Development is about being able to have a consistent vocabulary in your test suites. BDD defines the terminology, so they're the same between BDD libraries. This means, if you use [Rspec](https://github.com/rspec/rspec), [Specta](https://github.com/specta/specta/), [Quick](https://github.com/quick/quick), [Ginkgo](https://github.com/onsi/ginkgo) and many others you will be able to employ similar testing structures.

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

* Bid button it posts order if artwork has no edition sets
* Bid button it posts order if artwork has 1 edition set
* Bid button it displays inquiry form if artwork has multiple sets
* Bid button it displays inquiry form if request fails

Yeah, the English gets a bit janky, but you can easily read these as though they were english sentences. That's pretty cool. These describe blocks can be nested, this makes contextualising different aspects of your testing suite easily. So you might end up with this in the future:

* Bid button when logged in it posts order if artwork has no edition sets
* Bid button when logged in it posts order if artwork has 1 edition set
* Bid button when logged in it displays inquiry form if artwork has multiple sets
* Bid button when logged in it displays inquiry form if request fails
* Bid button when logged out it asks for a email if we don't have one
* Bid button when logged out it posts order if no edition sets and we have email

Where you can split out the `it` blocks into different `describes` called `logged in` and `logged out`.

So what does this pattern give us? Well, first up, tests are readable, and are obvious in their dependents. The structure of how you make your tests becomes a matter of nesting `context`s, and it's much harder to just name your tests: `test1`, `test2`, `test3` because you can easily say them out loud.

I've never felt comfortable writing XCTest, and so from this point on, expect to not see anymore examples in that format.

