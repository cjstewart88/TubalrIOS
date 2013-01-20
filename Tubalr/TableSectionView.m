//
//  TableSectionView.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/19/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "TableSectionView.h"

@interface TableSectionView()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TableSectionView

- (id)initWithFrame:(CGRect)frame title:(NSString *)string
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    self.titleLabel.text = [string uppercaseString];
    [self addSubview:self.titleLabel];
    
    return self;
}

- (UILabel *)titleLabel
{
    if(_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont regularFontOfSize:13.0f];
        _titleLabel.textColor = [UIColor colorWithRed:0.502 green:0.502 blue:0.502 alpha:1];
    }
    
    return _titleLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat xPos = 15.0f;
    self.titleLabel.frame = CGRectMake(15.0f, 0.0, self.bounds.size.width - xPos, self.bounds.size.height);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [[UIColor colorWithRed:0.102 green:0.102 blue:0.102 alpha:1] set];
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
