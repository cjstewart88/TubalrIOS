//
//  APIQuery.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/2/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "APIQuery.h"
#import "EchonestQuery.h"
#import "YouTubeQuery.h"
#import "RedditQuery.h"
#import "GenreQuery.h"

#define STAGING

#if defined (DEBUG) && defined (STAGING)
NSString *const kAPIQueryVersionKey			= @"v1";
NSString *const kAPIQueryURL				= @"http://staging.tubalr.com";
NSString *const kAPITrackURL                = @"http://staging.tubalr.com";
#else
NSString *const kAPIQueryVersionKey			= @"v1";
NSString *const kAPIQueryURL				= @"http://www.tubalr.com";
NSString *const kAPITrackURL                = @"http://www.tubalr.com";
#endif

@implementation APIQuery

#pragma mark Public

+ (BOOL)determineSpecialSearchWithString:(NSString *)string completion:(void (^)(NSArray *))completion
{
    if([GenreQuery checkWithString:&string])
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        [EchonestQuery genreSearch:string completion:^(NSArray *arrayOfArtistSong) {
            //We have successfully returned Echonest data, now perform YouTube searches for each artist song
            for(int i = 0; i < [arrayOfArtistSong count]; i++)
            {
                [YouTubeQuery searchWithString:[arrayOfArtistSong objectAtIndex:i] completion:^(NSDictionary* videoDictionary) {
                    
                    dispatch_sync([self sharedQueue], ^{
                        [array addObject:videoDictionary];
                        if([array count] == [arrayOfArtistSong count])//if([array count] % 10 == 0)
                        {
                            [self callCompletionOnMainThread:completion result:[[NSArray arrayWithArray:array] shuffledArray]];
                        }
                    });
                }];
            }
        }];
        
        return YES;
    }
    
    else if([RedditQuery checkWithString:string])
    {
        [RedditQuery searchWithString:string completion:^(NSArray *arrayOfSomething) {
            
        }];
        
        return YES;
    }
    
    return NO;
}

+ (void)justSearchWithString:(NSString *)string completion:(void (^)(NSArray *))completion
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [EchonestQuery artistSearch:string completion:^(NSArray *arrayOfSongs) {
        
        //We have successfully returned Echonest data, now perform YouTube searches for artist song
        for(int i = 0; i < [arrayOfSongs count]; i++)
        {
            NSString *artistSongString = [NSString stringWithFormat:@"%@ %@", string, [arrayOfSongs objectAtIndex:i]];
            [YouTubeQuery searchWithString:artistSongString completion:^(NSDictionary* videoDictionary) {
                
                dispatch_sync([self sharedQueue], ^{
                    if(videoDictionary != nil)
                        [array addObject:videoDictionary];
                    if(i == [arrayOfSongs count] - 1)
                        [self callCompletionOnMainThread:completion result:[[NSArray arrayWithArray:array] shuffledArray]];
                });
                
            }];
        }
    }];
}

+ (void)similarSearchWithString:(NSString *)string completion:(void (^)(NSArray *))completion
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [EchonestQuery similarArtistSearch:string completion:^(NSArray *arrayOfArtists) {
        
        //We have successfully returned Echonest data, now perform YouTube searches for each artist
        for(int i = 0; i < [arrayOfArtists count]; i++)
        {
            [YouTubeQuery searchWithString:[arrayOfArtists objectAtIndex:i] completion:^(NSDictionary* videoDictionary) {
                
                dispatch_sync([self sharedQueue], ^{
                    if(videoDictionary != nil)
                        [array addObject:videoDictionary];
                    if(i == [arrayOfArtists count] - 1)
                        [self callCompletionOnMainThread:completion result:[[NSArray arrayWithArray:array] shuffledArray]];
                });
                
            }];
        }
    }];
}

#pragma mark Private

+(dispatch_queue_t)sharedQueue
{
    static dispatch_queue_t _sharedQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedQueue = dispatch_queue_create("com.Tubalr.YouTubeQueue", NULL);
    });
    
    return _sharedQueue;
}

+(void)callCompletionOnMainThread:(void (^)(id))completion result:(id)result
{
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(result);
    });
}

@end
