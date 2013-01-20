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

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate> //<UITextFieldDelegate>

//@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;

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
                    cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlaylistCellIdentifier];
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

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TableSectionView *sectionView = [[TableSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section]) title:@"My Custom Playlists"];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"still");
//    if(_selectedCellIndex == indexPath.row) return;
//    _selectedCellIndex = indexPath.row;
//    
//    [self.playerView.player pause];
//    [self.playerView.player replaceCurrentItemWithPlayerItem:nil];
//    [self removePlayerItemObservations];
//    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", [(NSDictionary *)[self.arrayOfData objectAtIndex:_selectedCellIndex] objectForKey:@"youtube-id"]]];
//    LBYouTubeExtractor *extractor = [[LBYouTubeExtractor alloc] initWithURL:url quality:LBYouTubeVideoQualityMedium];
//    
//    [extractor extractVideoURLWithCompletionBlock:^(NSURL *videoURL, NSError *error) {
//        if(!error)
//        {
//            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
//            
//            NSArray *requestedKeys = [NSArray arrayWithObjects:kTracksKey, kPlayableKey, nil];
//            
//            /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
//            [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
//             ^{
//                 dispatch_async( dispatch_get_main_queue(),
//                                ^{
//                                    /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
//                                    [self prepareToPlayAsset:asset withKeys:requestedKeys];
//                                });
//             }];
//        } else {
//            NSLog(@"Failed extracting video URL using block due to error:%@", error);
//        }
//    }];
}


//- (void)buttonPressed:(id)sender
//{
//    if([sender isSelected])
//    {
//        [sender setSelected:NO];
//    }
//    else
//    {
//        [sender setSelected:YES];
//    }
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    
//    if(![textField.text isEqualToString:@""])
//    {
//        SearchType searchType = [self.typeOfSearchButton.titleLabel.text isEqualToString:@"Just"] ? justSearch : similarSearch;
//        NowPlayingViewController *nowPlayingVC = [[NowPlayingViewController alloc] initWithSearchString:textField.text searchType:searchType];
//        
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//
//        [self.navigationController pushViewController:nowPlayingVC animated:YES];
//    }
//    
//    
//    
//    return YES;
//}

@end
