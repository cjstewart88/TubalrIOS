//
//  APIQuery.h
//  Tubalr
//
//  Created by Chad Zeluff on 1/2/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

@interface APIQuery : NSObject

+ (BOOL)determineSpecialSearchWithString:(NSString *)string completion:(void (^)(NSArray *))completion;
+ (void)justSearchWithString:(NSString *)string completion:(void (^)(NSArray *))completion;
+ (void)similarSearchWithString:(NSString *)string completion:(void (^)(NSArray *))completion;

+ (void)createAccountWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password block:(void (^)(NSError *error))block;
+ (void)validateAccountWithUsername:(NSString *)username password:(NSString *)password block:(void (^)(NSError *error))block;
+ (void)logout;

@end
