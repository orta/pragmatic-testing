# Types of Testing

A test is a way of verifying code, and making your assumptions explicit. Tests exist to show connections between objects. When you make a change somewhere, tests reveal implicit connections.

In the Ruby world the tests are basically considered the application's documentation. This is one of the first port of calls for understanding how systems work after reading the overview/README. It's quite similar with node. Both languages are interpreted languages where even variable name typos only show themselves in runtime errors. Without a compiler, you can catch this stuff only with rigorous testing.

In Cocoa, this is less of a problem as we can rely on the tooling more. Given a compiler, static type systems, and a well integrated static analyser -- you can know if your code is going to break someone else's very quickly. However, this is only a lint, the code compiling doesn't mean that it will still correctly show a view controller when you tap a button. In other words, the behaviour of your app can still be wrong.

That is what testing is for. I will cover three major topics in this book. There are many, many other types of testing patterns -- for example, last week I was introduced to Model Testing. However, these three topics are the dominent patterns that exist within the Cocoa world, and I have experience with them. Otherwise, I'd just be copy & pasting from Wikipedia.

### Unit Testing

Unit testing is the idea of testing a specific unit of code. This can range from a function, to a single Model to a full `UIViewController` subclass. The idea being that you are testing and verifying a unit of application code. Where you draw the boundary is really up to you, but for pragmatic reasons we'll mostly stick to functions and objects because they easily match our mental model of a "thing," that is, a Unit.

### Integration Testing

Integration testing is a way of testing that your application code integrates well with external systems. The most common example of integration testing in iOS apps are user interface runners that emulate users tapping though you application.

### Behavioural Testing

Behavioural testing is essentially a school of thought. The principles state that the way you write and describe your tests should reflect the behaviours of your objects. There is a controlled vocabulary using words like "it", "describe", "spec", "before" and "after" which mean that most BDD-testing frameworks all read very similar. 

This school of thought has also brought about a different style of test-driving the design of your app: instead of strictly focusing on a single unit and developing your app from the inside-out, behaviour-driven development sometimes favors working outside-in. This style could start with a failing integration test that describes a feature of the app and lead you to discover new Unit Tests on the way to make the feature tes t "green." Of course it's up to you how you utilize a BDD framework: the difference in typing test cases doesn't force you to change your habits.
