### Unit Testing

So, what is a unit of code? Well, that's subjective. I'd argue that it's anything you can easily, reliably measure. A unit test can generally be considered something that is set up (arrange), then you perform some action (act) and verify the end result (assert.) It's like science experiments, kinda.

[Arrange, Act, Assert.](http://c2.com/cgi/wiki?ArrangeActAssert)

We had some real-world examples from Swift Package Manager in the last chapter that were too small for doing Arrange, Act, Assert, so let's use [another example](https://github.com/apple/swift-package-manager/blob/30ea0a95ac18235c8f1fefae0fb8f3dc4512b55b/Tests/Utility/PathTests.swift#L96-L110):

```swift
class WalkTests: XCTestCase {
    [...]

    func testRecursive() {
        let root = Path.join(#file, "../../../Sources").normpath
        var expected = [
            Path.join(root, "Build"),
            Path.join(root, "Utility")
        ]

        for x in walk(root) {
            if let i = expected.indexOf(x) {
                expected.removeAtIndex(i)
            }
        }

        XCTAssertEqual(expected.count, 0)
    }
    [...]
}
```
The first section, the author arranges the data-models as they expect them. Then in the `for` they act on that data. This is the unit of code being tested. Finally, they assert that the code has had the expected result. In this case, that the expected array has become empty.

Using the Arrange, Act, Assert methodology, it becomes very easy to structure your test cases. It makes tests obvious to other practitioners, and you can determine code smells quicker by seeing large amounts of code in your arrange or assert sections.

### One Test, One Unit

In the perfect theoretical world, every test case would be a single logical test of a unit of code. We're not talking theory here though, so from my perspective, [this](https://github.com/apple/swift-package-manager/blob/30ea0a95ac18235c8f1fefae0fb8f3dc4512b55b/Tests/Utility/PathTests.swift#L72-L78) is a great unit test:

``` swift
  func testParentDirectory() {
      XCTAssertEqual("foo/bar/baz".parentDirectory, "foo/bar")
      XCTAssertEqual("foo/bar/baz".parentDirectory.parentDirectory, "foo")
      XCTAssertEqual("/bar".parentDirectory, "/")
      XCTAssertEqual("/".parentDirectory.parentDirectory, "/")
      XCTAssertEqual("/bar/../foo/..//".parentDirectory.parentDirectory, "/")
  }
```

It shows a wide array of inputs, and their expected outputs for the same function. Someone looking over these tests would have a better idea of what `parentDirectory` does, and it covers a bunch of use cases. Great.

Note, the [Quick](https://github.com/Quick/Quick) documentation really shines on [ArrangeActAssert](https://github.com/Quick/Quick/blob/d30f9e93402b6fcc7013c86afeb77da4c38e9f27/Documentation/en-us/ArrangeActAssert.md) - I would strongly recommend giving it a quick browse.

Further reading:

- [Quick/Quick](https://github.com/Quick/Quick/) documentation: [ArrangeActAssert.md](https://github.com/Quick/Quick/blob/d30f9e93402b6fcc7013c86afeb77da4c38e9f27/Documentation/en-us/ArrangeActAssert.md)
