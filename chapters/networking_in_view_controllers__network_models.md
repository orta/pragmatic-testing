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
  func getUserNames(completion: () -> ([String]))
}
```

Then we need to have an object that conforms to this in our app:

```swift
class UserNamesTableNetworkModel: UserNamesTableNetworkModelType {
  func getUserNames(completion: () -> ([String])) {
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

OK, so we've abstracted it out a little, this is very similar to what happened back in the Dependency Injection chapter.
