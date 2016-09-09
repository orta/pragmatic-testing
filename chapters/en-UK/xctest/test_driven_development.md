### Test Driven Development

It's been said recently [that Test Driven Development (TDD) is dead](TODO_tdd_is_dead). I'm not too sold on the idea that it's dead, personally. I think for the Cocoa community, TDD has barely even started.

Test Driven Development is the idea of writing your application and your tests simultaneously. Just as you write out your app's code unit by unit, you cover each individual step with a test. The common pattern for this is:

* Red
* Green
* Refactor

This is the idea that, you start with a test, which will fail:

```swift
it("has ten items") {
  let subject = KeyNumbers()
  expect(subject.items.count) == 10
}
```

Then you do the minimum possible to get that test to pass:

``` swift
class KeyNumbers: NSObject {
  let items = [0,1,2,3,4,5,6,7,8,9]
}
```

This gives you a green (passing) test, from there you would refactor your code, now that you can verify the end result.

You would then move on to the next test, which may verify the type of value returned or whatever you're really meant to be working on. The idea is that you keep repeating this pattern and at the end you've got a list of all your expectations in the tests.

#### When to use TDD?

TDD works really well when you have to work on a bug, you produce the test that represents the fixed bug first (red), then you can fix the bug (green) and finally you can clean up the code you've changed. (refactor.)

I've found that TDD works well when I know a lot of the states of my view controllers up front, I would write something like this:

``` swift
override func spec() {
  describe("cells") {
    var subject: LiveAuctionHistoryCell!

    pending("looks right for open")
    pending("looks right for closed")
    pending("looks right for bid")
    pending("looks right for final call")
    pending("looks right for fair warning")
  }
}
```

Which eventually turned into: LiveAuctionBidHistoryViewControllerTests.swift

// TODO link to LiveAuctionBidHistoryViewControllerTests

Which would give me an overview of the types of states I wanted to represent. Then I could work through adding snapshots of each state to the tests, in order to make sure I don't miss anything.

In part, doing TDD with compiled languages can be tough, because you cannot easily compile against an API which doesn't exist. This makes the red step tricky. The best work around is to do stubbed data like my `items` example above.

In ruby, I would write my tests first, in Cocoa I find this harder. So I'm not a true convert, this could be the decade of not doing tests providing a negative momentum though. Established habits die hard. There are definitely very productive programmers who do test first.
