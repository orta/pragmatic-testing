## Snapshot Testing

The process of taking a snapshot of the view hierarchy of a UIView subclass, then storing that as a reference for what your app should look like.

### Why Bother

TLDR: Fast, easily re-producible tests of visual layouts. If you want a longer introduction, you should read my objc.io article about [Snapshott tes testing](TODO_snapshot_testing_url). I'll be assuming some familiarity from here on in.

### Techniques

We aim for snapshot tests to cover two main areas

1. Overall state for View Controllers
2. Individual States per View Component

As snapshots are the largest testing brush, and as the apps I work on tend to be fancy perspectives on remote data. Snapshot testing provides easy coverage, for larger complex objects like view controllers where we can see how all the pieces come together. They can then provide a finer grained look at individual view components.

Let's use some real-world examples.

#### A simple UITableViewController subclass

I have a `UITableViewController` subclass that shows the bid history of a live auction, `LiveAuctionBidHistoryViewController`. It receives a collection of events and presents each as a different looking cell.

[LiveAuctionBidHistoryViewController]() - [Real Tests]()

TODO: Add links ^

#### Custom Cells

Ideally you should have _every_ state covered  at View level. This means for every possible major style of the view, we want to have a snapshot covering it

```swift
class LiveAuctionBidHistoryViewControllerTests: QuickSpec {
  [...]
  override func spec() {
    describe("cells") {
      var subject: LiveAuctionHistoryCell!

      it("looks right for open") {
          let event = LiveEvent(JSON: ["type" : "open", "id" : "OK"])

          subject = self.setupCellWithEvent(event)
          expect(subject).to( haveValidSnapshot() )
      }

      it("looks right for closed") { [...] }
      it("looks right for bid") { [...] }
      it("looks right for final call") { [...] }
      it("looks right for fair warning") { [...] }
    }
  }
}
```

This means we have a good coverage of all the possible states for the data. This makes it easy to do code-review as it shows the entire set of possible styles for your data.

The View Controller is where it all comes together, in this case, the View Controller isn't really doing anything outside of showing a collection of cells. It is given a collection of items, it does the usual `UITableView` datasource and delegate bits and it shows the history. Simple.

So for the View Controller, we only need a simple test:

``` swift
class LiveAuctionBidHistoryViewControllerTests: QuickSpec {
  override func spec() {
    describe("view controller") {
      it("looks right with example data") {
        let subject = LiveAuctionBidHistoryViewController()

        // Triggers viewDidLoad (and the rest of the viewXXX methods)
        subject.beginAppearanceTransition(true, animated: false)
        subject.endAppearanceTransition()

        subject.lotViewModel = StubbedLotViewModel()
        expect(subject).to( haveValidSnapshot() )
      }
    }
  }
}
```

This may not show all the different types of events that it can show, but those are specifically handled by the View-level tests, not at the View Controller.

### A Non-Trivial View Controller

TODO: Energy's `AREditAlbumArtistViewController``

### Common issues with Testing View Controllers

Turns out to really grok why some problems happen you have to have quite a solid foundation in:

* View Controller setup process -  e.g.`viewDidLoad`, `viewDid/WillAppear` etc.
* View Controller Containment - e.g. `childViewControllers`, `definesPresentationContext` etc.

This is not useless, esoteric, knowledge though. Having a firmer understanding of this process means that you will probably write better code.
