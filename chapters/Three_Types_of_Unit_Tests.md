
There is a great idea from the original TDD books that is still very valid: [Arrange, Act, Assert](http://c2.com/cgi/wiki?ArrangeActAssert), which we covered in "Unit Testing" This pattern  provides the foundation for any type of unit test, you set up, you run your test and then you verify.

There are commonly three types of Unit Tests, we’ll be taking the examples directly from the source code of [Eigen](https://github.com/artsy/eigen/). Let’s go:

## Return Value

``` objc
it(@"sets up its properties upon initialization", ^{
  // Arrange + Act
  ARShowNetworkModel *model = [[ARShowNetworkModel alloc] initWithFair:fair show:show];

  // Assert
  expect(model.show).to.equal(show);
});

```

> [ARShowNetworkModelTests.m](https://github.com/artsy/eigen/blob/6635bd8dc62186422ad6537dbc582e828bcb3776/Artsy%20Tests/ARShowNetworkModelTests.m#L18-L22)

You can setup your subject of the test, make a change to it, and check the return value of a function is what you expect. This is what you think of when you start writing tests, and inevitably Model objects are really easy to cover this way due to their ability to hold data and make information.

## State

``` objc
it(@"changes selected to deselected", ^{
  // Arrange
  ARAnimatedTickView *tickView = [[ARAnimatedTickView alloc] initWithSelection:YES];

  // Act
  [tickView setSelected:NO animated:NO];

  /// Assert
  expect(tickView).to.haveValidSnapshotNamed(@"deselected");
});

```
> [ARAnimatedTickViewTest.m](https://github.com/artsy/eigen/blob/6635bd8dc62186422ad6537dbc582e828bcb3776/Artsy%20Tests/ARAnimatedTickViewTest.m#L27-L31)

State tests work by querying the subject. In this case we’re using snapshots to investigate that the visual end result is as we expect it to be.  These tests can be a little bit more tricky than straight return value tests.

## Interaction Tests

An interaction test is more interesting because it usually involves more than just one subject.

``` objc
it(@"adds Twitter handle for Twitter", ^{

  // Arrange
  provider = [[ARMessageItemProvider alloc] initWithMessage:placeHolderMessage path:path];

  // Act
  providerMock = [OCMockObject partialMockForObject:provider];
  [[[providerMock stub] andReturn:UIActivityTypePostToTwitter] activityType];

  // Assert
  expect([provider item]).to.equal(@"So And So on @Artsy");
});
```

> [ARMessageItemProviderTests.m](https://github.com/artsy/eigen/blob/6635bd8dc62186422ad6537dbc582e828bcb3776/Artsy%20Tests/ARMessageItemProviderTests.m#L53-L61)

In this case to test the interaction between the `ARMessageItemProvider` and the `activityType` we need to mock out a section of the code that does not belong to the domain we are testing.
