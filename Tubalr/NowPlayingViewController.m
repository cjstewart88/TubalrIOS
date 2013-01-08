//
//  NowPlayingViewController.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/7/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "NowPlayingViewController.h"
#import "APIQuery.h"

@interface NowPlayingViewController () <UITableViewDataSource, UITableViewDelegate, APIQueryDelegate>

@end

@implementation NowPlayingViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, 180.0f)];
    UITableView *bottomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), view.bounds.size.width, view.bounds.size.height - topView.bounds.size.height) style:UITableViewStylePlain];
    bottomTableView.delegate = self;
    
    topView.backgroundColor = [UIColor blueColor];
    [view addSubview:topView];
    [view addSubview:bottomTableView];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    APIQuery *apiQuery = [[APIQuery alloc] init];
    apiQuery.delegate = self;
//    [apiQuery justSearchWithString:@"311"];
}

@end

