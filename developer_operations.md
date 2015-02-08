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

Code Review is an important concept because it enforces a strong deliverable. It is a statement of action and an explanation behind the changes. I use github for both closed and open source code, so for me Code Review is done in the form of Pull Requests. Pulls Requests can be linked to, can close other issues on merging and have an extremely high-functioning toolset around code discussions.

When you prepare for a code review it is a reminder to refactor, and a chance for you to give your changes a second look. It's obviously useful for when there are multiple people on a project ( in which case it is a good idea to have different people do code reviews each time ) but there’s also value in using code reviews to keep someone else in the loop for features that affect them.

Finally Code Review is a really useful teaching tool. When new developers were expressed interest in working on the mobile team then I would assign them merge rights on smaller Pull Requests and explain everything going on. Giving the merger the chance to get exposure to the language before having to write any themselves.

## Continuous Integration

Once you have some tests running you're going to want a computer to run that code for you. Pulling someone's code, testing it locally then merging it into master gets boring very quickly. There are three major options in the Continous Integration (CI) world, and they all have different tradeoffs.

#### Jenkins

Jenkins is a popular language agnostic self-hosted CI server. There are many plugins for Jenkins around getting set up for github authentication, running Xcode projects and deploying to Hockey. It runs fine on a Mac, and you just need a Mac Mini set up somewhere that recieves calls from a github webhook. This is well documented on the internet.

The general trade off here is that it is a high-cost on developer time. Jenkins is stable but requires maintainance around keeping up to date with Xcode.  

#### Travis CI

Travis CI is a CI server that is extremely popular in the Open Source World. We liked it so much in CocoaPods that we decided to include setup for every CocoaPod built with our toolchain.

Travis CI is configured entirely via a `.travis.yml` file in your repo which is a YAML file that lets you override different parts of the install/build/test script. With a private account it has support for local dependency caching. This means build times generally do not include pulling in external CocoaPods and Gems, making it extremely fast.

#### Xcode Bots

Xcode bots is still a bit of a mystery, though it looks like with it's second release it is now at a point where it is usable. It features before and after scripts so you can get it set up

## Deployment