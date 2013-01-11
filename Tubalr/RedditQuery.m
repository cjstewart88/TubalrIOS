//
//  RedditQuery.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/9/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "RedditQuery.h"

NSString *const kRedditQueryUrl             = @"http://www.reddit.com/r/%@/hot.json?jsonp=?&limit=100";

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
}

@end
