//
//  CustomCell.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/19/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.textLabel.font = [UIFont regularFontOfSize:15.0f];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.shadowColor = [UIColor blackColor];
    self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    BOOL isSelected = [self isSelected];
    UIColor *color = isSelected ? [UIColor cellHighlightColor] : [UIColor cellColor];
    [color set];
	UIRectFill(rect);
    
    CGFloat r,g,b;
    if(isSelected)
    {
        r = 0.345;
        g = 0.573;
        b = 0.949;
    }
    else
    {
        r = 0.247;
        g = 0.247;
        b = 0.247;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    //Gray Horizontal Top Line
    CGContextSaveGState(context); {
        CGFloat componentsGrayTop[] = {r, g, b, 1.0};
        CGColorRef colorGrayTop = CGColorCreate(colorspace, componentsGrayTop);
        CGContextSetStrokeColorWithColor(context, colorGrayTop);
        CGContextMoveToPoint(context, 0, .5);
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), .5);
        CGColorRelease(colorGrayTop);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
    //Black Horizontal Bottom Line
    CGContextSaveGState(context); {
        CGFloat componentsBlackBottom[] = {0.0, 0.0, 0.0, 1.0};
        CGColorRef colorBlackBottom = CGColorCreate(colorspace, componentsBlackBottom);
        CGContextSetStrokeColorWithColor(context, colorBlackBottom);
        CGContextMoveToPoint(context, 0, CGRectGetMaxY(rect) - .5);
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect) - .5);
        CGColorRelease(colorBlackBottom);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorspace);
}

@end
