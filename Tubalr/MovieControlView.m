//
//  MovieControlView.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/12/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "MovieControlView.h"
#include "Slider.h"

@implementation MovieControlView

-(id)initWithPosition:(CGPoint)point;
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, 320, 79)];
    if (!self) {
        return nil;
    }
    
    [self.playPauseButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self.slider addTarget:self action:@selector(sliderBegin:) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(sliderEnd:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addObserver:self forKeyPath:@"value" options:0 context:0];
    [self.slider addObserver:self forKeyPath:@"maximumValue" options:0 context:0];
    
    [self addSubview:self.shuffleButton];
    [self addSubview:self.backButton];
    [self addSubview:self.playPauseButton];
    [self addSubview:self.nextButton];
    [self addSubview:self.playlistButton];
    [self addSubview:self.slider];
    [self addSubview:self.trackTimeLabel];
    [self addSubview:self.trackTotalLabel];
    
    return self;
}

- (void)dealloc
{
    [self.slider removeObserver:self forKeyPath:@"value"];
    [self.slider removeObserver:self forKeyPath:@"maximumValue"];
}

- (void)layoutSubviews
{
    CGRect frame;
    frame.origin = CGPointMake(11.0f, 13.0f);
    frame.size = CGSizeMake(self.shuffleButton.imageView.image.size.width, self.shuffleButton.imageView.image.size.height);
    [self.shuffleButton setFrame:frame];
    
    frame.origin = CGPointMake(83.0f, 13.0f);
    frame.size = CGSizeMake(self.backButton.imageView.image.size.width, self.backButton.imageView.image.size.height);
    [self.backButton setFrame:frame];
    
    frame.origin = CGPointMake(147.0f, 13.0f);
    frame.size = CGSizeMake(self.playPauseButton.imageView.image.size.width, self.playPauseButton.imageView.image.size.height);
    [self.playPauseButton setFrame:frame];
    
    frame.origin = CGPointMake(203.0f, 13.0f);
    frame.size = CGSizeMake(self.nextButton.imageView.image.size.width, self.nextButton.imageView.image.size.height);
    [self.nextButton setFrame:frame];
    
    frame.origin = CGPointMake(281.0f, 13.0f);
    frame.size = CGSizeMake(self.playlistButton.imageView.image.size.width, self.playlistButton.imageView.image.size.height);
    [self.playlistButton setFrame:frame];
    
    frame.origin = CGPointMake(48.0f, 61.0f);
    frame.size = CGSizeMake(223.0f, 6.0f);
    [self.slider setFrame:frame];
    
    frame.origin = CGPointMake(15.0f, 59.0f);
    frame.size = CGSizeMake(25.0f, 9.0f);
    [self.trackTimeLabel setFrame:frame];
    
    frame.origin = CGPointMake(278.0f, 59.0f);
    frame.size = CGSizeMake(25.0f, 9.0f);
    [self.trackTotalLabel setFrame:frame];

}

-(NSString *)prettyPrintTime:(NSTimeInterval)time
{
    int minutes = time / 60;
    time -= minutes * 60;
    int seconds = time;
    
    return [NSString stringWithFormat:@"%i:%.2i", minutes, seconds];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"value"])
    {
        [self.trackTimeLabel setText:[self prettyPrintTime:self.slider.value]];
    }
    
    if([keyPath isEqualToString:@"maximumValue"])
    {
        [self.trackTotalLabel setText:[self prettyPrintTime:self.slider.maximumValue]];
    }
}

- (void)buttonPressed:(id)sender
{
    if(sender == self.playPauseButton)
    {
        NSLog(@"Here");
    }
}

- (void)sliderBegin:(id)sender
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(sliderBeganScrubbing)])
        [self.delegate sliderBeganScrubbing];
}

- (void)sliderAction:(id)sender
{
    [self.trackTimeLabel setText:[self prettyPrintTime:self.slider.value]];

    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(sliderScrubbedToPosition:)])
        [self.delegate sliderScrubbedToPosition:[(UISlider *)sender value]];
}

- (void)sliderEnd:(id)sender
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(sliderFinishedScrubbing)])
        [self.delegate sliderFinishedScrubbing];
}

- (UIButton *)shuffleButton
{
    if(_shuffleButton == nil)
    {
        UIImage *image = [UIImage imageNamed:@"icon-shuffle"];
        _shuffleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shuffleButton setImage:image forState:UIControlStateNormal];
        
    }
    
    return _shuffleButton;
}

- (UIButton *)backButton
{
    if(_backButton == nil)
    {
        UIImage *image = [UIImage imageNamed:@"icon-previous"];
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:image forState:UIControlStateNormal];
    }
    
    return _backButton;
}

- (UIButton *)playlistButton
{
    if(_playlistButton == nil)
    {
        UIImage *image = [UIImage imageNamed:@"icon-plus"];
        _playlistButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playlistButton setImage:image forState:UIControlStateNormal];
    }
    
    return _playlistButton;
}

- (UIButton *)nextButton
{
    if(_nextButton == nil)
    {
        UIImage *image = [UIImage imageNamed:@"icon-next"];
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setImage:image forState:UIControlStateNormal];
    }
    
    return _nextButton;
}

- (UIButton *)playPauseButton
{
    if(_playPauseButton == nil)
    {
        UIImage *image = [UIImage imageNamed:@"icon-play"];
        _playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playPauseButton setImage:image forState:UIControlStateNormal];
    }
    
    return _playPauseButton;
}

- (Slider *)slider
{
    if(_slider == nil)
    {
        _slider = [[Slider alloc] init];
        _slider.backgroundColor = [UIColor clearColor];
        _slider.continuous = YES;
        UIImage *stetchLeftTrack = [[UIImage imageNamed:@"scrubber-active"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        UIImage *stetchRightTrack = [[UIImage imageNamed:@"scrubber"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        [_slider setThumbImage: [UIImage imageNamed:@"knob.png"] forState:UIControlStateNormal];
        [_slider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
        [_slider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    }
    
    return _slider;
}

- (UILabel *)trackTimeLabel
{
    if(_trackTimeLabel == nil)
    {
        _trackTimeLabel = [[UILabel alloc] init];
        _trackTimeLabel.font = [UIFont boldFontOfSize:10.0f];
        _trackTimeLabel.textColor = [UIColor whiteColor];
        _trackTimeLabel.shadowColor = [UIColor blackColor];
        _trackTimeLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _trackTotalLabel.textAlignment = NSTextAlignmentCenter; //iOS6
        [_trackTimeLabel setBackgroundColor:[UIColor clearColor]];
        _trackTimeLabel.text = [self prettyPrintTime:0];
    }
    
    return _trackTimeLabel;
}

- (UILabel *)trackTotalLabel
{
    if(_trackTotalLabel == nil)
    {
        _trackTotalLabel = [[UILabel alloc] init];
        _trackTotalLabel.font = [UIFont boldFontOfSize:10.0f];
        _trackTotalLabel.textColor = [UIColor whiteColor];
        _trackTotalLabel.shadowColor = [UIColor blackColor];
        _trackTotalLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _trackTotalLabel.textAlignment = NSTextAlignmentCenter;
        [_trackTotalLabel setBackgroundColor:[UIColor clearColor]];
        
        _trackTotalLabel.text = [self prettyPrintTime:0];
    }
    
    return _trackTotalLabel;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [[UIColor colorWithRed:0.161 green:0.161 blue:0.161 alpha:1] set];
	UIRectFill(rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    //Gray Vertical Lines
    CGContextSaveGState(context); {
        CGFloat componentsGrayVert[] = {0.247, 0.247, 0.247, 1.0};
        CGColorRef colorGrayVert = CGColorCreate(colorspace, componentsGrayVert);
        CGContextSetStrokeColorWithColor(context, colorGrayVert);
        CGContextMoveToPoint(context, 50, 0);
        CGContextAddLineToPoint(context, 50, 49);
        CGContextMoveToPoint(context, 270.5, 0);
        CGContextAddLineToPoint(context, 270.5, 49);
        CGColorRelease(colorGrayVert);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
//    //Black Vertical Lines
    CGContextSaveGState(context); {
        CGFloat componentsBlackVert[] = {0.0, 0.0, 0.0, 1.0};
        CGColorRef colorBlackVert = CGColorCreate(colorspace, componentsBlackVert);
        CGContextSetStrokeColorWithColor(context, colorBlackVert);
        CGContextMoveToPoint(context, 51.0, 0);
        CGContextAddLineToPoint(context, 51.0, 49);
        CGContextMoveToPoint(context, 269.5, 0);
        CGContextAddLineToPoint(context, 269.5, 49);
        CGColorRelease(colorBlackVert);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);

    //Gray Horizontal Top Line
    CGContextSaveGState(context); {
        CGFloat componentsGrayTop[] = {0.220, 0.220, 0.220, 1.0};
        CGColorRef colorGrayTop = CGColorCreate(colorspace, componentsGrayTop);
        CGContextSetStrokeColorWithColor(context, colorGrayTop);
        CGContextMoveToPoint(context, 0, .5);
        CGContextAddLineToPoint(context, 320, .5);
        CGColorRelease(colorGrayTop);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
    //Black Horizontal Bottom Line
    CGContextSaveGState(context); {
        CGFloat componentsBlackBottom[] = {0.043, 0.043, 0.043, 1.0};
        CGColorRef colorBlackBottom = CGColorCreate(colorspace, componentsBlackBottom);
        CGContextSetStrokeColorWithColor(context, colorBlackBottom);
        CGContextMoveToPoint(context, 0, 49.0);
        CGContextAddLineToPoint(context, 320, 49.0);
        CGColorRelease(colorBlackBottom);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
    //Gray Horizontal Bottom Line
    CGContextSaveGState(context); {
        CGFloat componentsGrayBottom[] = {0.263, 0.263, 0.263, 1.0};
        CGColorRef colorGrayBottom = CGColorCreate(colorspace, componentsGrayBottom);
        CGContextSetStrokeColorWithColor(context, colorGrayBottom);
        CGContextMoveToPoint(context, 0, 50.0);
        CGContextAddLineToPoint(context, 320, 50.0);
        CGColorRelease(colorGrayBottom);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorspace);
}

@end
