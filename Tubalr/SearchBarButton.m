//
//  SearchBarButton.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/20/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "SearchBarButton.h"

@implementation SearchBarButton

+ (id)buttonWithType:(UIButtonType)buttonType
{
    UIButton *button = [super buttonWithType:buttonType];
    if(!button)
        return nil;
    
    button.titleLabel.font = [UIFont boldFontOfSize:15.0f];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowColor = [UIColor blackColor];
    button.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    button.adjustsImageWhenHighlighted = NO;
    [button setBackgroundImage:[[UIImage imageNamed:@"bg-search"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"btn-search-active"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forState:UIControlStateSelected];
    [button setBackgroundImage:[[UIImage imageNamed:@"btn-search-active"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forState:UIControlStateSelected | UIControlStateHighlighted];
    
    return button;
}

@end
