### Snapshot Testing

The process of taking a snapshot of the view hierarchy of a UIView subclass, then storing that as a reference for what your app should look like.

### Why Bother

TLDR: Fast, easily re-producible tests of visual layouts. If you want a longer introduction, you should read my objc.io article about [Snapshott tes testing](TODO_snapshot_testing_url). I'll be assuming some familiarity from here on in.

### Techniques

We aim for snapshot tests to cover two main areas

1. Overall state for View Controllers
2. Individual States per View Component

As snapshots are the largest testing brush, and as the apps I work on tend to be fancy perspectives on remote data. Snapshot testing provides easy coverage,


### Got-chas with Testing View Controllers

Turns out to really grok why some problems happen you have to have quite a solid foundation in:

* View Controller setup process -  e.g.`viewDidLoad`, `viewDid/WillAppear` etc.
* View Controller Containment - e.g. `childViewControllers`, `definesPresentationContext` etc.

This is not useless, esoteric, knowledge though. Having a firmer understanding of this process means that you will probably write better code.
