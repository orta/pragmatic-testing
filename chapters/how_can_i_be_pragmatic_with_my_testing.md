### What is Pragmatic Testing?

Testing is meant to help you sleep at night, and feel nonchalant about shipping a build anytime. However, you want to be able to launch your test suite, and not feel like it's a major chore. If you try to test every `if` in your app, you're going to have a bad time. 

My favourite WWDC video come from 2011, now too old to be in the search index on the website. It's called [Writing Easy-To-Change Code: Your Second-Most Important Goal As A Developer](https://developer.apple.com/videos/play/wwdc2011/112/). It talks about all the different ways in which you can build your codebase to evolve safely. Your tests shouldn't be getting in the way of your evolving product. Test coverage is about the constant battle between "perfect" and "enough", Pragmatic Testing is about siding towards "enough" more often. 

Sometimes you will need to say "I don't need to write tests for this." There _will_ be times when you'll be burned for that decision, and that's OK. It's much harder to simplify a time-expensive test suite, and it's extremely time intensive to cover 100% of your codebase. You're [shipping apps, not codebases](http://artsy.github.io/blog/2015/09/01/Cocoa-Architecture-Dropped-Design-Patterns/). At the end of the day, the tests are for developers, even when it's very likely to increase the quality of the product.

An easy example is model objects, when you have objects that have some simple functions that will probably never change, it's not worth testing the functions. If you have functions that do some complicated logic, you should make sure that's covered by multiple tests showing different inputs and outputs.

Internally we talk about coverage by using a painting analogy. There are some tools that allow you to test a lot of logic at once, for example a snapshot test for a view controller. In doing a Snapshot test, you're testing: object initialization, `viewDidLoad` behavior, `viewDid/WillAppear` behvarior, subview layouting and many more systems. On the other hand you have unit tests, which are a much finer brush for covering the edge cases which snapshots won't or can't cover.

By using multiple testing techniques, you can cover the shapes of your application, but still offers the chance to have fewer places to change as you evolve your application.