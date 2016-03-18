# Xcode Terminology


### Target

[official link](https://developer.apple.com/library/ios/featuredarticles/XcodeConcepts/Concept-Targets.html)

A target is a product that Xcode can generate based on source code. For example, an app. All the Xcode default project templates create a target for you app, and a target for your tests.


### Scheme

[official link](https://developer.apple.com/library/ios/featuredarticles/XcodeConcepts/Concept-Schemes.html#//apple_ref/doc/uid/TP40009328-CH8-SW1)

A scheme wraps a collection of targets ( think all the pods that need to compile, and your app ) then provides a build environment for them. This is comprised of build settings, build configurations and potentially a list of tests. You can use schemes to only trigger some tests to run, instead of all of the available ones.

