//
//  SearchCell.h
//  Tubalr
//
//  Created by Chad Zeluff on 1/19/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
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
