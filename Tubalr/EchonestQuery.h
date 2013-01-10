//
//  EchonestQuery.h
//  Tubalr
//
//  Created by Chad Zeluff on 1/9/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EchonestQuery : NSObject

+ (void)artistSearch:(NSString *)string completion:(void (^)(NSArray *))completion;

@end
