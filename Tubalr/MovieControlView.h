//
//  MovieControlView.h
//  Tubalr
//
//  Created by Chad Zeluff on 1/12/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieControlView : UIView

-(id)initWithPosition:(CGPoint)point;

@property (nonatomic, strong) UIButton *shuffleButton;
@property (nonatomic, strong) UIButton *backBuuton;
@property (nonatomic, strong) UIButton *playPauseButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *playlistButton;

@end
