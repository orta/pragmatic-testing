
## Techniques for avoiding Async Testing

Ideally an app should be running on multiple threads, with lots of work being done in the background. This means you can avoid having the user waiting for things to happen. A side effect of this is that asynchronous code can be difficult to test, for me there are three main ways to deal with this, in order of preference:

* Make asynchronous code run synchronously
* Make your main test thread wait while the work is done in the background
* Use a testing frameworks ability to have a run loop checking for a test pass

### Get in line

A friend in Sweden passed on a technique he was using to cover complex series of background jobs. In testing where he would typically use `dispatch_async` to run some code he would instead use `dispatch_sync` or just run a block directly. I took this technique and turned it into a [simple library][ar_dispatch] that allows you to toggle all uses of these functions to be asychronous or not.

This is not the only example, we built this idea into a network [abstraction layer][moya] library too. If you are making stubbed requests then they happen synchronously. This reduced complexity in our testing.

### It will happen

Testing frameworks typically have two options for running asynchronous tests, within the matchers or within the testing scaffolding. For example in Specta/Expecta you can use Specta's `waitUntil()` or Expecta's `will`.

#### Wait Until

`waitUntil` is a simple function that blocks the main thread that your tests are running on. Then after a certain amount of time, it will allow the block inside to run, and you can do your check. This method of testing will likely result in slow tests, as it will take the full amount of required time unlike Expecta's `will`.

#### Will

A `will` looks like this: `expect(x).will.beNil();`. By default it will fail after 0.3 seconds, but what will happen is that it constantly runs the expectation during that timeframe. In the above example it will keep checking if `x` is nil. If it succeeds then the  checks stop and it moves on. This means it takes as little time as possible.

### Downsides

Quite frankly though, async is something you should be avoiding. From a pragmatic perspective, I'm happy to write extra code in my app's code to make sure that it's possible to run something synchronously.

For example, we expose a `Bool` called `ARPerformWorkAsynchronously` in eigen, so that we can add `animated:` flags to things that would be notoriously hard to test.

For example, here is some code that upon tapping a button it will push a view controller. This can either be tested by stubbing out a the navigationViewController ( or perhaps providing an easy to test subclass (fake)) or you can allow the real work to happen fast and verify the real result. I'd be happy with the fake, or the real one.

```
- (void)tappedArtworkViewInRoom
{
    ARViewInRoomViewController *viewInRoomVC = [[ARViewInRoomViewController alloc] initWithArtwork:self.artwork];
    [self.navigationController pushViewController:viewInRoomVC animated:ARPerformWorkAsynchronously];
}
```

[ar_dispatch]:	https://github.com/orta/ar_dispatch
[moya]:	https://github.com/ashfurrow/Moya
