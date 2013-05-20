//
//  SearchCell.h
//  Tubalr
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"

@interface SearchCell : CustomCell

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, weak) id delegate;

@end

@protocol SearchCellDelegate <NSObject>

- (void)searchButtonPressedWithString:(NSString*)string;

@end
