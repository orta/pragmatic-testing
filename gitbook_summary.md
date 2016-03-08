## What is this book?

This is a book that aims to be a down to earth guide to testing iOS applications. It came out of a long period of writing tests to multiple non-trivial Apps whilst working at [Artsy](http://artsy.net). All of which are open source, and available for inspection on the [Artsy Open Source page](http://artsy.github.io/open-source/#ios).

I found very few consolidated resources for testing in iOS general. A lot of the best book advice revolved around reading books about Java and C# and applying the techniques to Objective-C projects. Like any creative output this book does not live in a vacuum, the books I used to get to this point are in the recommendations section.

Finally this is not a generic iOS Testing book. I will not be objective. This is a pragmatic book from a pragmatic programmer known for making things, not architecting beautiful concepts. There will be things you disagree with, and I'm of the _strong opinions, weakly held_ so you're welcome to send me feedback as issues on [orta/pragmatic-testing](https://github.com/orta/pragmatic-testing)

I treat this book very similar to how I would a collection of smaller blog posts, so I aim to have it well hyperlinked. There are a lot of great resources out there, and this can spring you out into other resources. I'd rather not re-write someone when I can quote.

## About the author, and contributors

I'm the head of mobile at Artsy, and I gave myself the title Design Dictator at the open source project [CocoaPods](https://cocoapods.org). My interest in testing piqued when the entire Artsy mobile team became just me, and I realized that I'm going to get the blame for everything from this point forward. Better up my game.

There are a lot of times that I say we, meaning the [Artsy Mobile team](https://github.com/artsy/mobile/). I don't think I would be writing this book without these people contributing testing ideas to our codebase. Thanks, Daniel Doubrovkine, Laura Brown, Ash Furrow, Eloy Durán, Sarah Scott, Maxim Cramer & Dustin Barker. I owe you all.

Finally, I want to thank Danger. She gives me time and space to achieve great things. I wouldn't be the person I am without her.

## Who is it for?

Anyone interested in applying tests to iOS applications. Which hopefully should be a large amount of people. I'm trying to aim this book at myself back in 2012, new to the ideas of testing and seeing a whole world of possibilities, but not knowing exactly where to start or how to continue once I've made one or two tests.

## Swift or Objective-C?

It's easy to get caught up in what's new and shiny, but in reality there's a lot of existing Objective-C code-bases out there. I  will aim to try and cover both Swift and Objective-C. As we have test suites in both languages, some concepts work better in one language vs the other. If you can only read one language, I'm not apologising for that. It's not pragmatic to only focus like that.

One great thing about writing examples in Swift though is that it's far more concise.