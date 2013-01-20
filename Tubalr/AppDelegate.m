//
//  AppDelegate.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/2/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "AppDelegate.h"
#import "NavigationController.h"
#import "MainViewController.h"
#import "NowPlayingViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:@"eab2d4a84191015273c8368e21e964fe_MTcxMjcxMjAxMy0wMS0wMiAyMDo0NTowOS4yNTczMjI"];
    [Crashlytics startWithAPIKey:@"e3e642bcbe351153ef65205ec65c9f9cc69d86f2"];
    
    [self applyStyleSheet];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    UInt32 doSetProperty = 0;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NavigationController *navController = [[NavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    
    [self.window setRootViewController: navController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applyStyleSheet
{
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    UISearchBar *searchBar = [UISearchBar appearance];
    
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-bar"] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTitleVerticalPositionAdjustment:-5.0f forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
                                           [UIFont boldFontOfSize:24.0f], UITextAttributeFont,
                                           [UIColor blackColor], UITextAttributeTextShadowColor,
                                           [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)], UITextAttributeTextShadowOffset,
                                           [UIColor whiteColor], UITextAttributeTextColor, nil]];
    [navigationBar setShadowImage:[UIImage imageNamed:@"nav-bar-shadow"]]; //iOS6
    
    UIImage *backImage = [UIImage imageNamed:@"btn-back"];
    UIImage *image = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backImage.size.width, 0, 0)];
    [barButtonItem setBackButtonBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg-search"]];
    [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"bg-search-input"] forState:UIControlStateNormal];
    [searchBar setImage:[UIImage imageNamed:@"icon-search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchBar setImage:[UIImage imageNamed:@"icon-search-x"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [searchBar setScopeBarButtonTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                     [UIFont regularFontOfSize:15.0f], UITextAttributeFont,
                                                     [UIColor blackColor], UITextAttributeTextShadowColor,
                                                     [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)], UITextAttributeTextShadowOffset,
                                                     [UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSFontAttributeName : [UIFont regularFontOfSize:15.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}]];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
