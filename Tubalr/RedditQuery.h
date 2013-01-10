//
//  RedditQuery.h
//  Tubalr
//
//  Created by Chad Zeluff on 1/9/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedditQuery : NSObject

+ (BOOL)checkWithString:(NSString *)string;

+ (void)searchWithString:(NSString *)string;

@end
