# Animations

Animations are notorious for being hard to test. The problem arises from the fact that normally an animation is a fire and forget change that is handled by Apple.

### UIView animations

One way that we deal with animations in tests is by having a strict policy on always including a `animates:` bool on any function that could contain animation. We mix this with a CocoaPod that makes it easy to do animations with a boolean flag, [UIView+BooleanAnimations](https://github.com/ashfurrow/UIView-BooleanAnimations/). This provides the UIView class with an API like:

``` objc
[UIView animateIf:animates duration:ARAnimationDuration :^{
    self.relatedTitle.alpha = 1;
}];
```

Which gives the control whether to animate in a test or not to the `animates` BOOL. If this is being called inside a `viewWillAppear:` method for example, then you already have a bool to work with.

### Core Animation

It can be tough to test a core animation
