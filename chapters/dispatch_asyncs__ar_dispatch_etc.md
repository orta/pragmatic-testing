
## Techniques for avoiding Async Testing

Ideally an app should be running on multiple threads, with lots of work being done in the background. A side effect of this is that asynchronous code can be difficult to test, for me there are three main ways to deal with this, in order of preference:

* Make asychronous code run synchronously
* Use a testing frameworks ability to have a run loop checking for a test pass
* Make your main test thread wait while the work is done in the background

### Get in line

A friend in Sweden passed on a technique he was using to cover complex series of background jobs. In testing where he would typically use `dispatch_async` to run some code he would instead use `dispatch_sync` or just run a block directly. I took this technique and turned it into a [simple library][1] that allows you to toggle all uses of these functions to be asychronous or not. 

This is not the only example, we built this idea into a network [abstraction layer][2] library too. If you are making stubbed requests then they happen synchronously. This reduced complexity in our testing.

### It will happen

Testing frameworks typically have two options for running aychronous test, within the matchers or within the testing scaffolding. For example


[1]:	https://github.com/orta/ar_dispatch
[2]:	https://github.com/ashfurrow/Moya