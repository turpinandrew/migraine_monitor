//
//  FirstLogin.m
//  psypad
//
//  Created by LiuYuHan on 8/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "FirstLogin.h"
#import "LoginTable.h"
#import "StartPage.h"
#import "RootEntity.h"
#import "DatabaseManager.h"
#import "YHSocket.h"
#import "WHWeatherView.h"
#import <CommonCrypto/CommonCrypto.h>
#import "AFNetworking.h"

@interface FirstLogin ()

@end

@implementation FirstLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    WHWeatherView *weatherView = [[WHWeatherView alloc] init];
    weatherView.frame = self.view.bounds;
    [self.view addSubview:weatherView];
    [self.view sendSubviewToBack:weatherView];
    [weatherView showWeatherAnimationWithType:WHWeatherTypeSun];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Login"]){
        //NSLog(@"%@",segue.destinationViewController);
        _table = (LoginTable *)segue.destinationViewController;
        _table.parentVC = self;
    }
}

-(BOOL) validUserIDforLogin:(NSString *)userID{
    //Check whether userID exists in server's database
    
    NSString *sendMessage = [[NSString alloc]initWithFormat:@"Check:%@",userID];
    YHSocket *communication = [[YHSocket alloc]initWithIP:SHAREDIP andPortNo:SHAREDPORT];
    NSString *receiveString = [communication receiveStringWithMessage:sendMessage];
    //NSLog(@"Received: %@", receiveString);
    
    
    if ([receiveString isEqualToString:@"Valid"]) {
        return YES;
    }else{
        return NO;
    }
}

-(NSString *) authenrizeUserID:(NSString *)userID WithPassword:(NSString *)password{
    //Authenrize whether user has right password in server's database
    
    NSString *sendMessage = [[NSString alloc]initWithFormat:@"Login:ID:%@,PWD:%@",userID,password];
    YHSocket *communication = [[YHSocket alloc]initWithIP:SHAREDIP andPortNo:SHAREDPORT];
    NSString *receiveString = [communication receiveStringWithMessage:sendMessage];
    //NSLog(@"Received: %@", receiveString);
    return receiveString;
}


-(int) registerUserID:(NSString *)userID{
    //0:Success
    //1:invalid prefix
    //2:user existed
    //3:Database error
    //4:server error
    NSString *sendMessage = [[NSString alloc]initWithFormat:@"Register:%@",userID];
    YHSocket *communication = [[YHSocket alloc]initWithIP:SHAREDIP andPortNo:SHAREDPORT];
    NSString *receiveString = [communication receiveStringWithMessage:sendMessage];
    //NSLog(@"Received: %@", receiveString);
    if ([receiveString isEqualToString:@"Success"]){
        return 0;
    }
    else if ([receiveString isEqualToString:@"Invalid Prefix"]){
        return 1;
    }
    else if ([receiveString isEqualToString:@"User Existed"]){
        return 2;
    }
    else if ([receiveString isEqualToString:@"Database Error"]){
        return 3;
    }
    else{
        return 4;
    }
}

-(int) registerWithUserID:(NSString *)userID AndPassword:(NSString *)password{
    //0:Success
    //1:invalid prefix
    //2:user existed
    //3:Database error
    //4:server error
    NSString *sendMessage = [[NSString alloc]initWithFormat:@"Register:ID:%@,PWD:%@",userID,password];
    YHSocket *communication = [[YHSocket alloc]initWithIP:SHAREDIP andPortNo:SHAREDPORT];
    NSString *receiveString = [communication receiveStringWithMessage:sendMessage];
    //NSLog(@"Received: %@", receiveString);
    if ([receiveString isEqualToString:@"Success"]){
        return 0;
    }
    else if ([receiveString isEqualToString:@"Invalid Prefix"]){
        return 1;
    }
    else if ([receiveString isEqualToString:@"User Existed"]){
        return 2;
    }
    else if ([receiveString isEqualToString:@"Database Error"]){
        return 3;
    }
    else{
        return 4;
    }
}

-(void)showSingleButtonAlertWithTitle:(NSString *)title andContent:(NSString *)content andButton:(NSString *)buttonTitle withStyle:(NSTextAlignment)alignment{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:1.0];
    paragraphStyle.alignment = alignment;
    paragraphStyle.paragraphSpacingBefore = 20;
    paragraphStyle.paragraphSpacing = 5;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:NSMakeRange(0, [content length])];
    
    [alert setValue:attributedString forKey:@"attributedMessage"];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) showAlertView:(NSString*)title and: (NSString*)message{
    NSMutableParagraphStyle   *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:1.0];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.paragraphSpacingBefore = 20;
    paragraphStyle.paragraphSpacing = 5;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:message];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [message length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, [message length])];
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:NSMakeRange(0, [message length])];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController setValue:attributedString forKey:@"attributedMessage"];
    UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"Close" style: UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction1];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (IBAction)login:(UIButton *)sender
{
    //NSLog(@"%@",@"LOG IN");
    NSString *userID = [_table.idField.text uppercaseString];
    NSString *password =_table.urlField.text;
    YHSocket *communication = [[YHSocket alloc]initWithIP:SHAREDIP andPortNo:SHAREDPORT];
    if (![communication checkConnection]){
        [self showSingleButtonAlertWithTitle:@"Connection Failed" andContent:@"Please check your Internet connection. Sometimes the server is unavailable, please try again later." andButton:@"Try Again" withStyle:NSTextAlignmentJustified];
    }
    else if(userID.length == 0 && password.length == 0){
        [self showSingleButtonAlertWithTitle:@"Empty Fields" andContent:@"Please input your user ID and password to log in." andButton:@"Try Again" withStyle:NSTextAlignmentCenter];
    }
    else if(userID.length == 0){
        [self showSingleButtonAlertWithTitle:@"Empty Field" andContent:@"Please input your user ID and try again." andButton:@"Try Again" withStyle:NSTextAlignmentCenter];
    }
    else if(password.length == 0){
        [self showSingleButtonAlertWithTitle:@"Empty Field" andContent:@"Please input your password and try again." andButton:@"Try Again" withStyle:NSTextAlignmentCenter];
    }
    else{
        [RootEntity rootEntity].server_url = @"https://server.psypad.net.au/";
        [DatabaseManager save];
        //Authenrize
        if ([self validUserIDforLogin:userID]) {
            NSString *loginReceiveString = [self authenrizeUserID:userID WithPassword:password];
            //Success log in
            if ([loginReceiveString isEqualToString:@"Success"]) {
                //Record Recent users
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                if ([ud objectForKey:@"RecentUsers"]) {
                    NSMutableArray *recentUsers = [[NSMutableArray alloc]initWithArray:[ud objectForKey:@"RecentUsers"]];
                    if(![recentUsers containsObject:userID])
                    {
                        if ([recentUsers count] == 2) {
                            [recentUsers removeObjectAtIndex:0];
                            [recentUsers addObject:userID];
                        }else{
                            [recentUsers addObject:userID];
                        }
                        [ud setObject:recentUsers forKey:@"RecentUsers"];
                    }
                }else{
                    NSArray *recentUsers = [[NSArray alloc]initWithObjects:userID, nil];
                    [ud setObject:recentUsers forKey:@"RecentUsers"];
                }
                
                //Record Current Users
                [ud setObject:userID forKey:@"LoginUser"];
                if (![ud objectForKey:userID]) {
                    [ud setObject:[NSDate date] forKey:userID];
                }
                else{
                    NSDate *startDate = [ud objectForKey:userID];
                    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:startDate];
                    int days = ((int)time)/(3600*24);
                    if (days > 14) {
                        [ud setObject:[NSDate date] forKey:userID];
                    }
                }
                [ud synchronize];
                
                //Navigation
                StartPage *sp = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"StartPage"];;
                sp.welcomeString = [[NSString alloc]initWithFormat:@"Welcome %@!",userID.uppercaseString];
                sp.parentVC = self;
                [self.navigationController pushViewController:sp animated:YES];
                //[self.navigationController setViewControllers:@[sp] animated:YES];
            }
            else{//Authenrize failed
                [self showSingleButtonAlertWithTitle:@"Login Failed" andContent:loginReceiveString andButton:@"Try Again" withStyle:NSTextAlignmentCenter];
            }
        }
        else{//Invalid User ID
            [self showSingleButtonAlertWithTitle:@"Invalid User ID" andContent:@"Please check and input a correct user ID. If you are a new user, please use the user ID and password provided by your study coordinator." andButton:@"Try Again" withStyle:NSTextAlignmentJustified];
        }
    }
}




- (IBAction)signup:(UIButton *)sender
{
    //NSLog(@"%@",@"SIGN UP");
    //NSLog(@"%@",_table.urlField.text);
    //NSLog(@"%@",_table.idField.text);
    NSString *userID = _table.idField.text;
    NSString *password =_table.urlField.text;
    if(password.length > 0){
        [RootEntity rootEntity].server_url = @"https://server.psypad.net.au/";
        [DatabaseManager save];
        if (userID.length > 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Input Password Again" message:@"Please input your password again." preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"Password";
                textField.secureTextEntry = YES;
            }];
            [alert addAction:[UIAlertAction actionWithTitle:@"Sign Up" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *reInputPasswordTextField = alert.textFields.firstObject;
                if ([reInputPasswordTextField.text isEqualToString:password]) {
                    int registerResult = [self registerWithUserID:userID AndPassword:password];
                    if (registerResult == 0) {
                        //if ([self registerUserID:userID] == 0) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Successful" message:@"You have successfully signed up. Please remember your password. System will log in for you automatically." preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [self login:nil];
                        }]];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else if (registerResult == 1) {
                        //else if ([self registerUserID:userID] == 1) {//Invalid Prefix
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid User ID" message:@"Your user ID is not in correct format, please check and input again. PS: You need to be an authorised user." preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }]];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else if (registerResult == 2) {
                        //else if ([self registerUserID:userID] == 2) {//user existed
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"User Existed" message:@"If you are new to PsyPad, please try another ID. If you are existed user, please login directly." preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }]];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else if (registerResult == 3) {
                        //else if ([self registerUserID:userID] == 3) {//Databse Error
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Server is being upgraded. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }]];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else{
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unknown Error" message:@"Please check your Internet connection and try again later." preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }]];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }
                else{//Reinput Wrong
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Password Not Match" message:@"Please make sure two passwords you input are the same." preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:true completion:nil];
        }
        else{//Empty User ID
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empty" message:@"Please input your user ID first." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else{//Empty Password
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empty" message:@"Please input a password." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
    
    
}



- (IBAction)tappedVisitWebsite:(UIButton *)sender
{
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.psypad.net.au/"]];
    //Updated 29th Aug
    //Origin: message:@"The University of Melbourne acknowledge funding from the National Health and Medical Research Council (Project Grant App1081874). The content of the published material are solely the responsibility of the administering university and do not reflect the views of NHMRC. "
    NSString *mes = @"The University of Melbourne acknowledges funding from the National Health and Medical Research Council (Project Grant App1081874). The content of the published material are solely the responsibility of the administering university and do not reflect the views of the NHMRC.";
    [self showAlertView:@"" and:mes];
    //UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Funding Information" message:mes delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    
    //[alert show];
}

- (IBAction)unimelbWebsite:(UIButton *)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.unimelb.edu.au"]];
}


- (IBAction)arcWebsite:(UIButton *)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.nhmrc.gov.au"]];
}


+(NSString *)md5DigestWithString:(NSString*)input{
    const char* str = [input UTF8String];
    unsigned char result[16];
    CC_MD5(str, (uint32_t)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:16 * 2];
    for(int i = 0; i<16; i++) {
        [ret appendFormat:@"%02x",(unsigned int)(result[i])];
    }
    return ret;
}


@end
