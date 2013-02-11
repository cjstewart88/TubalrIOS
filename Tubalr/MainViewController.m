//
//  MainViewController.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/10/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "MainViewController.h"
#import "NowPlayingViewController.h"
#import "SettingsViewController.h"
#import "NavigationController.h"
#import "SearchResultsViewController.h"
#import "TopGenresViewController.h"
#import "AllGenresViewController.h"
#import "SubredditViewController.h"
#import "GenreCell.h"
#import "PlaylistCell.h"
#import "SearchCell.h"
#import "TableSectionView.h"
#import "JustSimilarView.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, SearchResultsViewControllerDelegate>

@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) SearchResultsViewController *searchResultsViewController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SearchCell *searchCell;
@property (nonatomic, strong) JustSimilarView *justSimilarView;

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
    
    UIImage *profileImage = [UIImage imageNamed:@"btn-settings"];
    UIImage *image = [profileImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, profileImage.size.width, 0, 0)];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [menuButton addSubview:[[UIImageView alloc] initWithImage:image]];
    [menuButton addTarget:self action:@selector(settingsPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [self.navigationItem setLeftBarButtonItem:menuItem];
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchCell.searchBar contentsController:self];
    self.searchController.delegate = self;
//    self.searchController.searchResultsDataSource = self.searchResultsViewController;
//    self.searchController.searchResultsDelegate = self.searchResultsViewController;
    self.searchCell.delegate = self;
//    self.searchResultsViewController.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.searchController setActive:NO];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)settingsPressed:(id)sender
{
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    NavigationController *navVC = [[NavigationController alloc] initWithRootViewController:settingsVC];
    [self presentViewController:navVC animated:YES completion:nil];
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
        _searchResultsViewController = [[SearchResultsViewController alloc] init];
    }
    
    return _searchResultsViewController;
}

- (JustSimilarView *)justSimilarView
{
    if(_justSimilarView == nil)
    {
        _justSimilarView = [[JustSimilarView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 30.0f)];
    }
    
    return _justSimilarView;
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
    
    switch(indexPath.section){
        case 0:{
            NSString *cellTitle = nil;
            UIImage *cellImage = nil;
            
            if(indexPath.row == 0){
                if (!cell)
                    cell = self.searchCell;
            }
            else{
                if (!cell)
                    cell = [[GenreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlaylistCellIdentifier];
            }
            switch(indexPath.row){
                case 0:{
                    break;
                }
                case 1:{
                    cellTitle = @"Top Genres";
                    cellImage = [UIImage imageNamed:@"icon-top"];
                    break;
                }
                case 2:{
                    cellTitle = @"All Genres";
                    cellImage = [UIImage imageNamed:@"icon-all"];
                    break;
                }
                case 3:{
                    cellTitle = @"Reddit Playlists";
                    cellImage = [UIImage imageNamed:@"icon-reddit"];
                    break;
                }
            }
            
            if(indexPath.row != 0)
                [(GenreCell *)cell setImage:cellImage titleLabel:cellTitle];
            break;
        }
        
        case 1:{
            if (!cell)
                cell = [[PlaylistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlaylistCellIdentifier];
            
            cell.textLabel.text = @"Some Playlist";
            break;
        }
    }
    
    return cell;
}

#pragma mark - SearchCellDelegate

- (void)searchButtonPressedWithString:(NSString *)string
{
    SearchType searchType = [self.justSimilarView isJustSearch] ? justSearch : similarSearch;
    NowPlayingViewController *nowPlayingVC = [[NowPlayingViewController alloc] initWithSearchString:string searchType:searchType];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:nowPlayingVC animated:YES];
}

#pragma mark - SearchResultsViewControllerDelegate

- (void)selectedCell:(UITableViewCell *)cell
{
    SearchType searchType = [self.justSimilarView isJustSearch] ? justSearch : similarSearch;
    NowPlayingViewController *nowPlayingVC = [[NowPlayingViewController alloc] initWithSearchString:cell.textLabel.text searchType:searchType];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:nowPlayingVC animated:YES];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TableSectionView *sectionView = [[TableSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section]) title:@"My Custom Playlists"];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        TopGenresViewController *topVC = [[TopGenresViewController alloc] init];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:topVC animated:YES];
    }
    
    else if (indexPath.row == 2)
    {
        AllGenresViewController *allVC = [[AllGenresViewController alloc] init];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:allVC animated:YES];
    }
    
//    else if (indexPath.row == 3)
//    {
//        SubredditViewController *subVC = [[SubredditViewController alloc] init];
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//        [self.navigationController pushViewController:subVC animated:YES];
//    }
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{

}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{    
    [self.view addSubview:self.justSimilarView];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self.justSimilarView removeFromSuperview];
    [self.tableView reloadData]; //The search bar background was getting messed up unless I did this.
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    CGRect tableFrame = tableView.frame;
    tableFrame.origin.y += self.justSimilarView.bounds.size.height;
    tableFrame.size.height -= self.justSimilarView.bounds.size.height;
    [tableView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
//    [tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-noise"]]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setFrame:tableFrame];
}

@end
