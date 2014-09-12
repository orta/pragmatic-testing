# Introducing Tests to an Existing App

We introduced tests into the first Artsy iOS App around the time that it hit 100,000 lines of code (including `Pods/`). The app was the product of a hard and unmovable deadline. We pushed out two patch releases after that, then sat back to try and figure out how to switch make the app friendly to new developers.

We introduced some ground rules:

* All bug fixes get a test.
* Nearly all new code gets tested.
* Code you touch in the process should get cleaned, and tested.

At the same time we agreed on a style change. Braces at the end of methods would move down to the next line. This meant we would know up-front whether code should be [considered legacy](http://www.amazon.com/Working-Effectively-Legacy-Michael-Feathers/dp/0131177052) or not.

Needs tests
```
- (void)method {
  ...
}
```

Covered
```
- (void)method
{
  ...
}
```

This style change was agreed on throughout our apps as a reminder that there was work to be done.

I would still get started in an existing project without tests this way, make it obvious what is and what isn't under tests. Then start with some small bugs, think of a way to prove the bug wrong in code then add the test.

Once we were confident with our testing flow from the smaller bugs. We discussed internally what parts of the app were we scared to touch. This was easy for us, and that was authentication for registering and logging in.

It was a lot of hastily written code, as it had a large amount of callbacks and a lot of hundred line+ methods. That was the first thing to hit 100% test coverage. I'm not going to say it was easy, but I would have no issues letting people make changes there presuming the tests pass.
