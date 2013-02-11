//
//  TopGenresViewController.m
//  Tubalr
//
//  Created by Chad Zeluff on 2/10/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "TopGenresViewController.h"
#import "NowPlayingViewController.h"
#import "APIQuery.h"
#import "CustomCell.h"

@interface TopGenresViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *topGenresArray;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TopGenresViewController

- (id)init
{
    self = [super init];
    if(!self)
        return nil;
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"topGenres" options:NSKeyValueObservingOptionInitial context:nil];
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"topGenres"]) //sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:
    {
        topGenresArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"topGenres"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        if(topGenresArray == nil)
        {
            [self fetchTopGenres];
        }
        else
        {
            [self.tableView reloadData];
        }
    }
}

- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"topGenres"];
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
	self.title = @"top genres";
}

- (void)fetchTopGenres
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
    return [topGenresArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TopGenreCellIdentifier = @"TopGenreCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TopGenreCellIdentifier];
    if(!cell)
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopGenreCellIdentifier];
    
    NSString *label = [topGenresArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = label;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NowPlayingViewController *nowPlayingVC = [[NowPlayingViewController alloc] initWithSearchString:[topGenresArray objectAtIndex:indexPath.row] searchType:genreSearch];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:nowPlayingVC animated:YES];
}

@end
