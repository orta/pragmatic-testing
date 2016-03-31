# Developer Operations

There are days when I get really excited about doing some dev-ops. There are some days I hate it. Let's examine some of the key parts of a day to day work flow for a pragmatic programmer:

## Single line commands

We use a `Makefile` like its 1983. `Makefile`s are a very simple ancient mini-language built on top of shell scripts. These are commonly used to run tasks. We use them for a wide range of tasks:

  * Bootstrapping From a Fresh Repo Clone
  * Updating Mogenerator Objects from a .xcdatamodel
  * Updating App Storyboard Constants
  * Building the App
  * Cleaning the Apps build folder
  * Running Tests
  * Generating Version Info for App Store Deploys
  * Preparing for deploys
  * Deploying to HockeyApp

## Code Review

Code Review is an important concept because it enforces a strong deliverable. It is a statement of action and an explanation behind the changes. I use github for both closed and open source code, so for me Code Review is always done in the form of Pull Requests. Pulls Requests can be linked to, can close other issues on merging and have an extremely high-functioning toolset around code discussions.

When you prepare for a code review it is a reminder to refactor, and a chance for you to give your changes a second look. It's obviously useful for when there are multiple people on a project ( in which case it is a good idea to have different people do code reviews each time ) but there’s also value in using code reviews to keep someone else in the loop for features that affect them.

Finally Code Review is a really useful teaching tool. When new developers were expressed interest in working on the mobile team then I would assign them merge rights on smaller Pull Requests and explain everything going on. Giving the merger the chance to get exposure to the language before having to write any themselves.

When you are working on your own it can be very difficult to maintain this, especially when you are writing projects on your own. An fellow Artsy programmer, Craig Spaeth does this beautifully when working on his own, here are some example [pull requests](https://github.com/artsy/positron/pulls?utf8=✓&q=is%3Aclosed+is%3Apr+author%3Acraigspaeth+%40craigspaeth). Each Pull Request is an atomic set of changes so that he can see what the larger goal was each time.

## Continuous Integration

Once you have some tests running you're going to want a computer to run that code for you. Pulling someone's code, testing it locally then merging it into master gets boring very quickly. There are three major options in the Continous Integration (CI) world, and they all have different tradeoffs.

### Self hosted

#### Jenkins

Jenkins is a popular language agnostic self-hosted CI server. There are many plugins for Jenkins around getting set up for github authentication, running Xcode projects and deploying to Hockey. It runs fine on a Mac, and you just need a Mac Mini set up somewhere that recieves calls from a github webhook. This is well documented on the internet.

The general trade off here is that it is a high-cost on developer time. Jenkins is stable but requires maintainance around keeping up to date with Xcode.

#### Buildkite.io

Travis is awesome, but they’re pretty slow with releases. Buildkite lets you run your own travis-like CI system on your own hardware. This means easily running tests for Xcode betas. It differs from Jenkins in it’s simplicty. It requires significanly less setup, and require less maintainace overall. It is a program that is ran on your hardware

#### Xcode Bots

Xcode bots is still a bit of a mystery, though it looks like with it's second release it is now at a point where it is usable. I found them tricky to set up, and especially difficult to work with when working with a remote team and using code review.

An Xcode bot is a service running on a Mac Mini, that periodically pings an external repoistory of code. It will download changes, run optional before and after scripts and then offer the results in a really beautiful user interface directly in Xcode.


### Services

It's nice to have a Mac mini to hand, but it can be a lot of maintainace. Usually these are things you expect like profiles, certificates and signing. A lot of the time though it's problems with Apple's tooling. This could be Xcode shutting off halfway though a build, the Keychain locking up, the iOS simulator not launching or the test-suite not loading. For me, working at a company as an iOS developer I don't enjoy, nor want to waste time with issues like this. So I have a bias towards letting services deal with this for me.

#### Travis CI

Travis CI is a CI server that is extremely popular in the Open Source World. We liked it so much in CocoaPods that we decided to include setup for every CocoaPod built with our toolchain. It is used by most programming communities due to their free-if-open-source pricing.

Travis CI is configured entirely via a `.travis.yml` file in your repo which is a YAML file that lets you override different parts of the install/build/test script. It has support for local dependency caching. This means build times generally do not include pulling in external CocoaPods and Gems, making it extremely fast most of the time.

I really like the system of configuring everything via a single file that is held in your repository. It means all the necessary knowledge for how your application is tested is kept with the application itself.

##### Bitrise.io

Bitrise is a newcomer to the CI field and is focused exclusively on iOS. This is a great thing. They have been known to have both stable and betas builds of Xcode on their virtual machines. This makes it possible to keep your builds green while you add support for the greatest new things. This has, and continues to be be a major issue with Travis CI in the past.

Bitrise differs from Travis CI in that it's testing system is ran as a series of steps that you can run from their website. Because of this it has a much lower barrier to entry. When given some of my simpler iOS Apps their automatic setup did everything required with no configuration.

##### Circle CI

[to come]

#### Build

## Internal Deployment

I don’t trust Apple’s Testflight service, it seems to be that there’s a problem with it everyday. Like a lot of Apple technologies, you should avoid version one unless you're willing to lose time to it.

However, I trust in solid, mature processes when it is your apps first impression. I deploy the internal versions of our applications as enterprise application so that anyone in our company can get the application with just a URL. We use URL shorteners to make these very easy for anyone to remember within the team.

We deploy to HockeyApp via a single command in terminal, this lowers the mental barrier to creating a build for everyone and allows a developer to fire and forget.

## iTunes deployment

2015 was a good year for deployment to the App Store, as [Felix Krause](http://www.krausefx.com) released a series of command line tools to do everything from generating snapshots to deploying to iTunes. This suite of tools is called [Fastlane](https://fastlane.tools) and I can’t recommend it enough.

Getting past the mental barrier of presuming an iTunes deploy takes a long time means that you feel more comfortable releasing new builds often. More builds means less major breaking changes,  reducing problem surface area between versions.
