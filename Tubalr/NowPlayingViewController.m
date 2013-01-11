//
//  NowPlayingViewController.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/7/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "NowPlayingViewController.h"
#import "APIQuery.h"
#import "NowPlayingCell.h"
#import "LBYouTubeExtractor.h"

@interface NowPlayingViewController () <UITableViewDataSource, UITableViewDelegate>
- (void)reload:(id)sender;

@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, strong) UITableView *bottomTableView;

@end

@implementation NowPlayingViewController
{
    @private
    NSArray *_arrayOfData;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.player = [[MPMoviePlayerController alloc] init];
    [self.player.view setFrame:CGRectMake(0, 0, view.bounds.size.width, 180.0f)];
        
    self.bottomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.player.view.frame), view.bounds.size.width, view.bounds.size.height - self.player.view.bounds.size.height) style:UITableViewStylePlain];
    self.bottomTableView.delegate = self;
    self.bottomTableView.dataSource = self;
    
    [view addSubview:self.player.view];
    [view addSubview:self.bottomTableView];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieReadyToPlay:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    //set up left nav buttons, right nav buttons, title etc
    
    self.bottomTableView.rowHeight = 88.0f;
    
    [self reload:nil];
}

- (void)reload:(id)sender
{
    [APIQuery justSearchWithString:@"311" completion:^(NSArray* array) {
        _arrayOfData = array;
        [self.bottomTableView reloadData];
        
        //Do something with the video here
    }];
}

- (void)movieReadyToPlay:(NSNotification *)notification
{
    [self.player play];
}

- (void)moviePlaybackFinished:(NSNotification *)notification
{
    int reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (reason == MPMovieFinishReasonPlaybackError)
    {
        NSArray *log = self.player.errorLog.events;
        for(MPMovieErrorLogEvent *event in log)
        {
            NSLog(@"%@", event.date);
            NSLog(@"%@", event.serverAddress);
            NSLog(@"%@", event.playbackSessionID);
            NSLog(@"%d", event.errorStatusCode);
            NSLog(@"%@", event.date);
            NSLog(@"%@", event.errorComment);

        }
        //movie finished playin
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayOfData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    NowPlayingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[NowPlayingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.videoDictionary = [_arrayOfData objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", [(NSDictionary *)[_arrayOfData objectAtIndex:indexPath.row] objectForKey:@"youtube-id"]]];
    LBYouTubeExtractor *extractor = [[LBYouTubeExtractor alloc] initWithURL:url quality:LBYouTubeVideoQualityLarge];
    
    [extractor extractVideoURLWithCompletionBlock:^(NSURL *videoURL, NSError *error) {
        if(!error)
        {
            [self.player setContentURL:videoURL];
            [self.player prepareToPlay];
        } else {
            NSLog(@"Failed extracting video URL using block due to error:%@", error);
        }
    }];
    
//    NSURL *url = [NSURL URLWithString:[(NSDictionary *)[_arrayOfData objectAtIndex:indexPath.row] objectForKey:@"url"]];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //Good way to turn off any highlighting when selected
}

@end

