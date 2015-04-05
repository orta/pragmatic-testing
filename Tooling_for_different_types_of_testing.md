
## Tooling for testing

Choosing what you are going to base your tests on is a tricky problem. 

### BDD Frameworks

There are a few BDD frameworks in the Cocoa world. They typically are two separate libraries and fit well with each other. One part is a testing scaffolding which makes it easy to re-use code in your tests, and the other is a collection of matchers that make expressing the validations more natural. 

Typically they aim to be familiar to people who have written test using [RSpec](http://rspec.info), a ruby BDD framework.

So for example, this is a testing scaffold for the BDD framework Specta:

``` objc
`describe(@"ipad rotation support”, ^{
  it(@“changes the bounds of header”, ^{
	/// Test code
  });

  it(@“changes the font size of header”, ^{
	/// Test code
  });
});
```

and these are example matchers for its sibling library Expecta:

``` objc
expect(stackView.subviews.count).will.equal(6);
expect(stackView.subviews[0]()).to.beKindOf([UILabel class]());
```

#### The list

Go over this:  [http://www.mokacoding.com/blog/ios-testing-in-2015/](http://www.mokacoding.com/blog/ios-testing-in-2015/?utm_campaign=iOS_Dev_Weekly_Issue_191&utm_medium=email&utm_source=iOS%2BDev%2BWeekly)

#### Networking:
One of the more interesting uses of the Cocoa runtimes is that you can easily replace one method with another. This is used quite skillfully by some developers to hijack normal network requests and replace them with a stubbed request that you have set up in your test.

There are two libraries that are built to make it easy for you to hijack one request at a time and to make that run as you would like. They are [Nocilla](https://github.com/luisobo/Nocilla) and  [OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs) - I would recommend either, they both are mature, up-to-date and have expressive APIs.

There is another networking library which takes a different approach. It is [VCRURLConnection](https://github.com/dstnbrkr/VCRURLConnection) and it’s approach is to provide recorded sessions of HTTP traffic. This makes it possible to do larger integrations when you’re testing a lot of concurrent HTTP traffic. I abuse this feature to add a developer’s offline mode in an app.