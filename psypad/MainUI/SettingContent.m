//
//  SettingContent.m
//  psypad
//
//  Created by LiuYuHan on 10/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "SettingContent.h"
#import "TestConfiguration.h"
#import "TestSequence.h"
#import "DatabaseManager.h"
#import "AvailableConfiguration.h"
#import "MBProgressHUD.h"
#import "ServerManager.h"
#import "StartPage.h"
#import "RootEntity.h"
#import "YHSocket.h"
#import "YHBarChart.h"

@interface SettingContent () <UISplitViewControllerDelegate>

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation SettingContent

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    NSMutableArray *setting_name = [[NSMutableArray alloc]initWithObjects:@"Test Configurations",@"Server URL",@"Records",@"Download Logs",@"Change Password",@"User Info", nil];
    _settingToSectionTitles = [[NSMutableDictionary alloc]init];
    [_settingToSectionTitles setObject:[[NSMutableArray alloc]initWithObjects:@"Downloaded Configuration",@"Avaliable Configuration",@"Updatable Configuration", nil] forKey:[setting_name objectAtIndex:0]];
    
    [_settingToSectionTitles setObject:[[NSMutableArray alloc]initWithObjects:@"Change URL", nil] forKey:[setting_name objectAtIndex:1]];
    [_settingToSectionTitles setObject:[[NSMutableArray alloc]initWithObjects:@"", nil] forKey:[setting_name objectAtIndex:2]];
    [_settingToSectionTitles setObject:[[NSMutableArray alloc]initWithObjects:@"Set File Name", nil] forKey:[setting_name objectAtIndex:3]];
    [_settingToSectionTitles setObject:[[NSMutableArray alloc]initWithObjects:@"Old Passcode",@"New Passcode",@"Repeat New Passcode", nil] forKey:[setting_name objectAtIndex:4]];
    [_settingToSectionTitles setObject:[[NSMutableArray alloc]initWithObjects:@"Basic Information", nil] forKey:[setting_name objectAtIndex:5]];
    
    
    _settingToSections = [[NSMutableDictionary alloc]init];
    [_settingToSections setObject:[[NSMutableArray alloc]initWithObjects:[[NSMutableArray alloc]initWithObjects:@"", nil], nil] forKey:[setting_name objectAtIndex:1]];
    [_settingToSections setObject:[[NSMutableArray alloc]initWithObjects:[[NSMutableArray alloc] initWithObjects: @"Original Data",@"Analysis", nil] ,nil] forKey:[setting_name objectAtIndex:2]];
    [_settingToSections setObject:[[NSMutableArray alloc]initWithObjects:[[NSMutableArray alloc]initWithObjects:@"", nil], nil] forKey:[setting_name objectAtIndex:3]];
    [_settingToSections setObject:[[NSMutableArray alloc]initWithObjects:[[NSMutableArray alloc]initWithObjects:@"", nil], [[NSMutableArray alloc]initWithObjects:@"", nil], [[NSMutableArray alloc]initWithObjects:@"", nil], nil] forKey:[setting_name objectAtIndex:4]];
    
    //[self.tableView setScrollEnabled:NO];
    //[self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    //[self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 20, 0, 20)];
    
    [self initializeTextFiled];
    [self reloadData];
}

-(void) reloadData{
    //NSLog(@"%@",_settingString);
    self.title = _settingString;
    if ([_settingString isEqualToString:@"Server URL"]) {
        UIButton *aButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        [aButton setTitle:@"Save Changes" forState:UIControlStateNormal];
        [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        aButton.backgroundColor = [UIColor redColor];
        [aButton addTarget:self action:@selector(saveURL) forControlEvents:UIControlEventTouchDown];
        self.tableView.tableFooterView = aButton;
    }
    else if([_settingString isEqualToString:@"Download Logs"]) {
        UIButton *aButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-60, 60)];
        [aButton setTitle:@"Download" forState:UIControlStateNormal];
        [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        aButton.backgroundColor = [UIColor redColor];
        [aButton addTarget:self action:@selector(downloadFile) forControlEvents:UIControlEventTouchDown];
        self.tableView.tableFooterView = aButton;
    }
    else if([_settingString isEqualToString:@"Change Password"]) {
        UIButton *aButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-60, 60)];
        [aButton setTitle:@"Change Password" forState:UIControlStateNormal];
        [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        aButton.backgroundColor = [UIColor redColor];
        [aButton addTarget:self action:@selector(savePasscode) forControlEvents:UIControlEventTouchDown];
        self.tableView.tableFooterView = aButton;
    }
    else if([_settingString isEqualToString:@"Records"]){
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString * userID = [userdefault objectForKey:@"LoginUser"];
        NSString *aKey = [[NSString alloc]initWithFormat:@"%@Data",userID];
        if ([userdefault objectForKey:aKey]) {
            _recordData = [[NSMutableArray alloc]initWithArray:[userdefault objectForKey:aKey]];
        }
        else{
            _recordData = [[NSMutableArray alloc]init];
        }
        NSMutableArray *tmpData = [[NSMutableArray alloc]init];
        NSMutableArray *tmpColor = [[NSMutableArray alloc]init];
        NSMutableArray *tmpText = [[NSMutableArray alloc]init];
        NSMutableArray *tmpTitle = [[NSMutableArray alloc]init];
        if ([_recordData count] > 0) {
            for (NSDictionary *dict in _recordData) {
                [tmpData addObject:[dict objectForKey:@"Threshold"]];
                [tmpTitle addObject:[dict objectForKey:@"Threshold_str"]];
                [tmpText addObject:[dict objectForKey:@"Date_str"]];
                BOOL mig = [[dict objectForKey:@"Migraine"] boolValue];
                if (mig) {
                    [tmpColor addObject:[UIColor colorWithRed:203.0/255.0 green:220.0/255.0 blue:235.0/255.0 alpha:1.0]];
                }else{
                    [tmpColor addObject:[UIColor colorWithRed:247.0/255.0 green:228.0/255.0 blue:210.0/255.0 alpha:1.0]];
                }
            }
        }
        
        _barchartView = [[YHBarChart alloc]initWithFrame:CGRectMake(3.5/2.0, 0, 700, 300)];
        
        _barchartView.barData = tmpData;
        _barchartView.barColor = tmpColor;
        _barchartView.barText = tmpText;
        _barchartView.barInfo = tmpTitle;
        
        [_barchartView reDraw];
    }
    else{
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    _sectionTitle = [_settingToSectionTitles objectForKey:_settingString];
    if ([_settingString isEqualToString:@"Test Configurations"]) {
        [self.tableView setScrollEnabled:YES];
        [self reloadConfigurations];
    }
    else if([_settingString isEqualToString:@"Records"]){
        [self.tableView setScrollEnabled:YES];
    }
    else{
        [self.tableView setScrollEnabled:NO];
        _sections = [_settingToSections objectForKey:_settingString];
    }
    [self.tableView reloadData];
}


-(void)viewDidAppear:(BOOL)animated{
    if ([_settingString isEqualToString:@"Test Configurations"]) {
        [self reloadConfigurations];
    }
}

- (void)reloadConfigurations
{
    //_downloadedConfigurations = [[NSArray alloc]initWithObjects:@"Null", nil];
    //_updatableConfigurations = [[NSArray alloc]initWithObjects:@"Null", nil];
    //_availableConfigurations = [[NSArray alloc]initWithObjects:@"Null", nil];
    
    _downloadedConfigurations = [TestConfiguration MR_findByAttribute:TestConfigurationAttributes.is_gallery_configuration withValue:@YES andOrderBy:TestConfigurationAttributes.name ascending:YES];
    
    //if ([_downloadedConfigurations count] > 0) {
    //    TestConfiguration *tmpConfigure = [_downloadedConfigurations objectAtIndex:0];
    //}
    
    
    
    //self.hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    //self.hud.labelText = @"Loading Configurations...";
    
    __weak typeof (self) weakSelf = self;
     
    [[ServerManager sharedManager] loadConfigurationsWithSuccess:^(NSArray *updatableConfigurations, NSArray *downloadableConfigurations)
     {
         weakSelf.updatableConfigurations = updatableConfigurations;
         weakSelf.availableConfigurations = downloadableConfigurations;
         
         //[weakSelf.hud hide:YES];
         
         [weakSelf.tableView reloadData];
     } failure:^(NSString *error)
     {
         //[weakSelf.hud hide:YES];
         [[[UIAlertView alloc] initWithTitle:@"Failed to Load Configurations"
                                     message:error
                                    delegate:nil
                           cancelButtonTitle:@"Close"
                           otherButtonTitles:nil] show];
     }];
}

-(void)saveURL{
    [RootEntity rootEntity].server_url = _urlField.text;
    [DatabaseManager save];
}

-(void)showSingleButtonAlertWithTitle:(NSString *)title andContent:(NSString *)content andButton:(NSString *)buttonTitle{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)savePasscode{
    NSString *oldPwd = [_pwdOldField text];
    NSString *new1Pwd = [_pwdNew1Field text];
    NSString *new2Pwd = [_pwdNew2Field text];
    if ((oldPwd.length == 0 && new1Pwd.length == 0 && new2Pwd.length == 0)
        || (oldPwd.length == 0 && new1Pwd.length == 0)
        || (oldPwd.length == 0 && new2Pwd.length == 0)) {
        [self showSingleButtonAlertWithTitle:@"Empty Fields" andContent:@"Please input all fields to change your password." andButton:@"Try Again"];
    }
    else if((new1Pwd.length == 0 && new2Pwd.length == 0)|| new1Pwd.length == 0){
        [self showSingleButtonAlertWithTitle:@"Empty Fields" andContent:@"Please input your new password to change the password." andButton:@"Try Again"];
    }
    else if (oldPwd.length == 0) {
        [self showSingleButtonAlertWithTitle:@"Empty Field" andContent:@"Please input your old password first to change your password." andButton:@"Try Again"];
    }
    else if (new2Pwd.length == 0){
        [self showSingleButtonAlertWithTitle:@"Empty Field" andContent:@"Please repeat your new password to change your password." andButton:@"Try Again"];
    }
    else{
        if (![new1Pwd isEqualToString:new2Pwd]) {
            [self showSingleButtonAlertWithTitle:@"Different New Password" andContent:@"Please ensure two new passwords you input are the same." andButton:@"Try Again"];
        }
        else{
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            NSString * userID = [userdefault objectForKey:@"LoginUser"];
            NSString *sendMessage = [[NSString alloc]initWithFormat:@"ChangePWD:ID:%@,OLD_PWD:%@,NEW_PWD:%@",userID,oldPwd,new1Pwd];
            YHSocket *communication = [[YHSocket alloc]initWithIP:SHAREDIP andPortNo:SHAREDPORT];
            NSString *receiveString = [communication receiveStringWithMessage:sendMessage];
            //NSLog(@"Received: %@", receiveString);
            if ([receiveString isEqualToString:@"Success"]){
                [self showSingleButtonAlertWithTitle:@"Success" andContent:@"Your password has been changed successfully." andButton:@"Close"];
            }
            else if([receiveString isEqualToString:@"Invalid Password"]){
                [self showSingleButtonAlertWithTitle:@"Wrong Password" andContent:@"The old password is incorrect. Please check and try again." andButton:@"Try Again"];
            }
            else if([receiveString isEqualToString:@"Connection failed."]){
                [self showSingleButtonAlertWithTitle:@"Connection Failed" andContent:@"Please check your Internet connection. Sometimes the server is unavailable, please try again later." andButton:@"Try Again"];
            }
            else{//changed failed
                [self showSingleButtonAlertWithTitle:@"Change Failed" andContent:receiveString andButton:@"Try Again"];
            }
        }
    }
}

-(void)downloadFile{
    NSString *sendMessage = [[NSString alloc]initWithFormat:@"Download:%@",_fileField.text];
    YHSocket *communication = [[YHSocket alloc]initWithIP:SHAREDIP andPortNo:SHAREDPORT];
    NSString *receiveString = [communication receiveStringWithMessage:sendMessage];
    //NSLog(@"Received: %@", receiveString);
    if (![receiveString isEqualToString:@"Success"]) {
        //NSLog(@"Server Error");
    }
}

-(void)initializeTextFiled{
    _urlField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width-10, 45)];
    _urlField.tag = 0;
    _urlField.placeholder = @"Server URL";
    _urlField.text = @"localhost";
    _urlField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _urlField.keyboardType = UIKeyboardTypeURL;
    _urlField.delegate = self;
    _urlField.textColor = [UIColor blackColor];
    _urlField.returnKeyType = UIReturnKeyDone;
    
    _fileField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width-10, 45)];
    _fileField.tag = 0;
    _fileField.placeholder = @"Log File Name";
    _fileField.text = @"logFile";
    _fileField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _fileField.keyboardType = UIKeyboardTypeDefault;
    _fileField.delegate = self;
    _fileField.textColor = [UIColor blackColor];
    _fileField.returnKeyType = UIReturnKeyDone;
    
    _pwdOldField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width-10, 45)];
    _pwdOldField.tag = 0;
    _pwdOldField.placeholder = @"Old Passcode";
    _pwdOldField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdOldField.keyboardType = UIKeyboardTypeDefault;
    _pwdOldField.secureTextEntry = YES;
    _pwdOldField.delegate = self;
    _pwdOldField.textColor = [UIColor blackColor];
    _pwdOldField.returnKeyType = UIReturnKeyNext;
    
    _pwdNew1Field = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width-10, 45)];
    _pwdNew1Field.tag = 0;
    _pwdNew1Field.placeholder = @"New Passcode";
    _pwdNew1Field.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdNew1Field.keyboardType = UIKeyboardTypeDefault;
    _pwdNew1Field.secureTextEntry = YES;
    _pwdNew1Field.delegate = self;
    _pwdNew1Field.textColor = [UIColor blackColor];
    _pwdNew1Field.returnKeyType = UIReturnKeyNext;
    
    _pwdNew2Field = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width-10, 45)];
    _pwdNew2Field.tag = 0;
    _pwdNew2Field.placeholder = @"New Passcode Again";
    _pwdNew2Field.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdNew2Field.keyboardType = UIKeyboardTypeDefault;
    _pwdNew2Field.secureTextEntry = YES;
    _pwdNew2Field.delegate = self;
    _pwdNew2Field.textColor = [UIColor blackColor];
    _pwdNew2Field.returnKeyType = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_settingString isEqualToString:@"Test Configurations"])
    {
        return 3;
    }
    else if([_settingString isEqualToString:@"Records"]){
        return 2;
    }else{
        return [_sectionTitle count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_settingString isEqualToString:@"Test Configurations"]){
        if (section == 0) {
            return [self.downloadedConfigurations count] == 0 ? 1 : [self.downloadedConfigurations count];
        }
        else if(section == 1){
            return [self.availableConfigurations count] == 0 ? 1 : [self.availableConfigurations count];
        }
        else{
            return [self.updatableConfigurations count] == 0 ? 1 : [self.updatableConfigurations count];
        }
    }
    else if([_settingString isEqualToString:@"Records"]){
        if (section == 0) {
            return 1;
        }
        else{
            if ([_recordData count] > 0){
                return [_recordData count];
                
            }else{
                return 1;
            }
        }
    }
    else if([_settingString isEqualToString:@"User Info"]){
        return 1;
    }
    else{
        return [[_sections objectAtIndex:section] count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.subviews];
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            [subview removeFromSuperview];
        }
        if ([subview isKindOfClass:[YHBarChart class]]) {
            [subview removeFromSuperview];
        }
    }
    
    if ([_settingString isEqualToString:@"Test Configurations"]) {
        NSString *cellText;
        if (indexPath.section == 0) {
            if ([self.downloadedConfigurations count] == 0) {
                cellText = @"Null";
            }else{
                if (indexPath.row == 0) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
                
                cellText = [[NSString alloc]initWithFormat:@"%@",[[self.downloadedConfigurations objectAtIndex:indexPath.row] name]];
            }
        }
        else if(indexPath.section == 1){
            if ([self.availableConfigurations count] == 0) {
                cellText = @"Null";
            }else{
                cellText = [[NSString alloc]initWithFormat:@"%@",[[self.availableConfigurations objectAtIndex:indexPath.row] name]];
            }
        }
        else{
            if ([self.updatableConfigurations count] == 0) {
                cellText = @"Null";
            }else{
                cellText = [[NSString alloc]initWithFormat:@"%@",[[self.updatableConfigurations objectAtIndex:indexPath.row] name]];
            }
        }
        //NSLog(@"%@", cellText);
        cell.textLabel.text = cellText;
    }
    else if([_settingString isEqualToString:@"Records"]){
        
        if (indexPath.section == 0) {
            cell.textLabel.text = @"";
            //NSLog(@"%f",cell.contentView.frame.size.height);
            [cell addSubview:_barchartView];
            cell.detailTextLabel.text = @"";
        }
        else{
            if ([_recordData count] > 0) {
                cell.textLabel.text = [[_recordData objectAtIndex:indexPath.row] objectForKey:@"Date_str"];
                cell.detailTextLabel.text = [[_recordData objectAtIndex:indexPath.row] objectForKey:@"Threshold_str"];
            }else{
                cell.textLabel.text = @"No Data";
            }
        }
        
    }
    else if([_settingString isEqualToString:@"User Info"]){
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString * userID = [userdefault objectForKey:@"LoginUser"];
        cell.textLabel.text = @"ID";
        cell.detailTextLabel.text = userID;
    }
    
    else{
        cell.textLabel.text = [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
        if ([_settingString isEqualToString:@"Server URL"]) {
            if (indexPath.section == 0 && indexPath.row == 0) {
                [cell addSubview:_urlField];
            }
        }
        else if([_settingString isEqualToString:@"Download Logs"]){
            if (indexPath.section == 0 && indexPath.row == 0) {
                [cell addSubview:_fileField];
            }
        }
        else if([_settingString isEqualToString:@"Change Password"]){
            if (indexPath.section == 0 && indexPath.row == 0) {
                [cell addSubview:_pwdOldField];
            }
            else if (indexPath.section == 1 && indexPath.row == 0) {
                [cell addSubview:_pwdNew1Field];
            }
            else if (indexPath.section == 2 && indexPath.row == 0) {
                [cell addSubview:_pwdNew2Field];
            }
            cell.detailTextLabel.text = @"";
        }
    }
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if([_settingString isEqualToString:@"Records"]){
        if (section == 0) {
            return @"Recent Results";
        }
        else{
            return @"All Data";
        }
    }
    else{
        return [_sectionTitle objectAtIndex:section];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if ([_settingString isEqualToString:@"Test Configurations"]) {
        if (section == 0) {
            return @"You can select one as default configuration.";
        }else if(section == 1){
            return @"You can download configurations from server.";
        }else{
            return @"You can update configurations if avaliable.";
        }
    }
    else{
        return @"";
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_settingString isEqualToString:@"Records"]){
        if (indexPath.section == 0) {
            return 300.0f;
        }
        else{
            return 45.0f;
        }
    }
    else{
        return 45.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([_settingString isEqualToString:@"Test Configurations"]){
        return 40;
    }else{
        if (section == [_sectionTitle count] - 1) {
            return 20;
        }
        else
            return 0;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _urlField) {
        [_urlField resignFirstResponder];
    }
    else if (textField == _fileField){
        [_fileField resignFirstResponder];
    }
    else if (textField == _pwdOldField){
        [_pwdNew1Field becomeFirstResponder];
    }
    else if (textField == _pwdNew1Field){
        [_pwdNew2Field becomeFirstResponder];
    }
    else{
        [_pwdNew2Field resignFirstResponder];
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_settingString isEqualToString:@"Test Configurations"]) {
        if (indexPath.section == 1) {//To Download Configuration
            if ([self.availableConfigurations count] > 0) {
                NSString *aMessage = [[NSString alloc]initWithFormat:@"Do you want to download %@?",[[self.availableConfigurations objectAtIndex:indexPath.row] name]];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Download" message:aMessage preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *downloadAction = [UIAlertAction actionWithTitle:@"Download" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self downloadConfigurationWithIndex:indexPath.row];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:downloadAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        else if(indexPath.section == 2) {//To Update Configuration
            if ([self.availableConfigurations count] > 0) {
                NSString *aMessage = [[NSString alloc]initWithFormat:@"Do you want to update %@?",[[self.availableConfigurations objectAtIndex:indexPath.row] name]];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Update" message:aMessage preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *downloadAction = [UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self updateConfigurationWithIndex:indexPath.row];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:downloadAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        else{//Play
            if ([self.downloadedConfigurations count] > 0) {
                [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
                
                //NSLog(@"%@",[self.downloadedConfigurations objectAtIndex:indexPath.row]);
                //NSLog(@"%@",[[self.downloadedConfigurations objectAtIndex:indexPath.row] objectID]);
                
                //[[NSUserDefaults standardUserDefaults] setObject:[self.downloadedConfigurations objectAtIndex:indexPath.row] forKey:@"SelectedConfiguration"];
                //[[NSUserDefaults standardUserDefaults] synchronize];
                
                self.firstPageVC.selected_configurations = [self.downloadedConfigurations objectAtIndex:indexPath.row];
            }
        }
    }
    else{
        
    }
    
    
}

- (void)downloadConfigurationWithIndex:(NSInteger)index
{
    AvailableConfiguration *configuration = self.availableConfigurations[index];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Downloading configuration...";
    
    __weak typeof(self) weakSelf = self;
    
    //NSString *tmpConfigID = @"2063";
    //NSString *tmpURL = @"/api/configurations/2062?1501925749";
    
    [[ServerManager sharedManager] downloadConfiguration:configuration.configID
                                                   atURL:configuration.url
                                                progress:^(NSString *status, float progress)
     {
         weakSelf.hud.labelText = status;
         weakSelf.hud.progress = progress;
         
     } success:^(TestConfiguration *configuration)
     {
         [weakSelf.hud hide:YES];
         [weakSelf.hud removeFromSuperview];
         
         [weakSelf reloadConfigurations];
         [weakSelf.tableView reloadData];
         
         [[[UIAlertView alloc] initWithTitle:@""
                                     message:@"Configuration downloaded successfully."
                                    delegate:nil
                           cancelButtonTitle:@"Close"
                           otherButtonTitles:nil] show];
         
     } failure:^(NSString *error)
     {
         [weakSelf.hud hide:YES];
         [weakSelf.hud removeFromSuperview];
         
         [[[UIAlertView alloc] initWithTitle:@"Failed to Download Configuration"
                                     message:error
                                    delegate:nil
                           cancelButtonTitle:@"Close"
                           otherButtonTitles:nil] show];
     }];
}

- (void)updateConfigurationWithIndex:(NSInteger)index{
    AvailableConfiguration *configuration = self.updatableConfigurations[index];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Updating configuration...";
    
    __weak typeof(self) weakSelf = self;
    
    [[ServerManager sharedManager] downloadConfiguration:configuration.configID
                                                   atURL:configuration.url
                                                progress:^(NSString *status, float progress)
     {
         weakSelf.hud.labelText = status;
         weakSelf.hud.progress = progress;
         
     } success:^(TestConfiguration *configuration)
     {
         [weakSelf.hud hide:YES];
         [weakSelf.hud removeFromSuperview];
         [weakSelf reloadConfigurations];
         [weakSelf.tableView reloadData];
         [[[UIAlertView alloc] initWithTitle:@""
                                     message:@"Configuration updated successfully."
                                    delegate:nil
                           cancelButtonTitle:@"Close"
                           otherButtonTitles:nil] show];
         
     } failure:^(NSString *error)
     {
         [weakSelf.hud hide:YES];
         [weakSelf.hud removeFromSuperview];
         
         [[[UIAlertView alloc] initWithTitle:@"Failed to Update Configuration"
                                     message:error
                                    delegate:nil
                           cancelButtonTitle:@"Close"
                           otherButtonTitles:nil] show];
     }];
}

- (void)deleteConfigurationWithIndex:(NSInteger)index{
    TestConfiguration *configuration = self.downloadedConfigurations[index];
    
    __weak typeof(self) weakSelf = self;
    [configuration MR_deleteEntity];
    [DatabaseManager save];
    if (weakSelf.updatableConfigurations || weakSelf.availableConfigurations)
        [weakSelf reloadConfigurations];
    [weakSelf.tableView reloadData];
}

@end
