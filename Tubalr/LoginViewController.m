//
//  LoginViewController.m
//  Tubalr
//
//  Created by Chad Zeluff on 2/3/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "LoginViewController.h"
#import "APIQuery.h"

@interface LoginViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *tubalrLabel;
@property (nonatomic, strong) UILabel *forgotPasswordLabel;
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;

@end

@implementation LoginViewController

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-noise"]];
    
    [self.view addSubview:self.tubalrLabel];
    CGPoint newPosition = CGPointMake(self.view.center.x, 45.0f);
    self.tubalrLabel.center = newPosition;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tubalrLabel.frame), self.view.bounds.size.width, 110.0f) style:UITableViewStyleGrouped];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-noise"]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"login";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.usernameField becomeFirstResponder];
}

- (UILabel *)tubalrLabel
{
    if(_tubalrLabel == nil)
    {
        _tubalrLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tubalrLabel.backgroundColor = [UIColor clearColor];
        _tubalrLabel.font = [UIFont boldFontOfSize:50.0f];
        _tubalrLabel.textColor = [UIColor whiteColor];
        [_tubalrLabel setText:@"tubalr"];
        [_tubalrLabel sizeToFit];
    }
    
    return _tubalrLabel;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LoginCellIdentifier = @"LoginCell";
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:LoginCellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoginCellIdentifier];
    
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(16.0f, 12.0f, 255.0f, 25.0f)];
        textField.adjustsFontSizeToFitWidth = YES;
        textField.textColor = [UIColor colorWithRed:0.733 green:0.733 blue:0.733 alpha:1];
        textField.font = [UIFont regularFontOfSize:13.0f];
        if (indexPath.row == 0)
        {
            textField.placeholder = @"username or email";
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            textField.returnKeyType = UIReturnKeyNext;
            self.usernameField = textField;
        }
        else
        {
            textField.placeholder = @"password";
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.returnKeyType = UIReturnKeyDone;
            textField.secureTextEntry = YES;
            self.passwordField = textField;
        }
        
        textField.backgroundColor = [UIColor clearColor];// [UIColor colorWithRed:0.102 green:0.102 blue:0.102 alpha:1];
        textField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
        textField.delegate = self;

        textField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
        [textField setEnabled: YES];

        [cell.contentView addSubview:textField];
        cell.backgroundColor = [UIColor colorWithRed:0.102 green:0.102 blue:0.102 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        [self.usernameField becomeFirstResponder];
    }
    else if(indexPath.row == 1)
    {
        [self.passwordField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.usernameField)
    {
        [self.passwordField becomeFirstResponder];
    }
    else if(textField == self.passwordField)
    {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.center = self.view.center;
        [self.view addSubview:activityView];
        [activityView startAnimating];
        [textField resignFirstResponder];
        [APIQuery validateAccountWithUsername:self.usernameField.text password:self.passwordField.text block:^(NSError *error)
         {
             [activityView stopAnimating];
             if(error)
             {
                 //Better, custom error here
                 [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
             }
             else
             {
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }];
    }
    return YES;
}

@end
