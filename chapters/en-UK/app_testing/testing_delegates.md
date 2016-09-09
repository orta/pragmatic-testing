## Patterns for Testing Using Protocols

One of the really nice things about using protocols instead of classes is that it defines a collection of methods something should act with, but doesn't force the relationship into specific implementations.

This works out really well, because it makes it super easy to switch out the object in test, as it just has to conform to said protocol. Let's look at an example of a tricky to test `UITableViewDataSource`.

This example has a class whose responsibility is to deal with getting data, and providing that to a tableview.

``` swift
class ORArtworkDataSource, NSObject, UITableViewDataSource {
    // Do some networking, pull in some data, make it possible to generate cells
    func getData() {
      [...]
    }
    [...]
}

class ORArtworkViewController: UITableViewController {
    var dataSource: ORArtworkDataSource!

    [...]
    override func viewDidLoad() {
        dataSource = ORArtworkDataSource()
        tableView.dataSource = dataSource
        dataSource.getData()
    }
}
```

This implementation is great if you don't want to write any tests, but it can get tricky to find ways to have your tests perform easy-to-assert on behavior with this tactic.

One of the simplest approaches to making this type of code easy to test is to use lazy initialisation, and a protocol to define the expectations but not the implementation.

So, define a protocol that says what methods the `ORArtworkDataSource` should have then only let the `ORArtworkViewController` know it's talking to something which conforms to this protocol.

```swift

/// This protocol abstracts the implementation details of the networking
protocol ORArtworkDataSourcable {
    func getData()
}

class ORArtworkDataSource: NSObject, ORArtworkDataSourcable, UITableViewDataSource {
    // Do some networking, pull in some data, make it possible to generate cells
    func getData() {
        [...]
    }

    [...]
}

class ORArtworkViewController: UITableViewController {

    // Allows another class to change the dataSource,
    // but also will fall back to ORArtworkDataSource()
    // when not set
    lazy var dataSource: ORArtworkDataSourcable = {
      return ORArtworkDataSource()
    }()

    [...]
    override func viewDidLoad() {
        tableView.dataSource = dataSource
        dataSource.getData()
    }
}

```

This allows you to create a new object that conforms to `ORArtworkDataSourcable` which can have different behaviour in tests. For example:

```swift
it("shows a tableview cell") {
    subject = ORArtworkViewController()
    subject.dataSource = ORStubbedArtworkDataSource()
    // [...]
    expect(subject.tableView.cellForRowAtIndexPath(index)).to( beTruthy() )
}
```

There is a great video from Apple called [Protocol-Oriented Programming in Swift](https://developer.apple.com/videos/play/wwdc2015/408/) that covers this topic, and more. The video has a great example of showing how you can test a graphic interface by comparing log files because of the abstraction covered here.

The same principles occur in Objective-C too, don't think this is a special Swift thing, the only major new change for Swift is the ability for a protocol to offer methods, allowing for a strange kind of multiple inheritence.

Examples in practice, mostly Network models:

* Eigen - [ARArtistNetworkModel](https://github.com/artsy/eigen/blob/da011cb4e0cd45e9148e89b92a4021ea3651753f/Artsy/Networking/Network_Models/ARArtistNetworkModel.h) is a protocol which `ARArtistNetworkModel` and `ARStubbedArtistNetworkModel` conform to. Here are some [tests using the technique.](https://github.com/artsy/eigen/blob/da011cb4e0cd45e9148e89b92a4021ea3651753f/Artsy_Tests/View_Controller_Tests/Artist/ARArtistViewControllerTests.m#L25)

* Eidolon - [BidderNetworkModel](https://github.com/artsy/eidolon/blob/16867a8de52fdf24db07937be003b6104c0ee5e9/Kiosk/Bid%20Fulfillment/BidderNetworkModel.swift) `BidderNetworkModelType` is a protocol that `BidderNetworkModel` and `StubBidderNetworkModel` conform to. Here are [tests using the technique](https://github.com/artsy/eidolon/blob/16867a8de52fdf24db07937be003b6104c0ee5e9/KioskTests/Bid%20Fulfillment/LoadingViewModelTests.swift)
