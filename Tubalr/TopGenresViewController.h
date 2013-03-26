//
//  TopGenresViewController.h
//  Tubalr
//
//  Created by Chad Zeluff on 2/10/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NowPlayingViewController;

@interface TopGenresViewController : UIViewController {
    NowPlayingViewController *_nowPlayingViewController;
}

@property (nonatomic, strong) NowPlayingViewController *nowPlayingViewController;

@end
