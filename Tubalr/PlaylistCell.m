//
//  PlaylistCell.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/19/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "PlaylistCell.h"

@implementation PlaylistCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-arrow"]];
    self.accessoryView = imageView;
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = 16.0f;
    frame.size.width = self.bounds.size.width - frame.origin.x;
    self.textLabel.frame = frame;
}

@end
