//
//  YouTubeQuery.h
//  Tubalr
//
//  Created by Chad Zeluff on 1/9/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YouTubeQuery : NSObject

+ (void)searchWithArtist:(NSString *)artist songTitle:(NSString *)song completion:(void (^)(NSDictionary *))completion;

@end
