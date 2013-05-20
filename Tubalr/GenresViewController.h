//
//  GenresViewController.h
//  Tubalr
//
#import <UIKit/UIKit.h>

@class NowPlayingViewController;

@interface GenresViewController : UIViewController
{
    NSString *_keyPath;}

@property(nonatomic, copy) NSString* keyPath;

-(id)initWithKeyPath:(NSString*)keyPath andTitle:(NSString*)title;
+(NowPlayingViewController*)nowPlayingVC;
+(void)setNowPlayingVC:(NowPlayingViewController*)viewController;

@end
