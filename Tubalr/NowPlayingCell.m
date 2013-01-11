//
//  NowPlayingCell.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/10/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "NowPlayingCell.h"

@implementation NowPlayingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textColor = [UIColor darkGrayColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    self.detailTextLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return self;
}

- (void)setVideoDictionary:(NSDictionary *)videoDictionary
{
    _videoDictionary = videoDictionary;
    
    self.textLabel.text = [_videoDictionary objectForKey:@"title"];
    self.detailTextLabel.text = @"DetailTextLabel";
    
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIView

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    self.imageView.frame = CGRectMake(10.0f, 10.0f, 50.0f, 50.0f);
//    self.textLabel.frame = CGRectMake(70.0f, 10.0f, 240.0f, 20.0f);
//    
//    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
//    detailTextLabelFrame.size.height = [[self class] heightForCellWithPost:_post] - 45.0f;
//    self.detailTextLabel.frame = detailTextLabelFrame;
//}

@end
