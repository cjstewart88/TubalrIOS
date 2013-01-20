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
    
    CGRect frame = self.contentView.frame;
    frame.origin.x += 5;
    frame.size.width = 310;
    [self.searchBar setFrame:frame];
}

# pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    CGRect frame = searchBar.frame;
    frame.origin.x -= 5;
    [searchBar setFrame:frame];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    CGRect frame = searchBar.frame;
    frame.origin.x += 5;
    [searchBar setFrame:frame];
    [searchBar resignFirstResponder];
    return YES;
}

@end
