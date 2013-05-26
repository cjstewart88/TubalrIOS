//
//  UIViewController+TitleBarLabel
//  Tubalr
//

#import "UIViewController+TitleBarLabel.h"
#import "AppDelegate.h"
#import "GenresViewController.h"

@implementation UIViewController (TitleBarLabel)
-(void)setTitleBarLabelWith:(NSString*)title {
    CGRect frame = CGRectMake(0, 10, 0, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldFontOfSize:24.0];
    label.shadowColor = [UIColor blackColor], UITextAttributeTextShadowColor;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(title, @"");
}
@end
