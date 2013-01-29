//
//  SettingsViewController.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/20/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "SettingsViewController.h"
#import "MainViewController.h"
#import "TableSectionView.h"
#import "SettingsCell.h"

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>
{
    CGFloat cellHeight;
    NSInteger cellCount;
    CGFloat headingSize;
    NSInteger headingCount;
    BOOL loggedIn;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *tubalrLabel;
@property (nonatomic, strong) UILabel *versionLabel;

@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) UIButton *existingLoginButton;

@end

@implementation SettingsViewController

- (id)init
{
    self = [super init];
    if(!self)
        return nil;
    
    cellHeight = 45.0f;
    headingSize = 20.0f;
    loggedIn = NO;
    if(loggedIn)
    {
        cellCount = 7;
        headingCount = 1;
    }
    
    else
    {
        cellCount = 6;
        headingCount = 0;
    }
    
//    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://www.tubalr.com/"]];
//    NSDictionary *test = [NSDictionary dictionaryWithObjectsAndKeys:@"macman1", @"password", @"czeluff", @"email_or_username", nil];
//    
//    [client postPath:@"api/sessions.json" parameters:test success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:0];
//        NSLog(@"yay");
//         
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
//        NSLog(@"nay");
//    }];
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-noise"]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, cellCount*cellHeight + headingCount*headingSize) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-noise"]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.tubalrLabel];
    CGPoint newPosition = CGPointMake(self.view.center.x, 475.0f);
    self.versionLabel.center = newPosition;
    newPosition = CGPointMake(self.view.center.x, CGRectGetMinY(self.versionLabel.frame) - 16.0f);
    self.tubalrLabel.center = newPosition;
    
    if(!loggedIn)
    {
        CGFloat xPos = 21.0f;
        self.createButton.frame = CGRectMake(xPos, CGRectGetMaxY(self.tableView.frame) + 15.0f, self.view.bounds.size.width - 2*xPos, 44.0f);
        [self.view addSubview:self.createButton];
        
        self.existingLoginButton.frame = CGRectMake(xPos, CGRectGetMaxY(self.createButton.frame) + 7.0f, self.view.bounds.size.width - 2*xPos, 44.0f);
        [self.view addSubview:self.existingLoginButton];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"settings";
//    self.navigationItem.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    
    UIImage *profileImage = [UIImage imageNamed:@"btn-close-left"];
    UIImage *image = [profileImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, profileImage.size.width, 0, 0)];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [menuButton addSubview:[[UIImageView alloc] initWithImage:image]];
    [menuButton addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [self.navigationItem setLeftBarButtonItem:menuItem];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)donePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UILabel *)tubalrLabel
{
    if(_tubalrLabel == nil)
    {
        _tubalrLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tubalrLabel.backgroundColor = [UIColor clearColor];
        _tubalrLabel.font = [UIFont boldFontOfSize:24.0f];
        _tubalrLabel.textColor = [UIColor whiteColor];
        [_tubalrLabel setText:@"tubalr"];
        [_tubalrLabel sizeToFit];
    }
    
    return _tubalrLabel;
}

- (UILabel *)versionLabel
{
    if(_versionLabel == nil)
    {
        _versionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _versionLabel.backgroundColor = [UIColor clearColor];
        _versionLabel.font = [UIFont regularFontOfSize:10.0f];
        _versionLabel.textColor = [UIColor whiteColor];
        [_versionLabel setText:[NSString stringWithFormat:@"VERSION %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
        [_versionLabel sizeToFit];
    }
    
    return _versionLabel;
}

- (UIButton *)createButton
{
    if(_createButton == nil)
    {
        _createButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_createButton setBackgroundImage:[[UIImage imageNamed:@"btn-blue"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)] forState:UIControlStateNormal];
        [_createButton setTitle:@"JOIN TUBALR FOR FREE" forState:UIControlStateNormal];
        _createButton.titleLabel.font = [UIFont boldFontOfSize:15.0f];
        _createButton.titleLabel.textColor = [UIColor whiteColor];
        _createButton.titleLabel.shadowColor = [UIColor blackColor];
        _createButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    }
    
    return _createButton;
}

- (UIButton *)existingLoginButton
{
    if(_existingLoginButton == nil)
    {
        _existingLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_existingLoginButton setTitle:@"ALREADY HAVE AN ACCOUNT? LOGIN HERE" forState:UIControlStateNormal];
        _existingLoginButton.titleLabel.font = [UIFont regularFontOfSize:11.0f];
        _existingLoginButton.titleLabel.textColor = [UIColor whiteColor];
        _existingLoginButton.titleLabel.shadowColor = [UIColor blackColor];
        _existingLoginButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    }
    
    return _existingLoginButton;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!loggedIn)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 6;
    else if (section == 1)
        return 1;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!loggedIn)
    {
        return 0;
    }
    
    if(section == 0)
        return 0;
   return headingSize; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SettingsCellIdentifier = @"SettingsCell";
    static NSString *ProfileCellIdentifier = @"ProfileCell";
    
    UITableViewCell *cell; 
    
    if(indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:SettingsCellIdentifier];
        if(!cell)
            cell = [[SettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SettingsCellIdentifier];
        
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"www.tubalr.com";
            cell.imageView.image = [UIImage imageNamed:@"icon-settings-computer"];
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"www.twitter.com/tubalr";
            cell.imageView.image = [UIImage imageNamed:@"icon-settings-twitter"];
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = @"www.facebook.com/tubalr";
            cell.imageView.image = [UIImage imageNamed:@"icon-settings-facebook"];
        }
        else if (indexPath.row == 3)
        {
            cell.textLabel.text = @"support@tubalr.com";
            cell.imageView.image = [UIImage imageNamed:@"icon-settings-mail"];
        }
        else if (indexPath.row == 4)
        {
            cell.textLabel.text = @"Rate on App Store";
            cell.imageView.image = [UIImage imageNamed:@"icon-settings-star"];
        }
        else if (indexPath.row == 5)
        {
            cell.textLabel.text = @"Tubalr Team";
            cell.imageView.image = [UIImage imageNamed:@"icon-settings-tubalr"];
        }
    }
    
    else if(indexPath.section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:ProfileCellIdentifier];
        
        if(!cell)
            cell = [[SettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SettingsCellIdentifier];
        
        cell.textLabel.text = [NSString stringWithFormat:@"Cell #%d", indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //No real logic here right now while we only have one heading anyway
    TableSectionView *sectionView = [[TableSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section]) title:@"Your Account"];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Break");
}

@end