# Types of Testing

A test is a way of verifying code, and making your assumptions explicit. When you make a change somewhere, tests exist to show the implicit connections between objects.

In the ruby world the tests are basically considered the application's documentation. This is one of the first port of calls for understanding how systems work after reading the overview/README.

In Cocoa, this is less of a problem as we can rely on the tooling more. Given a compiler, static type systems, and a well integrated static analyser - you can know if your code is going to break someone else's very quickly. However, this is only a lint, the code compiling doesn't mean that it will still correctly show a view controller when you tap a button.

That is what testing is for. I will cover three major topics in this book - there are many, many other types of testing patterns ( for example, last week I was introduced to Model Testing. ) However, These are the dominent patterns that exist within the Cocoa world, and I have experience with them. Otherwise, I'd just be copy & pasting from Wikipedia.

### Unit Testing

Unit testing is the idea of testing a specific unit of code. This can range from a function, to a single Model to a full `UIViewController` subclass. The idea being that you are testing and verifying a unit of application code.

### Behavioural Testing

Behavioural testing is a subset of Unit Testing, it is essentially a school of thought. The principals are that the way that you write and describe your tests should reflect the behaviours of your objects. There is a controlled vocabulary using words like "it", "describe", "spec", "before" and "after" which mean that most BDD-testing frameworks all read very similar.

### Integration Testing

Integration testing is a way of testing that your application code integrates well with external systems. The most common example of integration testing in iOS apps are user interface runners that emulate users tapping though you application.
