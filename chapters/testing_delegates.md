
## Patterns for Testing Using Protocols

One of the really nice things about using protocols instead of classes is that it defines a collection of methods something should act with, but doesn't force the class into a specific implementation. This works out really well because it makes it super easy to switch out the object in test because it just has to conform to said protocol. Let's look at an example of a UITableViewDataSource.

```
@interface ORArtworkDataSource <UITableViewDataSource>
@end

@interface ORArtworkDataSource
// Custom data source work, that
@end

@interface ORViewController: UITableViewController
@property (nonatomic, copy) ORArtworkDataSource *dataSource;
@end

@implementation ORViewController

- (void)viewDidLoad
{
   _dataSource = [[ORArtworkDataSource alloc] init];
   self.tableView.dataSource = self.dataSource;
}

@end
```

Switching 
