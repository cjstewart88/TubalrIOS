//
//  YouTubeQuery.h
//  Tubalr
//

#import <Foundation/Foundation.h>

@interface YouTubeQuery : NSObject

+ (void)searchWithString:(NSString *)artist completion:(void (^)(NSDictionary *))completion;

+ (void)searchWithStringNoRestrictions:(NSString *)artist completion:(void (^)(NSArray *))completion;

@end
