//
//  MovieControlView.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/12/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "MovieControlView.h"

@implementation MovieControlView

-(id)initWithPosition:(CGPoint)point;
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, 320, 79)];
    if(self)
    {
        
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [[UIColor colorWithRed:0.161 green:0.161 blue:0.161 alpha:1] set];
	UIRectFill(rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    //Gray Vertical Lines
    CGContextSaveGState(context); {
        CGFloat componentsGrayVert[] = {0.224, 0.224, 0.224, 1.0};
        CGColorRef colorGrayVert = CGColorCreate(colorspace, componentsGrayVert);
        CGContextSetStrokeColorWithColor(context, colorGrayVert);
        CGContextMoveToPoint(context, 50.25, 0);
        CGContextAddLineToPoint(context, 50.25, 49);
        CGContextMoveToPoint(context, 269.75, 0);
        CGContextAddLineToPoint(context, 269.75, 49);
        CGColorRelease(colorGrayVert);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
    //Black Vertical Lines
    CGContextSaveGState(context); {
        CGFloat componentsBlackVert[] = {0.0, 0.0, 0.0, 1.0};
        CGColorRef colorBlackVert = CGColorCreate(colorspace, componentsBlackVert);
        CGContextSetStrokeColorWithColor(context, colorBlackVert);
        CGContextMoveToPoint(context, 50.75, 0);
        CGContextAddLineToPoint(context, 50.75, 49);
        CGContextMoveToPoint(context, 269.25, 0);
        CGContextAddLineToPoint(context, 269.25, 49);
        CGColorRelease(colorBlackVert);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
    //Gray Horizontal Top Line
    CGContextSaveGState(context); {
        CGFloat componentsGrayTop[] = {0.220, 0.220, 0.220, 1.0};
        CGColorRef colorGrayTop = CGColorCreate(colorspace, componentsGrayTop);
        CGContextSetStrokeColorWithColor(context, colorGrayTop);
        CGContextMoveToPoint(context, 0, .25);
        CGContextAddLineToPoint(context, 320, .25);
        CGColorRelease(colorGrayTop);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
    //Black Horizontal Bottom Line
    CGContextSaveGState(context); {
        CGFloat componentsBlackBottom[] = {0.043, 0.043, 0.043, 1.0};
        CGColorRef colorBlackBottom = CGColorCreate(colorspace, componentsBlackBottom);
        CGContextSetStrokeColorWithColor(context, colorBlackBottom);
        CGContextMoveToPoint(context, 0, 48.75);
        CGContextAddLineToPoint(context, 320, 48.75);
        CGColorRelease(colorBlackBottom);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
    //Gray Horizontal Bottom Line
    CGContextSaveGState(context); {
        CGFloat componentsGrayBottom[] = {0.263, 0.263, 0.263, 1.0};
        CGColorRef colorGrayBottom = CGColorCreate(colorspace, componentsGrayBottom);
        CGContextSetStrokeColorWithColor(context, colorGrayBottom);
        CGContextMoveToPoint(context, 0, 49.25);
        CGContextAddLineToPoint(context, 320, 49.25);
        CGColorRelease(colorGrayBottom);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
//    CGFloat componentsBlackVert[] = {0.0, 0.0, 0.0, 1.0};
//    CGColorRef colorBlackVert = CGColorCreate(colorspace, componentsBlackVert);
//        CGContextSetStrokeColorWithColor(context, colorBlackVert);
//        CGContextMoveToPoint(context, 51, 1);
//        CGContextAddLineToPoint(context, 51, 48);
//        CGContextMoveToPoint(context, 269, 1);
//        CGContextAddLineToPoint(context, 269, 48);
//    CGColorRelease(colorBlackVert);
//    
//    CGFloat componentsBlackBot[] = {0.043, 0.043, 0.043, 1.0};
//    CGColorRef colorBlackBot = CGColorCreate(colorspace, componentsBlackBot);
//        CGContextSetStrokeColorWithColor(context, colorBlackBot);
//        CGContextMoveToPoint(context, 0, 49);
//        CGContextAddLineToPoint(context, 320, 49);
//    CGColorRelease(colorBlackBot);
    
    CGColorSpaceRelease(colorspace);
}

@end
