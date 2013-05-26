//
//  UIViewController+NowPlayingButton.m
//  Tubalr
//

#import "UIViewController+NowPlayingButton.h"
#import "AppDelegate.h"
#import "GenresViewController.h"

@implementation UIViewController (NowPlayingButton)
-(void)showNowPlayingButton:(BOOL)show {
    if ([GenresViewController nowPlayingVC] != nil) {
        UIImage *nowPlayingImage = [UIImage imageNamed:@"btn-now-playing"];
        UIImage *npImage = [nowPlayingImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, nowPlayingImage.size.width, 0, 0)];
        
        UIButton *npButton = [UIButton buttonWithType:UIButtonTypeCustom];
        npButton.frame = CGRectMake(0, 0, npImage.size.width, npImage.size.height);
        [npButton addSubview:[[UIImageView alloc] initWithImage:npImage]];
        [npButton addTarget:self action:@selector(nowPlayingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *npItem = [[UIBarButtonItem alloc] initWithCustomView:npButton];
        [self.navigationItem setRightBarButtonItem:npItem];
    }
}

-(void)nowPlayingButtonPressed:(id)sender
{
    [self.navigationController pushViewController:(UIViewController*)[GenresViewController nowPlayingVC] animated:YES];
}
@end
