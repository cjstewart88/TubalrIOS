//
//  RedditQuery.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/9/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "RedditQuery.h"

NSString *const kRedditQueryUrl             = @"http://www.reddit.com/r/%@/hot.json?limit=100";

@implementation RedditQuery

#pragma mark Public

+ (BOOL)checkWithString:(NSString *)string
{
    NSRange redditSchemeRange = [string rangeOfString:@"/r/"];
    if(redditSchemeRange.location == NSNotFound)
        return NO;
    
    return YES;
}

+ (void)searchWithString:(NSString *)string completion:(void (^)(NSArray *))completion
{
    NSString *redditString = [string stringByReplacingOccurrencesOfString:@"/r/"
                                                               withString:@""];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: kRedditQueryUrl, redditString]];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError *error;
        NSArray *results;
        
        NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        for(NSDictionary *dataDictionary in [[json objectForKey:@"data"] objectForKey:@"children"])
        {
            NSDictionary *data = [dataDictionary objectForKey:@"data"];

            if([[data objectForKey:@"domain"] isEqualToString:@"youtube.com"] && [[data objectForKey:@"media"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *media = [data objectForKey:@"media"];
                NSString *theYouTubeId = [[[[media objectForKey:@"oembed"] objectForKey:@"url"] componentsSeparatedByString:@"?v="] lastObject];
                NSString *theTitle = [[media objectForKey:@"oembed"] objectForKey:@"title"];
                
                NSDictionary *redditDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                           theTitle, @"title",
                           theYouTubeId, @"youtube-id", nil];
                
                [resultsArray addObject:redditDictionary];
            }
        }
        results = [NSArray arrayWithArray:resultsArray];
        [self callCompletionOnMainThread:completion result:results];
    });
}

+(void)callCompletionOnMainThread:(void (^)(id))completion result:(id)result
{
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(result);
    });
}

@end
