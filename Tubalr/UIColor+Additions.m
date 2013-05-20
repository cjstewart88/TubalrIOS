//
//  UIColor+Additions.m
//  Tubalr
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor *)cellColor
{
    return [self colorWithRed:0.161 green:0.161 blue:0.161 alpha:1.0];
}

+ (UIColor *)cellHighlightColor
{
    return [self colorWithRed:0.275 green:0.525 blue:0.945 alpha:1];
}

+ (UIColor *)mainHighlightColor
{
    return [self colorWithRed:0.247 green:0.247 blue:0.247 alpha:1.0];
}

@end
