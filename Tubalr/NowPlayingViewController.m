//
//  NowPlayingViewController.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/7/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "NowPlayingViewController.h"
#import "APIQuery.h"

@interface NowPlayingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *bottomTableView;

@property (nonatomic, strong) NSArray *arrayOfData;

@end

@implementation NowPlayingViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, 180.0f)];
    self.bottomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), view.bounds.size.width, view.bounds.size.height - self.topView.bounds.size.height) style:UITableViewStylePlain];
//    self.bottomTableView.delegate = self;
//    self.bottomTableView.dataSource = self;
    
    self.topView.backgroundColor = [UIColor blueColor];
    [view addSubview:self.topView];
    [view addSubview:self.bottomTableView];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [APIQuery justSearchWithString:@"311" completion:^(NSArray* array) {
        self.arrayOfData = array;
        [self.bottomTableView reloadData];
        
        //Do something with the video here
    }];
}

-(void)willRotateToInterfaceOrientation: (UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration
{
    NSLog(@"%@", [(NSDictionary *)[self.arrayOfData objectAtIndex:0] objectForKey:@"title"]);
//    NSLog(@"%@", [(NSDictionary *)[self.arrayOfData objectAtIndex:9] objectForKey:@"title"]);
//    NSLog(@"%@", [(NSDictionary *)[self.arrayOfData objectAtIndex:19] objectForKey:@"title"]);
//    NSLog(@"%@", [(NSDictionary *)[self.arrayOfData objectAtIndex:29] objectForKey:@"title"]);
//    NSLog(@"%@", [(NSDictionary *)[self.arrayOfData objectAtIndex:39] objectForKey:@"title"]);
}

@end

