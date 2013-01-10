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

+ (void)searchWithArtist:(NSString *)artist songTitle:(NSString *)song completion:(void (^)(NSDictionary *))completion
{
    //Artist - Song
    NSString *artistSong = [NSString stringWithFormat:@"%@ - %@", artist, song];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: kYouTubeQueryUrl, [artistSong stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]]];
    
    [self searchWithUrl:url completion:completion];
}

+ (void)searchWithArtist:(NSString *)artist completion:(void (^)(NSDictionary *))completion
{
    //Arist
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
        
        NSDictionary *entry = [entries objectAtIndex:0];
        
        NSString *theUrl = (NSString *)[(NSDictionary *)[(NSArray *)[[entry objectForKey:@"media$group"] objectForKey:@"media$content"] objectAtIndex:0] objectForKey:@"url"];
        NSString *theTitle = (NSString *)[[(NSString *)[[feed objectForKey:@"title"] objectForKey:@"$t"] componentsSeparatedByString:@": "] lastObject];
        NSString *theYouTubeId = (NSString *)[[(NSString *)[[entry objectForKey:@"id"] objectForKey:@"$t"] componentsSeparatedByString:@":"] lastObject];
        
        results = [NSDictionary dictionaryWithObjectsAndKeys:
                   theUrl, @"url",
                   theTitle, @"title",
                   theYouTubeId, @"youtube-id", nil];
        
        //eventually this needs to loop AND do some checks (isNotBlocked etc)
        
        [self callCompletionOnMainThread:completion result:results];
    });
}

+ (void)callCompletionOnMainThread:(void (^)(id))completion result:(id)result
{
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(result);
    });
}

@end
