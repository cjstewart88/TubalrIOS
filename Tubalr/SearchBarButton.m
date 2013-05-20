//
//  SearchBarButton.m
//  Tubalr
//

#import "SearchBarButton.h"

@implementation SearchBarButton

+ (id)buttonWithType:(UIButtonType)buttonType
{
    UIButton *button = [super buttonWithType:buttonType];
    if(!button)
        return nil;
    
    button.titleLabel.font = [UIFont boldFontOfSize:11.0f];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowColor = [UIColor blackColor];
    button.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    
    return button;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    BOOL isSelected = [self isSelected];
    UIColor *cellColor = isSelected ? [UIColor cellHighlightColor] : [UIColor cellColor];
    [cellColor set];
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
    
    //Gray Horizontal Top Line - this differs depending on selection
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
