//
//  EchonestQuery.h
//  Tubalr
//

#import <Foundation/Foundation.h>

@interface EchonestQuery : NSObject

+ (void)artistSearch:(NSString *)string completion:(void (^)(NSArray *))completion;
+ (void)similarArtistSearch:(NSString *)string completion:(void (^)(NSArray *))completion;
+ (void)genreSearch:(NSString *)string completion:(void (^)(NSArray *))completion;

@end
