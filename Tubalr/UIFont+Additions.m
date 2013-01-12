//
//  UIFont+Additions.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/11/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "UIFont+Additions.h"

@implementation UIFont (Additions)

+ (UIFont *)regularFontOfSize:(CGFloat)size
{
    return [self fontWithName:@"PT_Sans-Web-Regular" size:size];
}

+ (UIFont *)boldFontOfSize:(CGFloat)size
{
    return [self fontWithName:@"PT_Sans-Web-Bold" size:size];
}

@end
