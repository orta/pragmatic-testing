# The Three Types of Unit Tests

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

You can setup your subject of the test, make a change to it, and check the return value of a function is what you expect. This is what you think of when you start writing tests, and inevitably Model objects are really easy to cover this way due to their ability to hold data and convert that to information.

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

State tests work by querying the subject. In this case we’re using snapshots to investigate that the visual end result is as we expect it to be.

These tests can be a little bit more tricky than straight return value tests, as they may require some kind of mis-direction depending on the public API for an object.

## Interaction Tests

An interaction test is more tricky because it usually involves more than just one subject. The idea is that you want to test how a cluster of objects interact in order

``` objc
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


#### Full Details

There is a [talk](https://www.youtube.com/watch?v=Jzlz3Bx-NzM) by Jon Reid of qualitycoding.org on this topic that is really the definitive guide to understanding how you can test a unit of code.

TODO: Re-watch it and flesh this out a bit more
