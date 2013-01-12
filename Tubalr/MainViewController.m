//
//  MainViewController.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/10/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "MainViewController.h"
#import "NowPlayingViewController.h"

@interface MainViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UIButton *typeOfSearchButton;

@end

@implementation MainViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    CGFloat xCoord = 20, yCoord = 20;
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(xCoord, yCoord, view.bounds.size.width - (xCoord *2), 30)];
    self.searchField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchField.delegate = self;
    
    self.typeOfSearchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.typeOfSearchButton.frame = CGRectMake(123, 58, 73, 44);
    [self.typeOfSearchButton setTitle:@"Just" forState:UIControlStateNormal];
    [self.typeOfSearchButton setTitle:@"Similar" forState:UIControlStateSelected];
    [self.typeOfSearchButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:self.searchField];
    [view addSubview:self.typeOfSearchButton];
    view.backgroundColor = [UIColor whiteColor];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Tubalr";
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)buttonPressed:(id)sender
{
    if([sender isSelected])
    {
        [sender setSelected:NO];
    }
    else
    {
        [sender setSelected:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if(![textField.text isEqualToString:@""])
    {
        SearchType searchType = [self.typeOfSearchButton.titleLabel.text isEqualToString:@"Just"] ? justSearch : similarSearch;
        NowPlayingViewController *nowPlayingVC = [[NowPlayingViewController alloc] initWithSearchString:textField.text searchType:searchType];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];

        [self.navigationController pushViewController:nowPlayingVC animated:YES];
    }
    
    
    
    return YES;
}

@end
