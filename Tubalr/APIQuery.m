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
NSString *const kAPIQueryURL				= @"http://www.tubalr.com";
NSString *const kAPITrackURL                = @"http://www.tubalr.com";
#else
NSString *const kAPIQueryVersionKey			= @"v1";
NSString *const kAPIQueryURL				= @"http://www.tubalr.com";
NSString *const kAPITrackURL                = @"http://www.tubalr.com";
#endif

@implementation APIQuery

#pragma mark Public

+ (void)justSearchWithString:(NSString *)string completion:(void (^)(NSArray *))completion
{
    if([GenreQuery checkWithString:&string])
    {
        [GenreQuery searchWithString:string];
    }
    
    else if([RedditQuery checkWithString:string])
    {
        [RedditQuery searchWithString:string];
    }
    
    else
    {
        dispatch_queue_t queue = dispatch_queue_create("com.Tubalr.YouTubeQueue", NULL);
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        [EchonestQuery artistSearch:string completion:^(NSArray *arrayOfSongs) {
            
            //We have successfully returned Echonest data, now perform YouTube searches for artist - song
            for(NSDictionary *song in arrayOfSongs)
            {
                [YouTubeQuery searchWithArtist:string songTitle:[song objectForKey:@"title"] completion:^(NSDictionary* videoDictionary) {
                    
                    dispatch_sync(queue, ^{
                        [array addObject:videoDictionary];
                        if([array count] == 40)
                        {
                             [self callCompletionOnMainThread:completion result:[NSArray arrayWithArray:array]];
                        }
                    });
                }];
            }
        }];
    }
}

+ (void)similarSearchWithString:(NSString *)string completion:(void (^)(NSArray *))completion
{
    if([GenreQuery checkWithString:&string])
    {
        [GenreQuery searchWithString:string];
    }
    
    else if([RedditQuery checkWithString:string])
    {
        [RedditQuery searchWithString:string];
    }
    
    else
    {
//        NSString *afterCallback = [NSString stringWithFormat:@"&start=%@&results=%@", kEchonestStart, kEchonestNumberOfSongs];
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: kEchonestQueryURL, kEchonestVersionKey, @"artist", @"similar", kEchonestApiKey, @"name", [string stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding], afterCallback]];
//        
//        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            NSError *error;
//            NSArray *results;
//            
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//            NSDictionary *response = [json objectForKey:@"response"];
//            if(![[[response objectForKey:@"status"] objectForKey:@"message"] isEqualToString:@"Success"]) {
//                [self callCompletionOnMainThread:completion result:results];
//                return;
//            }
//            
//            NSDictionary *song = [[response objectForKey:@"songs"] objectAtIndex:0];
//            if(song == nil) {
//                [self callCompletionOnMainThread:completion result:results];
//            }
//            
//            NSDictionary *audioSummary = [song objectForKey:@"audio_summary"];
//            if(audioSummary == nil) {
//                [self callCompletionOnMainThread:completion result:results];
//                return;
//            }
//            
//            // finally get the audio summary data
//            NSData *audioSummaryData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[audioSummary objectForKey:@"analysis_url"]]];
//            // extract the results array
//            json = [NSJSONSerialization JSONObjectWithData:audioSummaryData options:0 error:&error];
//            if(error != nil) {
//                [self callCompletionOnMainThread:completion result:results];
//                return;
//            }
//            
//            results = [json objectForKey:@"segments"];
//            [self callCompletionOnMainThread:completion result:results];
//        });
    }
}

#pragma mark Private

+(void)callCompletionOnMainThread:(void (^)(id))completion result:(id)result
{
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(result);
    });
}

@end
