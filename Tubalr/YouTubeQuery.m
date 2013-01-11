//
//  YouTubeQuery.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/9/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "YouTubeQuery.h"

NSString *const kYouTubeQueryUrl            = @"http://gdata.youtube.com/feeds/mobile/videos?q=%@&orderby=relevance&start-index=1&max-results=10&v=2&alt=json&format=1";

@implementation YouTubeQuery

#pragma mark Public

+ (void)searchWithString:(NSString *)artist completion:(void (^)(NSDictionary *))completion
{
    //Arist or Artist Song
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: kYouTubeQueryUrl, [artist stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]]];
    
    [self searchWithUrl:url completion:completion];
}

#pragma mark Private

+ (void)searchWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError *error;
        NSDictionary *results;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSDictionary *feed = [json objectForKey:@"feed"];
        NSArray *entries = [feed objectForKey:@"entry"];
        
        for(NSDictionary *entry in entries)
        {
            if([self isUnique:entry] && [self isNotBlocked:entry] && [self isMusic:entry] && [self isNotCoverOrRemix:entry] && [self isNotUserBanned:entry] && [self isNotLive:entry])
            {
                //NSString *theUrl = (NSString *)[(NSDictionary *)[(NSArray *)[[entry objectForKey:@"media$group"] objectForKey:@"media$content"] objectAtIndex:0] objectForKey:@"url"];
                NSString *theTitle = [[entry objectForKey:@"title"] objectForKey:@"$t"];
                NSString *theYouTubeId = (NSString *)[[(NSString *)[[entry objectForKey:@"id"] objectForKey:@"$t"] componentsSeparatedByString:@":"] lastObject];
                
                results = [NSDictionary dictionaryWithObjectsAndKeys:
                           //theUrl, @"url",
                           theTitle, @"title",
                           theYouTubeId, @"youtube-id", nil];
                break;
            }
        }
        
        [self callCompletionOnMainThread:completion result:results];
    });
}

+ (void)callCompletionOnMainThread:(void (^)(id))completion result:(id)result
{
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(result);
    });
}

+ (BOOL)isNotBlocked:(NSDictionary *)dictionary
{
    return ([dictionary objectForKey:@"app$control"] == nil);
}

+ (BOOL)isMusic:(NSDictionary *)dictionary
{
    return ([[[[[dictionary objectForKey:@"media$group"] objectForKey:@"media$category"] objectAtIndex:0] objectForKey:@"$t"] isEqualToString:@"Music"]);
}

+ (BOOL)isUnique:(NSDictionary *)dictionary
{
    BOOL unique = YES;
    
    //todo. You're supposed to compare the current title to ones that have already been added to your playlist, and right now that's not doable.
    
    return unique;
}

+ (BOOL)isNotCoverOrRemix:(NSDictionary *)dictionary
{
    NSString *title = [[[dictionary objectForKey:@"title"] objectForKey:@"$t"] lowercaseString];
    if([title rangeOfString:@"cover"].location == NSNotFound && [title rangeOfString:@"remix"].location == NSNotFound && [title rangeOfString:@"remix"].location == NSNotFound)
        return YES;
    
    return NO;
}

+ (BOOL)isNotUserBanned:(NSDictionary *)dictionary
{
    //todo need to work in user accounts first
    
    return YES;
}

+ (BOOL)isNotLive:(NSDictionary *)dictionary
{
    NSString *title = [[[dictionary objectForKey:@"title"] objectForKey:@"$t"] lowercaseString];
    NSString *description = [[[[dictionary objectForKey:@"media$group"] objectForKey:@"media$description"] objectForKey:@"$t"] lowercaseString];
    
    if([description rangeOfString:@"live"].location == NSNotFound && [description rangeOfString:@"concert"].location == NSNotFound && [title rangeOfString:@"live"].location == NSNotFound)
        return YES;
    
    return NO;
    return  YES;
}

@end
