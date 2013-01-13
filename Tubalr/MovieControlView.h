//
//  MovieControlView.h
//  Tubalr
//
//  Created by Chad Zeluff on 1/12/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Slider;

@interface MovieControlView : UIView

-(id)initWithPosition:(CGPoint)point;

@property (nonatomic, strong) UIButton *shuffleButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *playPauseButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *playlistButton;
@property (nonatomic, strong) Slider *slider;
@property (nonatomic, strong) UILabel *trackTimeLabel;
@property (nonatomic, strong) UILabel *trackTotalLabel;

@property (nonatomic, weak) id delegate;

@end

@protocol MovieControlViewDelegate <NSObject>

- (void)sliderScrubbedToPosition:(CGFloat)position;
- (void)sliderFinishedScrubbing;

@end