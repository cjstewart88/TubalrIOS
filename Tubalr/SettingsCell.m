//
//  SettingsCell.m
//  Tubalr
//

#import "SettingsCell.h"

@implementation SettingsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
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
    
    CGFloat moveOver = 10.0f;
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x += moveOver;
    frame.size.width -= moveOver;
    self.textLabel.frame = frame;
    
    frame = self.imageView.frame;
    frame.origin.x += moveOver;
    self.imageView.frame = frame;
}

@end
