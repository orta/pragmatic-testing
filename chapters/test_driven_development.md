### Test Driven Development

It's been said recently [that TDD is dead](TODO_tdd_is_dead). I'm not too sold on the idea that it's dead, personally. I think for the Cocoa community, TDD has barely even started.

Test Driven Development is the idea of:

* Red
* Green
* Refactor

In that, you start with a test, which will fail:

```swift
it("has ten items") {
  expect(subject.items.count) == 10
}
```

Then you do the minimum possible to get that test to pass:

``` swift
class MyThing: NSObject {
  let items = [0,1,2,3,4,5,6,7,8,9]
}
```

This gives you a green (passing) test, from there you would refactor your code, now that you can verify the end result.

You would then move on to the next test, which may verify the type of value returned or whatever you're really meant to be working on. The idea is that you keep repeating this pattern and at the end you've got a list of all your expectations in the tests.

Pragmatically speaking, I don't do Test Driven Development. Though, there are times when it is easier to write tests to verify something, as opposed to writing it and testing.

In part, doing TDD with compiled languages can be tough, because you cannot easily build against an API which doesn't exist. This makes the red step tricky. The best work around is to do stubbed data like my `items` example above.


