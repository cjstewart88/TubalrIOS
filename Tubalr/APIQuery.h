//
//  APIQuery.h
//  Tubalr
//
//  Created by Chad Zeluff on 1/2/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

@protocol APIQueryDelegate <NSObject>

- (void)didFailWithError:(NSError *)error;

- (void)didReceiveDataDictionary:(NSDictionary *)dictionary;

@end

@interface APIQuery : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <APIQueryDelegate> delegate;

- (void)justSearchWithString:(NSString *)string;
- (void)similarSearchWithString:(NSString *)string;

+ (NSArray *)genres;

@end
