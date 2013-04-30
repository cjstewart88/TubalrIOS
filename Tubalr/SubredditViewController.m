//
//  SubredditViewController.m
//  Tubalr
//
//  Created by Chad Zeluff on 2/10/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "SubredditViewController.h"
#import "NowPlayingViewController.h"
#import "APIQuery.h"
#import "CustomCell.h"

@interface SubredditViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *subredditDictionary;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SubredditViewController

- (id)init
{
    self = [super init];
    if(!self)
        return nil;
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"subreddits" options:NSKeyValueObservingOptionInitial context:nil];
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSDictionary *defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    if([keyPath isEqualToString:@"subreddits"]) //sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:
    {
        subredditDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"subreddits"];
        if(subredditDictionary == nil)
        {
            [self fetchAllSubreddits];
        }
        else
        {
            [self.tableView reloadData];
        }
    }
}

- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"subreddits"];
}

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
	self.title = @"reddit playlists";
}

- (void)fetchAllSubreddits
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = self.view.center;
    [self.view addSubview:activityView];
    [activityView startAnimating];
    
    [APIQuery librarySearchWithBlock:^(NSError *error){
        [activityView stopAnimating];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
//    return [categoriesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AllGenreCellIdentifier = @"AllGenreCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AllGenreCellIdentifier];
    if(!cell)
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AllGenreCellIdentifier];
    
//    NSString *label = [allGenresArray objectAtIndex:indexPath.row];
//    
//    cell.textLabel.text = label;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NowPlayingViewController *nowPlayingVC = [[NowPlayingViewController alloc] initWithSearchString:[categoriesArray objectAtIndex:indexPath.row] searchType:genreSearch];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationController pushViewController:nowPlayingVC animated:YES];
}

@end
