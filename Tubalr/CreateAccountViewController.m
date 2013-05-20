//
//  CreateAccountViewController.m
//  Tubalr
//

#import "CreateAccountViewController.h"
#import "APIQuery.h"

@interface CreateAccountViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *tubalrLabel;
@property (nonatomic, strong) UILabel *forgotPasswordLabel;
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *confirmPasswordField;

@end

@implementation CreateAccountViewController

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-noise"]];
    
    [self.view addSubview:self.tubalrLabel];
    CGPoint newPosition = CGPointMake(self.view.center.x, 45.0f);
    self.tubalrLabel.center = newPosition;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tubalrLabel.frame), self.view.bounds.size.width, 185.0f) style:UITableViewStyleGrouped];
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
	self.title = @"join";
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
    return 4;
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
            textField.placeholder = @"username";
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            textField.returnKeyType = UIReturnKeyNext;
            textField.tag = 0;
            self.usernameField = textField;
        }
        
        else if (indexPath.row == 1)
        {
            textField.placeholder = @"email";
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            textField.returnKeyType = UIReturnKeyNext;
            textField.tag = 1;
            self.emailField = textField;
        }
        
        else if (indexPath.row == 2)
        {
            textField.placeholder = @"password";
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.returnKeyType = UIReturnKeyNext;
            textField.secureTextEntry = YES;
            textField.tag = 2;
            self.passwordField = textField;
        }
        
        else if (indexPath.row == 3)
        {
            textField.placeholder = @"confirm password";
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.returnKeyType = UIReturnKeyDone;
            textField.secureTextEntry = YES;
            textField.tag = 3;
            self.confirmPasswordField = textField;
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
        [self.emailField becomeFirstResponder];
    }
    else if(indexPath.row == 2)
    {
        [self.passwordField becomeFirstResponder];
    }
    else if(indexPath.row == 3)
    {
        [self.confirmPasswordField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.usernameField || textField == self.emailField || textField == self.passwordField)
    {
        UITextField *nextTextField = (UITextField *)[self.view viewWithTag:textField.tag+1];
        [nextTextField becomeFirstResponder];
    }
    else if(textField == self.confirmPasswordField)
    {        
        NSString *message;
        if([self.usernameField.text isEqualToString:@""] || [self.emailField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""] || [self.confirmPasswordField.text isEqualToString:@""])
            message = @"You must fill in all required fields.";
        
        if(![self.passwordField.text isEqualToString:self.confirmPasswordField.text])
            message = @"Password fields do not match.";
        
        if([self.passwordField.text length] < 6)
            message = @"Password must be at least 6 characters.";
        
        NSString *usernameRegEx = @"[A-Z0-9a-z]+";
        NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegEx];
        if(![usernameTest evaluateWithObject:self.usernameField.text])
            message = @"Username does not appear to be valid. Use alphabetic and numerical characters only.";
        
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        if(![emailTest evaluateWithObject:self.emailField.text])
            message = @"Email address does not appear to be valid.";
        
        if(message != nil)
        {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", nil) message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            return YES;
        }
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.center = self.view.center;
        [self.view addSubview:activityView];
        [activityView startAnimating];
        [textField resignFirstResponder];
        [APIQuery createAccountWithUsername:self.usernameField.text email:self.emailField.text password:self.passwordField.text block:^(NSError *error)
         {
             if(error)
             {
                 [activityView stopAnimating];
                 [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
             }
             else
             {
                 [APIQuery validateAccountWithUsername:self.usernameField.text password:self.passwordField.text block:^(NSError *error)
                  {
                      [activityView stopAnimating];
                      if(error)
                      {
                          [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:@"You're account was successfully created, but we couldn't log you in immediately. Try logging in again in a few minutes." delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
                      }
                      
                      [self.navigationController popViewControllerAnimated:YES];
                  }];
             }
         }];
    }
    return YES;
}

@end
