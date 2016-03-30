#### How can I contribute to this book?

There's a bunch of things I've not covered, and there's still a lot of work to do based on my current Table Of Contents.

I'm happy to have other people send pull requests to the book, adding or amending chapters. Here's my general rules:

* Strive for Real-World Examples
  No `foo = bar`- even better if you can take it directly from an OSS code-base and reference it.

  Talk about personal experiences with ideas, and their trade-offs. It's great that you can test everything, but if it comes at the trade-off of a time intensive test suite. Let people know.

* Simplicity Ships
  This project is like, a million months overdue. Don't faff with changing formats or adding extra engineering work to "make things easier to write."

  Also, seriously, don't try making or improving a text editor just for this. Just use TextMate, with markdown, and "Deal with it."

* Be Opinionated
  Presenting options for anything is fine, but this book is about being pragmatic, not providing a tonne of sites to read through before being able to make a decision.

* Ship Before Promises
  I've had a lot of offers on other projects around interesting things like translations, of course I'm interested, but without proof that it's both being done, and going to get completed - it's not worth breaking "Simplicity Ships." I've got a bunch of semi-translated projects that were abandoned.

* Issues before new chapters
  Each chapter takes a good long time to write, and if you've spent a long time on something which I don't think is a good pragmatic testing pattern, then that's gonna be a shame to waste your time.

  If you're not sure, make an issue and ask. It is my name on the book, and I have to deal with repercussions / maintaining your chapters.

* Things I Obsess Over

  * Time it takes to run the test suite
  * Simplicity to test, without strongly affecting maintainability

* Things I Don't Obsess Over

 * Testing every last detail
 * Being right all the time

### Other than that?

All the book generation is done via code, in ruby via the `generate.rb` file and the `generators` folder. It's ruby, because it pre-dates Swift being a useful language.

Running `ruby generate.rb` will create an epub ( if you have `pandoc` installed (`brew install pandoc`)) generate all the files for the [GitBook](https://www.gitbook.com/book/orta/pragmatic-ios-testing/details) and update the `README.md`.

The file `generators/structure_of_pragmatic_programming.rb` contains all the path `->` chapter mapping, running `ruby generate.rb` will complain about missing paths/chapters.
