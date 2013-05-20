//
//  JustSimilarView.m
//  Tubalr
//

#import "JustSimilarView.h"
#import "SearchBarButton.h"

@interface JustSimilarView()

@property (nonatomic, strong) SearchBarButton *justButton;
@property (nonatomic, strong) SearchBarButton *similarButton;

@end

@implementation JustSimilarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    self.backgroundColor = [UIColor cellColor];
    [self addSubview:self.justButton];
    [self addSubview:self.similarButton];
    [self setJustSelected:YES];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.justButton setFrame:CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height)];
    [self.similarButton setFrame:CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height)];
}

- (void)setJustSelected:(BOOL)selected
{
    [self.justButton setSelected:selected];
    [self.similarButton setSelected:!selected];
}

- (SearchBarButton *)justButton
{
    if(_justButton == nil)
    {
        _justButton = [SearchBarButton buttonWithType:UIButtonTypeCustom];
        [_justButton setTitle:@"ONLY" forState:UIControlStateNormal];
        [_justButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _justButton;
}

- (SearchBarButton *)similarButton
{
    if(_similarButton == nil)
    {
        _similarButton = [SearchBarButton buttonWithType:UIButtonTypeCustom];
        [_similarButton setTitle:@"SIMILAR" forState:UIControlStateNormal];
        [_similarButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _similarButton;
}

- (BOOL)isJustSearch
{
    return [self.justButton isSelected];
}

- (void)buttonPressed:(id)sender
{
    if(sender == self.justButton)
    {
        [self.justButton setSelected:YES];
        [self.similarButton setSelected:NO];
    }
    else if(sender == self.similarButton)
    {
        [self.similarButton setSelected:YES];
        [self.justButton setSelected:NO];
    }
}

@end
