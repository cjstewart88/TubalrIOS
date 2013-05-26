//
//  AppDelegate.m
//  Tubalr
//

#import "AppDelegate.h"
#import "NavigationController.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:@"eab2d4a84191015273c8368e21e964fe_MTcxMjcxMjAxMy0wMS0wMiAyMDo0NTowOS4yNTczMjI"];
    
    [self applyStyleSheet];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    NavigationController *navController = [[NavigationController alloc] initWithRootViewController:mainVC];
    [self.window setRootViewController: navController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applyStyleSheet
{
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    UISearchBar *searchBar = [UISearchBar appearance];
    UITextField *searchBarTextField = [UITextField appearanceWhenContainedIn:[UISearchBar class], nil];
    UIBarButtonItem *searchBarButtonItem = [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil];
    
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-bar"] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTitleVerticalPositionAdjustment:-3.0f forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backImage = [UIImage imageNamed:@"btn-back"];
    UIImage *image = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backImage.size.width, 0, 0)];
    [barButtonItem setBackButtonBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barButtonItem setTitlePositionAdjustment:UIOffsetMake(0.0f, 1.0f) forBarMetrics:UIBarMetricsDefault];
    
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg-search"]];
    [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"bg-search-input"] forState:UIControlStateNormal];
    [searchBar setImage:[UIImage imageNamed:@"icon-search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchBar setImage:[UIImage imageNamed:@"icon-search-x"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [searchBarTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSFontAttributeName : [UIFont regularFontOfSize:15.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}]];
    [searchBarButtonItem setTitle:@"CANCEL"];
    [searchBarButtonItem setBackgroundImage:[UIImage imageNamed:@"btn-cancel"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [searchBarButtonItem setBackgroundImage:[UIImage imageNamed:@"bg-cancel"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [searchBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIFont boldFontOfSize:11.0f], UITextAttributeFont,
                                                 [UIColor blackColor], UITextAttributeTextShadowColor,
                                                 [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)], UITextAttributeTextShadowOffset,
                                                 [UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
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

- (void)showNowPlayingView
{
    
}

@end
