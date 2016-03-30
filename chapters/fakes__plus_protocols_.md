### Fakes

A Fake is an API compatible version of an object. That is it. Fakes are extremely easy to make in both Swift and Objective-C. Though the techniques to create them can be different.

In Objective-C fakes can be created easily using the loose typing at runtime. If you create an object that responds to the same selectors as the one you want to fake you can pass it instead by typecasting it to the original.

In Swift the use of `AnyObject` is discouraged by the compiler, so the use of fudging types doesn't work. Instead there is a higher use of protocols in the culture. This means that you can rely on a different object conforming to the same protocol to make test code run differently.

For my favourite use case of Fakes, look at the chapter on network models.

### Protocol Fakes

Using a protocol as the the
