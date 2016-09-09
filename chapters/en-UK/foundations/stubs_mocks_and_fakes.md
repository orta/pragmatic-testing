### Mocks

A mock object is an object created by a library to emulate an existing object's API. In general there are two main types of mocks

1. _Strict Mocks_ - or probably just Mocks. These objects will only respond to what you define upfront, and will assert if they receive anything else.

1. _Nice (or Partial) Mocks_  which wrap existing objects. These mocks objects can define the methods that they should respond too, but will pass any function / messages they haven't been told about to the original.

In Objective-C you can define mocks that act as specific instance of a class, conform to specific protocols or be a class itself. In Swift this is still all up in the air, given the language's strict type system.

### Stubs

A stub is a method that is replaced at runtime with another implementation. It is common for a stub to not call the original method. It's useful in setting up context for when you want to use a known return value with a method.

You can think of it as being method swizzling, really.

### Mocks and Stubs

From a personal opinion I avoid stubbing and mocking code which is under my control.

When you first get started, using Mocks and Stubs feel like the perfect tool for testing code, but it becomes unwieldy as it can quickly get out of sync with reality. They can be a great crutch, when you really can't figure out how to test something however.

A great example of when to use stubbing is when dealing with an Apple class that you cannot easily replace or use your own copy. For example I regularly use partial mocks of `UIScreen` instances in order to emulate being on an iPad simulator when it's actually running on an iPhone simulator. This saves us time from running our test-suite twice, sequentially, on multiple simulators.

When you own the code that you're working with, it can often be easier to use a fake.

### Fakes

A Fake is an API compatible version of an object. That is it. Fakes are extremely easy to make in both Swift and Objective-C.

In Objective-C fakes can be created easily using the loose typing at runtime. If you create an object that responds to the same selectors as the one you want to fake you can pass it instead by typecasting it to the original.

In Swift the use of `AnyObject` is discouraged by the compiler, so the use of fudging types doesn't work. Instead, you are better off using a protocol. This means that you can rely on a different object conforming to the same protocol to make test code run differently. It provides a different level of coupling.

For my favourite use case of Fakes, look at the chapter on Network Models, or Testing Delegates.
