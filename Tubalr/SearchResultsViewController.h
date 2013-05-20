//
//  SearchResultsViewController.h
//  Tubalr
//

#import <UIKit/UIKit.h>

@interface SearchResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id delegate;

@end

@protocol SearchResultsViewControllerDelegate <NSObject>

- (void)selectedCell:(UITableViewCell *)cell;

@end