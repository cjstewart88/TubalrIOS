
//  NowPlayingViewController.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/7/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "NowPlayingViewController.h"
#import "APIQuery.h"
#import "NowPlayingCell.h"
#import "MovieControlView.h"
#import "LBYouTubeExtractor.h"
#import "Slider.h"

@interface NowPlayingViewController () <UITableViewDataSource, UITableViewDelegate, MovieControlViewDelegate>
- (void)beginSearch:(id)sender;

@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, strong) MovieControlView *movieControlView;
@property (nonatomic, strong) UITableView *bottomTableView;

@property (nonatomic, strong) NSArray *arrayOfData;

@end

@implementation NowPlayingViewController
{
    @private
    NSString *_searchString;
    SearchType _searchType;
    NSInteger _selectedCellIndex;
    NSInteger _nextCellIndex;
    NSTimer *_updateProgressTimer;
}

- (id)initWithSearchString:(NSString *)string searchType:(SearchType)searchType
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    
    _searchString = string;
    _searchType = searchType;
    _selectedCellIndex = -1;
    
    _updateProgressTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_updateProgressTimer forMode:NSRunLoopCommonModes];
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.player = [[MPMoviePlayerController alloc] init];
    [self.player.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180.0f)];
//    [self.player setMovieSourceType:MPMovieSourceTypeFile];
    
    self.movieControlView = [[MovieControlView alloc] initWithPosition:CGPointMake(0, CGRectGetMaxY(self.player.view.frame))];
    self.movieControlView.delegate = self;
    [self.movieControlView.shuffleButton addTarget:self action:@selector(shufflePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.movieControlView.backButton addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.movieControlView.playPauseButton addTarget:self action:@selector(playPausePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.movieControlView.nextButton addTarget:self action:@selector(nextPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.movieControlView.playlistButton addTarget:self action:@selector(playlistPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.movieControlView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.movieControlView.frame) - self.navigationController.navigationBar.bounds.size.height) style:UITableViewStylePlain];
    self.bottomTableView.separatorColor = [UIColor blackColor];
    self.bottomTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-cell"]];
    self.bottomTableView.delegate = self;
    self.bottomTableView.dataSource = self;
    self.bottomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.player.view];
    [self.view addSubview:self.movieControlView];
    [self.view addSubview:self.bottomTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"tubalr";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieReadyToPlay:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(durationAvailable:) name:MPMovieDurationAvailableNotification object:nil];
    
    //set up left nav buttons, right nav buttons, title etc
    [self beginSearch:nil];
}

- (void)dealloc
{
    [_updateProgressTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMovieDurationAvailableNotification object:nil];

}

- (void)beginSearch:(id)sender
{
    if([APIQuery determineSpecialSearchWithString:_searchString completion:^(NSArray* array) {
            [self setArrayOfData:array];      
    }]) return;
    
   else if(_searchType == justSearch)
   {
       [APIQuery justSearchWithString:_searchString completion:^(NSArray* array) {
           [self setArrayOfData:array];
       }];
   }
   else if(_searchType == similarSearch)
   {
       [APIQuery similarSearchWithString:_searchString completion:^(NSArray* array) {
           [self setArrayOfData:array];
       }];
   }
}

- (void)setArrayOfData:(NSArray *)arrayOfData
{
    _arrayOfData = arrayOfData;
    [self.bottomTableView reloadData];
    [self selectMoveAndPlay];
}

- (void)updateProgress:(id)sender
{    
    if(self.player.playbackState == MPMoviePlaybackStatePlaying)
    {
        NSLog(@"%f", self.player.duration);
        self.movieControlView.slider.value = self.player.currentPlaybackTime;
    }
}

- (void)durationAvailable:(NSNotification *)notification
{
    self.movieControlView.slider.maximumValue = self.player.duration;
}

- (void)movieReadyToPlay:(NSNotification *)notification
{
    [self.player play];
}

- (void)moviePlaybackFinished:(NSNotification *)notification
{
    int reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    if(reason == MPMovieFinishReasonPlaybackEnded)
    {
        //The song finished; move onto the next one
        _nextCellIndex = _selectedCellIndex + 1;
        if(_nextCellIndex == [self.arrayOfData count])
            _nextCellIndex = 0;
        
        [self selectMoveAndPlay];
        
    }
    
//    if (reason == MPMovieFinishReasonPlaybackError)
//    {
//        NSArray *log = self.player.errorLog.events;
//        for(MPMovieErrorLogEvent *event in log)
//        {
//            NSLog(@"%@", event.date);
//            NSLog(@"%@", event.serverAddress);
//            NSLog(@"%@", event.playbackSessionID);
//            NSLog(@"%d", event.errorStatusCode);
//            NSLog(@"%@", event.date);
//            NSLog(@"%@", event.errorComment);
//
//        }
//        //movie finished playin
//    }
}

- (void)selectMoveAndPlay
{
    [self.bottomTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_nextCellIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.bottomTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_nextCellIndex inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [self.bottomTableView.delegate tableView:self.bottomTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:_nextCellIndex inSection:0]];
}

- (BOOL)shouldAutorotate //iOS6
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)shufflePressed:(id)sender
{
    
}

- (void)backPressed:(id)sender
{
    
}

- (void)playPausePressed:(id)sender
{
    
}

- (void)nextPressed:(id)sender
{
    
}

- (void)playlistPressed:(id)sender
{
    
}

#pragma mark - MoviePlayViewDelegate

- (void)sliderScrubbedToPosition:(CGFloat)position
{    
    [self.player setCurrentPlaybackTime:position];
}

- (void)sliderFinishedScrubbing
{
    [self.player play];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayOfData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    NowPlayingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[NowPlayingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.videoDictionary = [self.arrayOfData objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_selectedCellIndex == indexPath.row) return;
    _selectedCellIndex = indexPath.row;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", [(NSDictionary *)[self.arrayOfData objectAtIndex:_selectedCellIndex] objectForKey:@"youtube-id"]]];
    LBYouTubeExtractor *extractor = [[LBYouTubeExtractor alloc] initWithURL:url quality:LBYouTubeVideoQualityMedium];
    
    [extractor extractVideoURLWithCompletionBlock:^(NSURL *videoURL, NSError *error) {
        if(!error)
        {
            [self.player setContentURL:videoURL];
            [self.player prepareToPlay];
        } else {
            NSLog(@"Failed extracting video URL using block due to error:%@", error);
        }
    }];
}

@end

