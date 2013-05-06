//
//  GenreCell.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/19/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "GenreCell.h"

@implementation GenreCell

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

- (void)setImage:(UIImage *)image titleLabel:(NSString *)string
{
    self.imageView.image = image;
    self.textLabel.text = string;
    
    [self setNeedsLayout];
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize iconSize = CGSizeMake(16.0f, 16.0f);
    CGFloat iconY = (self.bounds.size.height/2.0f) - (iconSize.height/2.0f);
    [self.imageView setFrame:CGRectMake(16.0f,iconY,iconSize.width,iconSize.height)];
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = 41.0f;
    frame.size.width = self.bounds.size.width - frame.origin.x - self.imageView.frame.origin.x;
    self.textLabel.frame = frame;
}

@end
