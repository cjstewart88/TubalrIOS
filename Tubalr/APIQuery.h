//
//  APIQuery.h
//  Tubalr
//

@interface APIQuery : NSObject

+ (BOOL)determineSpecialSearchWithString:(NSString *)string completion:(void (^)(NSArray *))completion;
+ (void)justSearchWithString:(NSString *)string completion:(void (^)(NSArray *))completion;
+ (void)similarSearchWithString:(NSString *)string completion:(void (^)(NSArray *))completion;

+ (void)createAccountWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password block:(void (^)(NSError *error))block;
+ (void)validateAccountWithUsername:(NSString *)username password:(NSString *)password block:(void (^)(NSError *error))block;
+ (void)logout;


+ (void)reportVideoWatchedWithVideoID:(NSString *)videoid videotitle:(NSString *)videotitle;

+ (void)librarySearchWithBlock:(void (^)(NSError *error))block;

@end
