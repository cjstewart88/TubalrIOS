//
//  TeamViewController.m
//  Tubalr
//
//  Created by Chad Zeluff on 2/10/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "TeamViewController.h"
#import "CustomCell.h"

@interface TeamViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TeamViewController

- (void)loadView
{
    [super loadView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-noise"]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"team";
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TeamCellIdentifier = @"TeamCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TeamCellIdentifier];
    if(!cell)
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TeamCellIdentifier];
    
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"Cody Stewart - Founder";
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"Chad Zeluff - Mobile Developer";
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"Blake Simkins - Designer";
    }
    
    return cell;
}

@end
