//
//  AppDelegate.h
//  Tubalr
//

#import <UIKit/UIKit.h>

@class NowPlayingViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NowPlayingViewController *viewController;

-(void)showNowPlayingView;

@end
