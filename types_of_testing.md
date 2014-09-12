# Types of Testing

A test is a way of verifying code, and making your assumptions explicit. When you make a change somewhere tests exist to show the implicit connections between objects. In the ruby world the tests are basically considered the application's documentation.

There's a

### Unit Testing

Unit testing is the idea of testing a specific unit of code. This can range from a single Model object to a full UIViewController subclass. The idea being that you are testing and verifying a unit of application code.

### Behavioral Testing

Behavioral testing is a subset of Unit Testing, it is essentially a school of thought. The principals are that the way that you write and describe your tests should reflect the behaviors of your objects. There is a controlled vocabulary using words like "it", "describe", "spec", "before" and "after" which mean that most BDD-testing frameworks all read very similar.

### Integration Testing

Integration testing is a way of testing that your application code integrates well with external systems. The most common example of integration testing in iOS apps are user interface runners that emulate users tapping though you application. Though I am of the opinion that database and API testing fall into this category.
