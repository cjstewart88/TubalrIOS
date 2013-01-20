//
//  NowPlayingCell.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/10/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "NowPlayingCell.h"

@interface NowPlayingCell ()

@property (nonatomic, strong) UILabel *iconTextLabel;

@end

@implementation NowPlayingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    [self.contentView addSubview:self.iconTextLabel];
    
    return self;
}

- (void)setVideoDictionary:(NSDictionary *)videoDictionary
{
    _videoDictionary = videoDictionary;
    
    self.textLabel.text = [[_videoDictionary objectForKey:@"title"] stringByDecodingHTMLEntities];
    
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if(selected)
    {
        [self.contentView setBackgroundColor:[UIColor cellHighlightColor]];
        self.textLabel.shadowColor = nil;
        self.iconTextLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-pause"];
        self.iconTextLabel.shadowColor = nil;
    }
    else
    {
        [self.contentView setBackgroundColor:[UIColor cellColor]];
        self.textLabel.shadowColor = [UIColor blackColor];
        self.iconTextLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-play"];
        self.iconTextLabel.shadowColor = [UIColor blackColor];
    }

    // Configure the view for the selected state
}

- (UILabel *)iconTextLabel
{
    if(_iconTextLabel == nil)
    {
        _iconTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _iconTextLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:13.0f];
        _iconTextLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-play"];
        _iconTextLabel.textColor = [UIColor whiteColor];
        _iconTextLabel.backgroundColor = [UIColor clearColor];
        _iconTextLabel.shadowColor = [UIColor blackColor];
        _iconTextLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    }
    
    return _iconTextLabel;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
        
    CGSize iconTextLabelSize = CGSizeMake(16.0f, 16.0f);
    CGFloat iconY = (self.bounds.size.height/2.0f) - (iconTextLabelSize.height/2.0f);
    [self.iconTextLabel setFrame:CGRectMake(16.0f,iconY,iconTextLabelSize.width,iconTextLabelSize.height)];
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = 41.0f;
    frame.size.width = self.bounds.size.width - frame.origin.x - self.iconTextLabel.frame.origin.x;
    self.textLabel.frame = frame;
}

@end
