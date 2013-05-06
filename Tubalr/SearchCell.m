//
//  SearchCell.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/19/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "SearchCell.h"

@interface SearchCell () <UISearchBarDelegate>

@end

@implementation SearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    [self.textLabel setHidden:YES];
    
    [self.contentView addSubview:self.searchBar];
    
    return self;
}

- (UISearchBar *)searchBar
{
    if(_searchBar == nil)
    {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.delegate = self;
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.font = [UIFont regularFontOfSize:15.0f];
        searchField.textColor = [UIColor whiteColor];
    }
    
    return _searchBar;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGRect frame = self.contentView.frame;
////    frame.origin.x += 5;
//    frame.size.width = 310;
    [self.searchBar setFrame:self.contentView.frame];
}

- (void)drawRect:(CGRect)rect
{    
    [[UIColor cellColor] set];
    UIRectFill(rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    //Black Horizontal Bottom Line
    CGContextSaveGState(context); {
        CGFloat componentsBlackBottom[] = {0.0, 0.0, 0.0, 1.0};
        CGColorRef colorBlackBottom = CGColorCreate(colorspace, componentsBlackBottom);
        CGContextSetStrokeColorWithColor(context, colorBlackBottom);
        CGContextMoveToPoint(context, 0, CGRectGetMaxY(rect) - .5);
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect) - .5);
        CGColorRelease(colorBlackBottom);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorspace);
}

# pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(searchButtonPressedWithString:)])
        [self.delegate searchButtonPressedWithString:searchBar.text];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
//    CGRect frame = searchBar.frame;
//    frame.origin.x -= 5;
//    [searchBar setFrame:frame];
    [self setNeedsDisplay];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
//    CGRect frame = searchBar.frame;
//    frame.origin.x += 5;
//    [searchBar setFrame:frame];
    [searchBar resignFirstResponder];
    [self setNeedsDisplay];
    return YES;
}

@end
