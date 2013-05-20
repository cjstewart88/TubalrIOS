//
//  PlaylistManager.m
//  Tubalr
//

#import "PlaylistManager.h"

@interface PlaylistManager ()

@property (nonatomic, strong) NSMutableArray *playlistArray;

@end

@implementation PlaylistManager

- (void)addObject:(id)object
{
    [self.playlistArray addObject:object];
}

- (void)clearPlaylist
{
    self.playlistArray = nil;
}

- (NSInteger)playlistCount
{
    return [self.playlistArray count];
}

- (NSArray *)currentPlaylist
{
    return [NSArray arrayWithArray:self.playlistArray];
}

- (NSMutableArray *)playlistArray
{
    if(_playlistArray == nil)
    {
        _playlistArray = [[NSMutableArray alloc] init];
    }
    
    return _playlistArray;
}

@end
