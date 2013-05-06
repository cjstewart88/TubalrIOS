//
//  PlaylistManager.h
//  Tubalr
//
//  Created by Chad Zeluff on 1/11/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaylistManager : NSObject

- (void)addObject:(id)object;
- (void)clearPlaylist;
- (NSInteger)playlistCount;
- (NSArray *)currentPlaylist;

@end
