# Introducing Tests to an New App

Oh wow, this is like a dream for me. Let's say I needed to write our biggest app, Eigen, from scratch. So that's a big app, thousands of tests. With everything I know now up-front, what would I do?

So, there's a healthy amount of restrictions in here. That's part of the point, stopping us from doing some of our biggest problems with the test-suite.

The other thing, is that I'd have our CI servers perform additional metrics on the test logs. I work on a tool called [Danger](https://github.com/danger/danger) which makes it easy to enforce team cultural rules on CI builds. Some of those rules are in here.

* **NSUserDefaults, Keychain, NSFileManager are all faked up-front.**

    This is because all of these will eventually leak into the developer's setup. Meaning tests can be different between developers. We have a series of Fakes for these classes in a library called [Forgeries](https://github.com/ashfurrow/forgeries)

* **Use the `TZ` environment variable to ensure all runs of the testing suite has the same timezone.**

    This one causes flaky tests pretty often, especially when you have a team of remote developers. You can edit the Scheme for your app's tests, and add an Environment Variable named "TZ" with the value of "Europe/London". Now everyone is running their tests in Manchester.

* **Synchronous Networking in Tests.**

    Eh, I've wrote a whole chapter or two on this, if you're not convinced after those, then a blurb won't change that.

* **Any un-stubbed networking would be an instant `NSAssert` in tests.**

    We're doing this in all our apps, it catches a bunch of problems at the moment of test creation rather than later when it's harder to debug.

* **I still would have a `ARPerformWorkAsynchronously` bool.**

    It's a constant battle against asynchronicity, and this, mixed with our [ar_dispatch](https://github.com/orta/ar_dispatch) and [UIView+Boolean](https://github.com/orta/uiview-boolean) are great tools in the battle.

  TODO: Verify URLs^


* **I would not include a mocking library**

     I think they have their place, but I'd like to see how long we can go without being forced into using one of these tools.

* **I would try and ensure that our tests can run in a non-deterministic order.**

    Specta, the testing library, doesn't have a way of doing this, nor to my knowledge does Quick. However, I know _for sure_ that the test cases I have will only work in the same order that Xcode runs that as an implementation detail. Un-doing that would require some effort, and an improvement on tooling though.

* **I would have a log parsers for Auto Layout errors, CGContext errors and tests that take a long time.**

    I would use [Danger](https://github.com/danger/danger) to look for Auto Layout errors, we see them all the time, and ignore them. We've done this for too long, and now we can't go back. Now we have the tech, but it's not worth the time investment to fix.

I'd also debate banning `will` and `asyncWait` for adding extra complications to the test-suite.
