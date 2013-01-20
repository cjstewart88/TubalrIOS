//
//  JustSimilarView.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/19/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "JustSimilarView.h"

@interface JustSimilarView()

@property (nonatomic, strong) UIButton *justButton;
@property (nonatomic, strong) UIButton *similarButton;

@end

@implementation JustSimilarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    self.backgroundColor = [UIColor cellColor];
    [self addSubview:self.justButton];
    [self addSubview:self.similarButton];
    [self setJustSelected:YES];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.justButton setFrame:CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height)];
    [self.similarButton setFrame:CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height)];
}

- (void)setJustSelected:(BOOL)selected
{
    [self.justButton setSelected:selected];
    [self.similarButton setSelected:!selected];
}

- (UIButton *)justButton
{
    if(_justButton == nil)
    {
        _justButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_justButton setTitle:@"ONLY" forState:UIControlStateNormal];
        _justButton.titleLabel.font = [UIFont boldFontOfSize:15.0f];
        _justButton.titleLabel.textColor = [UIColor whiteColor];
        _justButton.titleLabel.shadowColor = [UIColor blackColor];
        _justButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _justButton.adjustsImageWhenHighlighted = NO;
        [_justButton setBackgroundImage:[[UIImage imageNamed:@"btn-search"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forState:UIControlStateNormal];
        [_justButton setBackgroundImage:[[UIImage imageNamed:@"btn-search-active"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forState:UIControlStateSelected];
        [_justButton setBackgroundImage:[[UIImage imageNamed:@"btn-search-active"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forState:UIControlStateSelected | UIControlStateHighlighted];
        [_justButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _justButton;
}

- (UIButton *)similarButton
{
    if(_similarButton == nil)
    {
        _similarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_similarButton setTitle:@"SIMILAR" forState:UIControlStateNormal];
        _similarButton.titleLabel.font = [UIFont boldFontOfSize:15.0f];
        _similarButton.titleLabel.textColor = [UIColor whiteColor];
        _similarButton.titleLabel.shadowColor = [UIColor blackColor];
        _similarButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _similarButton.adjustsImageWhenHighlighted = NO;
        [_similarButton setBackgroundImage:[[UIImage imageNamed:@"btn-search"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forState:UIControlStateNormal];
        [_similarButton setBackgroundImage:[[UIImage imageNamed:@"btn-search-active"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forState:UIControlStateSelected];
        [_similarButton setBackgroundImage:[[UIImage imageNamed:@"btn-search-active"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forState:UIControlStateSelected | UIControlStateHighlighted];
        [_similarButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _similarButton;
}

- (void)buttonPressed:(id)sender
{
    if(sender == self.justButton)
    {
        [self.justButton setSelected:YES];
        [self.similarButton setSelected:NO];
    }
    else if(sender == self.similarButton)
    {
        [self.similarButton setSelected:YES];
        [self.justButton setSelected:NO];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [[UIColor cellColor] set];
	UIRectFill(rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    //Gray Horizontal Top Line
    CGContextSaveGState(context); {
        CGFloat componentsGrayTop[] = {0.247, 0.247, 0.247, 1.0};
        CGColorRef colorGrayTop = CGColorCreate(colorspace, componentsGrayTop);
        CGContextSetStrokeColorWithColor(context, colorGrayTop);
        CGContextMoveToPoint(context, 0, .5);
        CGContextAddLineToPoint(context, 320, .5);
        CGColorRelease(colorGrayTop);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
    //Black Horizontal Bottom Line
    CGContextSaveGState(context); {
        CGFloat componentsBlackBottom[] = {0.0, 0.0, 0.0, 1.0};
        CGColorRef colorBlackBottom = CGColorCreate(colorspace, componentsBlackBottom);
        CGContextSetStrokeColorWithColor(context, colorBlackBottom);
        CGContextMoveToPoint(context, 0, CGRectGetMaxY(rect) - .5);
        CGContextAddLineToPoint(context, 320, CGRectGetMaxY(rect) - .5);
        CGColorRelease(colorBlackBottom);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorspace);
}

@end
