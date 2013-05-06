//
//  UIViewController+NowPlayingButton.h
//  Tubalr
//
//  Created by Kyle Bock on 4/17/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import <UIKit/UIViewController.h>

@interface UIViewController (NowPlayingButton)
-(void)showNowPlayingButton:(BOOL)show;
-(void)nowPlayingButtonPressed:(id)sender;
@end
