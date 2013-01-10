//
//  EchonestQuery.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/9/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "EchonestQuery.h"

NSString *const kVersionKey         = @"v4";
NSString *const kApiKey             = @"OYJRQNQMCGIOZLFIW";
NSString *const kStart              = @"0";
NSString *const kNumberOfSongs      = @"40";
NSString *const kEchonestQueryURL           = @"http://developer.echonest.com/api/%@/%@/%@?api_key=%@&%@=%@&start=%@&results=%@";

@implementation EchonestQuery

#pragma mark Public

+ (void)artistSearch:(NSString *)string completion:(void (^)(NSArray *))completion
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: kEchonestQueryURL, kVersionKey, @"artist", @"songs", kApiKey, @"name", [string stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding], kStart, kNumberOfSongs]];
    
    [self searchWithUrl:url stringArray:[NSArray arrayWithObjects:@"songs", @"title", nil] completion:completion];
}

+ (void)similarArtistSearch:(NSString *)string completion:(void (^)(NSArray *))completion
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: kEchonestQueryURL, kVersionKey, @"artist", @"similar", kApiKey, @"name", [string stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding], kStart, kNumberOfSongs]];
    
    [self searchWithUrl:url stringArray:[NSArray arrayWithObjects:@"artists", @"name", nil] completion:completion];
}

#pragma mark Private

+ (void)searchWithUrl:(NSURL *)url stringArray:(NSArray *)array completion:(void (^)(NSArray *))completion
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError *error;
        NSArray *results;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSDictionary *response = [json objectForKey:@"response"];
        if(![[[response objectForKey:@"status"] objectForKey:@"message"] isEqualToString:@"Success"]) {
            [self callCompletionOnMainThread:completion result:results];
            return;
        }
        
        NSMutableArray *mutableContainer = [[NSMutableArray alloc] init];
        for(NSDictionary *dictionary in [response objectForKey:[array objectAtIndex:0]])
            [mutableContainer addObject:[dictionary objectForKey:[array objectAtIndex:1]]];
        
        results = [NSArray arrayWithArray:mutableContainer];
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
