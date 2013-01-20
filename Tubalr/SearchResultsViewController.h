//
//  SearchResultsViewController.h
//  Tubalr
//
//  Created by Chad Zeluff on 1/19/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id delegate;

@end

@protocol SearchResultsViewControllerDelegate <NSObject>

- (void)selectedCell:(UITableViewCell *)cell;

@end