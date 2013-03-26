//
//  GenresViewController.h
//  Tubalr
//
//  Created by Kyle Bock on 3/26/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
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
