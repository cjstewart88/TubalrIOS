//
//  RedditQuery.h
//  Tubalr
//

#import <Foundation/Foundation.h>

@interface RedditQuery : NSObject

+ (BOOL)checkWithString:(NSString *)string;

+ (void)searchWithString:(NSString *)string completion:(void (^)(NSArray *))completion;

@end
