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


### Common Patterns

So what does this pattern give us?
