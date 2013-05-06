//
//  Slider.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/13/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
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
