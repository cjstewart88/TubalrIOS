//
//  Slider.m
//  Tubalr
//

#import "Slider.h"

@implementation Slider

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, -10, -10);
    return CGRectContainsPoint(bounds, point);
}

@end
