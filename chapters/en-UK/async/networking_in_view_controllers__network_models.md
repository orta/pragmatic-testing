# Network Models

In another chapter, I talk about creating HTTP clients that converts async networking code into synchronous APIs. Another tactic for dealing with testing out your networking.

There are lots of clever ways to test your networking, I want to talk about the simplest. From a View Controller's perspective, all networking should go through a networking model.

A network model is a protocol that represents getting and transforming data into something the view controller can use. In your application, this will perform networking asynchronously - in tests, it is primed with data and synchronously returns those values.

Let's look at some code before we add a network model:

``` swift
class UserNamesTableVC: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    MyNetworkingClient.sharedClient().getUsers { users in
      self.names = users.map { $0.names }
    }
  }
}
```

OK, so it accesses a shared client, which returns a bunch of users - as we only need the names, we map out the names from the users and do something with that.

Let's start by defining the relationship between `UsersNameTableVC` and it's data:

``` swift
protocol UserNamesTableNetworkModelType {
  func getUserNames(completion: ([String]) -> ())
}
```

Then we need to have an object that conforms to this in our app:

```swift
class UserNamesTableNetworkModel: UserNamesTableNetworkModelType {

  func getUserNames(completion: ([String]) -> ()) {
    MyNetworkingClient.sharedClient().getUsers { users in
      completion(users.map {$0.name})
    }
  }
}
```

We can then bring this into our ViewController to handle pulling in data:

``` swift
class UserNamesTableVC: UITableViewController {

  var network: UserNamesTableNetworkModelType = UserNamesTableNetworkModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    network.getUserNames { userNames in
      self.names = userNames
    }
  }
}
```

OK, so we've abstracted it out a little, this is very similar to what happened back in the Dependency Injection chapter. To use network models to their fullest, we want to make another object that conforms to the `UserNamesTableNetworkModelType` protocol.

``` swift
class StubbedUserNamesTableNetworkModel: UserNamesTableNetworkModelType {

  var userNames = []
  func getUserNames(completion: ([String]) -> ()) {
    completion(userNames)
  }
}
```

Now in our tests we can use the `StubbedUserNamesTableNetworkModel` instead of the `UserNamesTableNetworkModel` and we've got synchronous networking, and really simple tests.

``` swift
it("shows the same amount names in the tableview") {
  let stubbedNetwork = StubbedUserNamesTableNetworkModel()
  stubbedNetwork.names = ["gemma", "dmitry"]

  let subject = UserNamesTableVC()
  subject.network = stubbedNetwork

  // Triggers viewDidLoad (and the rest of the viewXXX methods)
  subject.beginAppearanceTransition(true, animated: false)
  subject.endAppearanceTransition()

  let rows = subject.tableView.numberOfRowsInSection(0)
  expect(rows) == stubbedNetwork.names.count
}
```

This pattern has saved us a lot of trouble over a long time. It's a nice pattern for one-off networking issues, and can slowly be adopted over time.
