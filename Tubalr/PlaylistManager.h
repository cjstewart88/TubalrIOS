//
//  PlaylistManager.h
//  Tubalr
//

#import <Foundation/Foundation.h>

@interface PlaylistManager : NSObject

- (void)addObject:(id)object;
- (void)clearPlaylist;
- (NSInteger)playlistCount;
- (NSArray *)currentPlaylist;

@end
