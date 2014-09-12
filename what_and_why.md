## What is this book?

This is a book that aims to be a down to earth guide to testing iOS applications. It came out of a long period of writing tests to multiple non-trivial Apps whilst working at [Artsy](http://artsy.net).

I found very few consolidated resources for testing in iOS general. A lot of the best book advice revolved around reading books about Java and C# and applying the techniques to Objective-C projects. Like any creative output this book does not live in a vacuum, the books I used to get to this point are in the recommendations section.

Finally this is not a generic iOS Testing book. I will not be objective. This is a pragmatic book from a pragmatic programmer known for making things, not architecting things. There will be things you disagree with, and I'm of the _strong opinions, weakly held_ camp but this is drawn from real-world experience.

## About the author, and contributors

Orta Therox is a programmer at Artsy, and gave himself the title Design Dictator at the open source project CocoaPods. His interest in testing piqued when the Artsy mobile team shrank to just him and he realized that he's going to get the blame for everything from that point forward.

There are a lot of times that I say we, meaning the Artsy Mobile team. I don't think I would be writing this book without these people contributing testing ideas to our codebase. Thanks Daniel Doubrovkine, Laura Brown, Ash Furrow and Dustin Barker. I owe you all.

## Who is it for?

Anyone interested in applying tests to iOS applications. Which hopefully should be a large amount of people.


## Swift or Objective-C?

It's easy to get caught up in what's new, but in reality there's a lot of existing Objective-C code-bases out there. The majority of this book focuses on Objective-C testing tools, with hat tips given to Swift frameworks. However at the time of writing this book CocoaPods support for Swift is mostly non-existent, and I have only a few months of experience writing tests for Swift code.

It would be disingenious for me to offer pragmatic advice without a solid foundation of my own to build on. At least I can offer that you can see live test code within an [Artsy Swift app called Eidolon](https://github.com/artsy/eidolon).
