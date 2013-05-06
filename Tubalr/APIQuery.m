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
        __block int numberOfNils = 0;
        
        [EchonestQuery genreSearch:string completion:^(NSArray *arrayOfArtistSong) {
            //We have successfully returned Echonest data, now perform YouTube searches for each artist song
            for(int i = 0; i < [arrayOfArtistSong count]; i++)
            {
                [YouTubeQuery searchWithString:[arrayOfArtistSong objectAtIndex:i] completion:^(NSDictionary* videoDictionary) {
                    
                    dispatch_sync([self sharedQueue], ^{
                        if(videoDictionary != nil)
                        {
                            [array addObject:videoDictionary];
                        }
                        else
                        {
                            numberOfNils++;
                        }
                        if([array count] == [arrayOfArtistSong count] - numberOfNils)
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
        [RedditQuery searchWithString:string completion:^(NSArray *arrayOfIDs) {
            if(arrayOfIDs != nil)
                [self callCompletionOnMainThread:completion result:arrayOfIDs];
        }];
        
        return YES;
    }
    
    return NO;
}

+ (void)justSearchWithString:(NSString *)string completion:(void (^)(NSArray *))completion
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    __block int numberOfNils = 0;
    
    [EchonestQuery artistSearch:string completion:^(NSArray *arrayOfSongs) {
        
        //We have successfully returned Echonest data, now perform YouTube searches for artist song
        for(int i = 0; i < [arrayOfSongs count]; i++)
        {
            NSString *artistSongString = [NSString stringWithFormat:@"%@ %@", string, [arrayOfSongs objectAtIndex:i]];
            [YouTubeQuery searchWithString:artistSongString completion:^(NSDictionary* videoDictionary) {
                
                dispatch_sync([self sharedQueue], ^{
                    if(videoDictionary != nil)
                    {
                        [array addObject:videoDictionary];
                    }
                    else
                    {
                        numberOfNils++;
                    }
                    if([array count] == [arrayOfSongs count] - numberOfNils)
                    {
                        [self callCompletionOnMainThread:completion result:[[NSArray arrayWithArray:array] shuffledArray]];
                    }
                });
                
            }];
        }
    }];
}

+ (void)similarSearchWithString:(NSString *)string completion:(void (^)(NSArray *))completion
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    __block int numberOfNils = 0;
    
    [EchonestQuery similarArtistSearch:string completion:^(NSArray *arrayOfArtists) {
        
        //We have successfully returned Echonest data, now perform YouTube searches for each artist
        for(int i = 0; i < [arrayOfArtists count]; i++)
        {
            [YouTubeQuery searchWithString:[arrayOfArtists objectAtIndex:i] completion:^(NSDictionary* videoDictionary) {
                
                dispatch_sync([self sharedQueue], ^{
                    if(videoDictionary != nil)
                    {
                        [array addObject:videoDictionary];
                    }
                    else
                    {
                        numberOfNils++;
                    }
                    if([array count] == [arrayOfArtists count] - numberOfNils)
                    {
                        [self callCompletionOnMainThread:completion result:[[NSArray arrayWithArray:array] shuffledArray]];
                    }
                });
                
            }];
        }
    }];
}

+ (void)createAccountWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password block:(void (^)(NSError *))block
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://www.tubalr.com/"]];
    NSDictionary *test = [NSDictionary dictionaryWithObjectsAndKeys:password, @"password", username, @"username", email, @"email", nil];
    
    [client postPath:@"api/registrations.json" parameters:test success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:0];
        if(block)
        {
            block(nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [APIQuery logout];
        if(block)
        {
            block(error);
        }
    }];
}

+ (void)validateAccountWithUsername:(NSString *)username password:(NSString *)password block:(void (^)(NSError *))block
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://www.tubalr.com/"]];
    NSDictionary *test = [NSDictionary dictionaryWithObjectsAndKeys:password, @"password", username, @"email_or_username", nil];

    [client postPath:@"api/sessions.json" parameters:test success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:0];
        [defaults setObject:[dictionary objectForKey:@"token"] forKey:@"token"];
        [defaults setObject:[dictionary objectForKey:@"id"] forKey:@"id"];
        if([dictionary objectForKey:@"username"] != nil)
            [defaults setObject:[dictionary objectForKey:@"username"] forKey:@"username"];
        else
            [defaults setObject:[dictionary objectForKey:@"email"] forKey:@"username"];
        if(block)
        {
            block(nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [APIQuery logout];
        if(block)
        {
            block(error);
        }
    }];
}

+ (void)logout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:nil forKey:@"token"];
    [defaults setObject:nil forKey:@"id"];
    [defaults setObject:nil forKey:@"username"];
}

+ (void)librarySearchWithBlock:(void (^)(NSError *error))block
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://www.tubalr.com/"]];
    [client getPath:@"api/library.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:0];
        [defaults setObject:[dictionary objectForKey:@"top_genres"] forKey:@"topGenres"];
        [defaults setObject:[dictionary objectForKey:@"genres"] forKey:@"genres"];
        [defaults setObject:[dictionary objectForKey:@"reddit"] forKey:@"subreddits"];
        if(block)
        {
            block(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block)
        {
            block(error);
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
