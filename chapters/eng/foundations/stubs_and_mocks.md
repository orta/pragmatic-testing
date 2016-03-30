### Mocks and Stubs

A mock object is an object created by a library to emulate an existing object's API. In general there are two main types of mocks, nice/partial mocks which pass methods not stubbed to either an existing object or to nil and strict mocks which will assert when a method which isn't stubbed is called.

A stub is a method that is replaced at runtime with another implementation. It is common for a stub to not call the original method. It's useful in setting up context for when you want to use known a return value with a method.

From a personal opinion I avoid stubbing and mocking code which is under my control. When you first get started, using Mocks and Stubs feel like the perfect tool for testing code, but it becomes unweidly as it can quickly get out of sync.

A great example of when to use stubbing is when dealing with an Apple class that you cannot easily replace or use your own copy, for example the `UIScreen` instance or when trying to manipulate `UIApplication` instance.

When you own the code that you're working with, it can be easier to use a fake.
