//
//  LoggedInUserCell.m
//  Tubalr
//
//  Created by Chad Zeluff on 2/3/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "LoggedInUserCell.h"

@implementation LoggedInUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    [self.contentView addSubview:self.logoutButton];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (UIButton *)logoutButton
{
    if(_logoutButton == nil)
    {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutButton setBackgroundImage:[[UIImage imageNamed:@"btn-cancel"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)] forState:UIControlStateNormal];
        [_logoutButton.titleLabel setFont:[UIFont boldFontOfSize:12.0f]];
        [_logoutButton.titleLabel setShadowColor:[UIColor blackColor]];
        [_logoutButton.titleLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
        [_logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_logoutButton setTitle:@"LOGOUT" forState:UIControlStateNormal];
        [_logoutButton sizeToFit];
        _logoutButton.center = self.contentView.center;
    }
    
    return _logoutButton;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat moveOver = 10.0f;
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x += moveOver;
    frame.size.width -= moveOver;
    self.textLabel.frame = frame;
    
    frame = self.imageView.frame;
    frame.origin.x += moveOver;
    self.imageView.frame = frame;
    
    frame = self.logoutButton.frame;
    frame.origin.x = 245;
    frame.size.width = 57.0f;
    self.logoutButton.frame = frame;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

@end
