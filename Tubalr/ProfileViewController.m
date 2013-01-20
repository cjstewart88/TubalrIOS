//
//  ProfileViewController.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/20/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "ProfileViewController.h"
#import "MainViewController.h"
#import "TableSectionView.h"
#import "ProfileCell.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ProfileViewController

- (void)loadView
{
    [super loadView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-noise"]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"profile";
//    self.navigationItem.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    
    UIImage *profileImage = [UIImage imageNamed:@"btn-profile"];
    UIImage *image = [profileImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, profileImage.size.width, 0, 0)];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [menuButton addSubview:[[UIImageView alloc] initWithImage:image]];
    [menuButton addTarget:self action:@selector(profilePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [self.navigationItem setRightBarButtonItem:menuItem];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)profilePressed:(id)sender
{
    MainViewController *mainVC = [[MainViewController alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:mainVC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else if (section == 1)
        return 3;
    else if (section == 2)
        return 2;
    else if (section == 3)
        return 1;
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ProfileCellIdentifier = @"ProfileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCellIdentifier];
    
    switch(indexPath.section){
        case 0:{
            if (!cell)
                cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProfileCellIdentifier];
            
            cell.textLabel.text = @"Some Setting";
            break;
            break;
        }
            
        case 1:{
            if (!cell)
                cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProfileCellIdentifier];
            
            cell.textLabel.text = @"Some Setting";
            break;
        }
            
        case 2:{
            if (!cell)
                cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProfileCellIdentifier];
            
            cell.textLabel.text = @"Some Setting";
            break;
        }
            
        case 3:{
            if (!cell)
                cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProfileCellIdentifier];
            
            cell.textLabel.text = @"Some Setting";
            break;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TableSectionView *sectionView = [[TableSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section]) title:@"Heading Goes Here"];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end