//
//  GenresViewController.m
//  Tubalr
//
//  Created by Kyle Bock on 3/26/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "GenresViewController.h"
#import "NowPlayingViewController.h"
#import "APIQuery.h"
#import "CustomCell.h"

@interface GenresViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *genresArray;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GenresViewController

@synthesize keyPath=_keyPath;

static NowPlayingViewController* _nowPlayingVC = nil;

- (id)initWithKeyPath:(NSString*)keyPath
             andTitle:(NSString*)title
{
    self = [super init];
    if (!self)
        return nil;
    
    self.keyPath = keyPath;
    self.title = title;
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:self.keyPath options:NSKeyValueObservingOptionInitial context:nil];
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:self.keyPath]) //sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:
    {
        genresArray = [[[NSUserDefaults standardUserDefaults] objectForKey:self.keyPath] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        if(genresArray == nil && [self.keyPath isEqual: @"genres"])
        {
            [self fetchAllGenres];
        }
        else if (genresArray == nil && [self.keyPath isEqual: @"topGenres"])
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
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:self.keyPath];
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

- (void)fetchAllGenres
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = self.view.center;
    [self.view addSubview:activityView];
    [activityView startAnimating];
    
    [APIQuery librarySearchWithBlock:^(NSError *error){
        [activityView stopAnimating];
    }];
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
    return [genresArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AllGenreCellIdentifier = @"GenreCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AllGenreCellIdentifier];
    if(!cell)
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AllGenreCellIdentifier];
    
    NSString *label = [genresArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = label;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NowPlayingViewController *vc = [[NowPlayingViewController alloc] initWithSearchString:[genresArray objectAtIndex:indexPath.row] searchType:genreSearch];
    
    if ([GenresViewController nowPlayingVC] == nil) {
        [GenresViewController setNowPlayingVC:vc];
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Shared Now Playing Controller

+(NowPlayingViewController*)nowPlayingVC
{
    if (_nowPlayingVC != nil) {
        return _nowPlayingVC;
    }
    return nil;
}

+(void)setNowPlayingVC:(NowPlayingViewController *)viewController
{
    NSLog(@"Before Re-Assignment - %@", _nowPlayingVC);
    if (_nowPlayingVC == nil) {
        _nowPlayingVC = viewController;
    }
    else if (viewController != nil && ![viewController isEqual:_nowPlayingVC]) {
        NowPlayingViewController *oldVC = _nowPlayingVC;
        oldVC = nil;
        
        [[[_nowPlayingVC playerView] player] pause];
        
        _nowPlayingVC = viewController;
    }
    NSLog(@"After Re-Assignment - %@", _nowPlayingVC);
}


@end
