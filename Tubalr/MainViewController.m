//
//  MainViewController.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/10/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "MainViewController.h"
#import "NowPlayingViewController.h"
#import "GenreCell.h"
#import "PlaylistCell.h"
#import "SearchCell.h"
#import "TableSectionView.h"
#import "SearchResultsViewController.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) SearchResultsViewController *searchResultsViewController;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SearchCell *searchCell;

@end

@implementation MainViewController

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
    self.title = @"tubalr";
    
    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchCell.searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self.searchResultsViewController;
    searchDisplayController.searchResultsDelegate = self.searchResultsViewController;
    
    self.searchController = searchDisplayController;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 4;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 0.0f;
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
        return 50.0f;
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *GenreCellIdentifier = @"GenreCell";
    static NSString *PlaylistCellIdentifier = @"PlaylistCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GenreCellIdentifier];
    
    switch(indexPath.section)
    {
        case 0:
        {
            NSString *cellTitle = nil;
            UIImage *cellImage = nil;
            
            if(indexPath.row == 0)
            {
                if (!cell)
                {
                    cell = self.searchCell;
                }
            }
            else
            {
                if (!cell)
                    cell = [[GenreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlaylistCellIdentifier];
            }
            
            switch(indexPath.row)
            {
                case 0:
                {
                    break;
                }
                case 1:
                {
                    cellTitle = @"Top Genres";
                    cellImage = [UIImage imageNamed:@"icon-top"];
                    break;
                }
                case 2:
                {
                    cellTitle = @"All Genres";
                    cellImage = [UIImage imageNamed:@"icon-all"];
                    break;
                }
                case 3:
                {
                    cellTitle = @"Reddit Playlists";
                    cellImage = [UIImage imageNamed:@"icon-reddit"];
                    break;
                }
            }
            
            if(indexPath.row != 0)
            {
                [(GenreCell *)cell setImage:cellImage titleLabel:cellTitle];
            }
            break;
        }
        
        case 1:
        {
            if (!cell)
                cell = [[PlaylistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlaylistCellIdentifier];
            
            cell.textLabel.text = @"Some Playlist";
            break;
        }
            
    }
    
    return cell;
}

- (SearchCell *)searchCell
{
    static NSString *SearchCellIdentifier = @"SearchCell";
    
    if(_searchCell == nil)
    {
        _searchCell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchCellIdentifier];
    }
    
    return _searchCell;
}

- (SearchResultsViewController *)searchResultsViewController
{
    if (_searchResultsViewController == nil)
    {
        _searchResultsViewController = [[SearchResultsViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    
    return _searchResultsViewController;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TableSectionView *sectionView = [[TableSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section]) title:@"My Custom Playlists"];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self.tableView reloadData]; //The search bar background was getting messed up unless I did this.
}

@end
