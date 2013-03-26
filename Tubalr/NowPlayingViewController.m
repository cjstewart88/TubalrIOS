
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
#import "AVView.h"

/* Asset keys */
NSString * const kTracksKey         = @"tracks";
NSString * const kPlayableKey		= @"playable";

/* PlayerItem keys */
NSString * const kStatusKey         = @"status";

/* AVPlayer keys */
NSString * const kRateKey			= @"rate";
NSString * const kCurrentItemKey	= @"currentItem";

static void *AVPlayerDemoPlaybackViewControllerRateObservationContext = &AVPlayerDemoPlaybackViewControllerRateObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;

@interface NowPlayingViewController () <UITableViewDataSource, UITableViewDelegate, MovieControlViewDelegate>
- (void)beginSearch:(id)sender;

@property (nonatomic, strong) AVView *playerView;
@property (nonatomic, strong) AVPlayerItem *playerItem;
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
    float mRestoreAfterScrubbingRate;
    id _timeObserver;
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
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.movieControlView = [[MovieControlView alloc] initWithPosition:CGPointMake(0, CGRectGetMaxY(self.playerView.frame))];
    self.movieControlView.delegate = self;
    [self.movieControlView.shuffleButton addTarget:self action:@selector(shufflePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.movieControlView.backButton addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.movieControlView.playPauseButton addTarget:self action:@selector(playPausePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.movieControlView.nextButton addTarget:self action:@selector(nextPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.movieControlView.playlistButton addTarget:self action:@selector(playlistPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.movieControlView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.movieControlView.frame) - self.navigationController.navigationBar.bounds.size.height) style:UITableViewStylePlain];
    self.bottomTableView.backgroundColor = [UIColor cellColor];
    self.bottomTableView.delegate = self;
    self.bottomTableView.dataSource = self;
    self.bottomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.movieControlView];
    [self.view addSubview:self.bottomTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"tubalr";
    
    [self addPlayerTimeObserver];
    [self.playerView.player addObserver:self
                             forKeyPath:kRateKey
                                options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                context:nil];
    
    [self.playerView.player addObserver:self
                  forKeyPath:kCurrentItemKey
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:nil];
	
	[self syncPlayPauseButtons];
    
    [self beginSearch:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.playerView.player removeObserver:self forKeyPath:kRateKey];
    [self.playerView.player removeObserver:self forKeyPath:kCurrentItemKey];
    [self.playerItem removeObserver:self forKeyPath:kStatusKey];
}

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    if([path isEqualToString:kStatusKey])
    {
        [self syncPlayPauseButtons];
        self.movieControlView.slider.maximumValue = CMTimeGetSeconds([self playerItemDuration]);
    }
    else if ([path isEqualToString:kRateKey])
    {
        [self syncPlayPauseButtons];
    }
    else if([path isEqualToString:kCurrentItemKey])
    {
        [self syncPlayPauseButtons];
    }
}

/* If the media is playing, show the stop button; otherwise, show the play button. */
- (void)syncPlayPauseButtons
{
	if ([self isPlaying])
	{
        [self.movieControlView showPauseButton];
	}
	else
	{
        [self.movieControlView showPlayButton];
	}
}

- (BOOL)isPlaying
{
    return self.playerView.player.rate != 0.0f;
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

- (void)syncScrubber
{
    if(self.playerView.player.rate != 0.0f) //normal updates while playing
    {
        self.movieControlView.slider.value = CMTimeGetSeconds(self.playerView.player.currentTime);
    }
}

- (CMTime)playerItemDuration
{
	AVPlayerItem *playerItem = self.playerView.player.currentItem;
	if (playerItem.status == AVPlayerItemStatusReadyToPlay)
	{        
		return([playerItem duration]);
	}
	
	return(kCMTimeInvalid);
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [self nextItem];
}

- (void)nextItem
{
    [self syncPlayPauseButtons];
    
    _nextCellIndex = _selectedCellIndex + 1;
    if(_nextCellIndex == [self.arrayOfData count])
        _nextCellIndex = 0;
    
    [self selectMoveAndPlay];
}

- (void)previousItem
{
    [self syncPlayPauseButtons];
    
    _nextCellIndex = _selectedCellIndex - 1;
    if(_nextCellIndex < 0)
        _nextCellIndex = [self.arrayOfData count] - 1;
    
    [self selectMoveAndPlay];
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
    if(CMTimeGetSeconds(self.playerView.player.currentTime) < 5)
    {
        [self previousItem];
    }
    else
    {
        [self.playerView.player seekToTime:CMTimeMakeWithSeconds(0.0f, NSEC_PER_SEC)];
        self.movieControlView.slider.value = 0;
    }
}

- (void)playPausePressed:(id)sender
{
    if ([self isPlaying])
	{
        [self.playerView.player pause];
	}
	else
	{
        [self.playerView.player play];
	}
}

- (void)nextPressed:(id)sender
{
    [self nextItem];
}

- (void)playlistPressed:(id)sender
{
    
}

- (void)addPlayerTimeObserver
{
    __weak NowPlayingViewController *vc = self;
    _timeObserver = [self.playerView.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.2f, NSEC_PER_SEC)
                                                                         queue:NULL /* If you pass NULL, the main queue is used. */
                                                                    usingBlock:^(CMTime time)
                     {
                         [vc syncScrubber];
                     }];
}

- (void)removePlayerTimeObserver
{
	if (_timeObserver)
	{
		[self.playerView.player removeTimeObserver:_timeObserver];
		_timeObserver = nil;
	}
}

#pragma mark - MoviePlayViewDelegate

- (void)sliderBeganScrubbing
{
    [self removePlayerTimeObserver];
}

- (void)sliderScrubbedToPosition:(CGFloat)position
{
}

- (void)sliderFinishedScrubbing
{
    [self.playerView.player seekToTime:CMTimeMakeWithSeconds(self.movieControlView.slider.value, NSEC_PER_SEC)];
    [self addPlayerTimeObserver];
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
    static NSString *NowPlayingCellIdentifier = @"NowPlayingCellIdentifier";
    
    NowPlayingCell *cell = [tableView dequeueReusableCellWithIdentifier:NowPlayingCellIdentifier];
    if (!cell) {
        cell = [[NowPlayingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NowPlayingCellIdentifier];
    }
    
    cell.videoDictionary = [self.arrayOfData objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_selectedCellIndex == indexPath.row) return;
    _selectedCellIndex = indexPath.row;
    
    [self.playerView.player pause];
    [self.playerView.player replaceCurrentItemWithPlayerItem:nil];
    [self removePlayerItemObservations];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", [(NSDictionary *)[self.arrayOfData objectAtIndex:_selectedCellIndex] objectForKey:@"youtube-id"]]];
    LBYouTubeExtractor *extractor = [[LBYouTubeExtractor alloc] initWithURL:url quality:LBYouTubeVideoQualityMedium];
    
    [extractor extractVideoURLWithCompletionBlock:^(NSURL *videoURL, NSError *error) {
        if(!error)
        {
            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
            
            NSArray *requestedKeys = [NSArray arrayWithObjects:kTracksKey, kPlayableKey, nil];
            
            /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
            [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
             ^{
                 dispatch_async( dispatch_get_main_queue(),
                                ^{
                                    /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                                    [self prepareToPlayAsset:asset withKeys:requestedKeys];
                                });
             }];
        } else {
            NSLog(@"Failed extracting video URL using block due to error:%@", error);
        }
    }];
}

- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    /* Make sure that the value of each key has loaded successfully. */
	for (NSString *thisKey in requestedKeys)
	{
		NSError *error = nil;
		AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
		if (keyStatus == AVKeyValueStatusFailed)
		{
			[self showAlertWithError:error];
			return;
		}
	}
    
    if (!asset.playable)
    {
        /* Generate an error describing the failure. */
		NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
		NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
		NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
								   localizedDescription, NSLocalizedDescriptionKey,
								   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
								   nil];
		NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        [self showAlertWithError:assetCannotBePlayedError];  
        return;
    }
    
    /* At this point we're ready to set up for playback of the asset. */
    
    /* Stop observing our prior AVPlayerItem, if we have one. */
    [self removePlayerItemObservations];
	
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    /* Observe the player item "status" key to determine when it is ready to play. */
    [self.playerItem addObserver:self
                       forKeyPath:kStatusKey
                          options:0
                          context:0];
	
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    if (self.playerView.player.currentItem != self.playerItem)
    {
        /* Replace the player item with a new player item. The item replacement occurs
         asynchronously; observe the currentItem property to find out when the
         replacement will/did occur*/
        [self.playerView.player replaceCurrentItemWithPlayerItem:self.playerItem];
    }
    
//    [self.playerView.player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
    [self.playerView.player play];
}
     
- (void)removePlayerItemObservations
 {
     if (self.playerItem && self.playerView.player.currentItem == self.playerItem)
     {
         /* Remove existing player item key value observers and notifications. */
         
         [self.playerItem removeObserver:self forKeyPath:kStatusKey];
         
         [[NSNotificationCenter defaultCenter] removeObserver:self
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:nil];
     }
 }

-(void)showAlertWithError:(NSError *)error
{    
    /* Display the error. */
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
														message:[error localizedFailureReason]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
}


#pragma mark - Getters

- (AVView *)playerView
{
    if(_playerView == nil)
    {
        _playerView = [[AVView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180.0f)];
        _playerView.player = [[AVPlayer alloc] init];
    }
    
    return _playerView;
}

@end

