//
//  UIFont+Additions.m
//  Tubalr
//

#import "UIFont+Additions.h"

@implementation UIFont (Additions)

+ (UIFont *)regularFontOfSize:(CGFloat)size
{
    return [self fontWithName:@"PTSans-Regular" size:size];
}

+ (UIFont *)boldFontOfSize:(CGFloat)size
{
    return [self fontWithName:@"PTSans-Bold" size:size];
}

@end
