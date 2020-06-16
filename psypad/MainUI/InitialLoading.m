//
//  InitialLoading.m
//  psypad
//
//  Created by LiuYuHan on 8/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "InitialLoading.h"
#import "FirstLogin.h"
#import "DLSettings.h"
#import "DLDatabaseManager.h"
#import "RootEntity.h"
#import "StartPage.h"
#import "MBProgressHUD.h"
#import "TestConfiguration.h"
#import "WHWeatherView.h"
#import <sys/utsname.h>


@interface InitialLoading ()

@end

@implementation InitialLoading

- (void)viewDidLoad {
    [super viewDidLoad];
    struct utsname systemInfo;
    uname(&systemInfo);
    //NSString* code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",code);
    
    [_activityIndicator setHidden:YES];
    // Do any additional setup after loading the view.
    [self handleLaunch];
    NSLog(@"%@",[RootEntity rootEntity].server_url);
    [[[ServerManager sharedManager] currentUser] loggedInWithEmail:@"12345678@qq.com" authToken:@"KKV1c9mFLdBE46LXYPzi"];//password:12345678
    //NSLog(@"%@",[[ServerManager sharedManager] currentUser].authToken);
    
    //WHWeatherView *weatherView = [[WHWeatherView alloc] init];
    //weatherView.frame = self.view.bounds;
    //[self.view addSubview:weatherView];
    //[weatherView showWeatherAnimationWithType:WHWeatherTypeSun];
}

-(void)viewDidAppear:(BOOL)animated{
    NSArray *testConfigs = [TestConfiguration MR_findAll];
    //NSLog(@"Older Number of Testconfigs: %lu", (unsigned long)[testConfigs count]);
    if ([testConfigs count] == 0){
        [self downloadDefaultConfiguration];
    }else{
        [self loadAndNavigation];
    }
}

-(void)loadAndNavigation{
    /*
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUser"]){
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUser"];
        
        if ([userID isEqualToString:@" "]) {
            FirstLogin *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FirstLogin"];
            [vc.navigationController.navigationBar setHidden:YES];
            [self.navigationController pushViewController:vc animated:NO];
            //[self.navigationController setViewControllers:@[vc] animated:YES];
        }
        else{
            FirstLogin *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FirstLogin"];
            [vc.navigationController.navigationBar setHidden:YES];
            StartPage *sp = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"StartPage"];;
            sp.welcomeString = [[NSString alloc]initWithFormat:@"Welcome %@!",userID.uppercaseString];
            
            [self.navigationController pushViewController:vc animated:NO];
            [self.navigationController pushViewController:sp animated:NO];
            //[self.navigationController setViewControllers:@[vc,sp] animated:YES];
        }
    }
    else{
     */
        FirstLogin *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FirstLogin"];
        [vc.navigationController.navigationBar setHidden:YES];
        [self.navigationController pushViewController:vc animated:YES];
        //[self.navigationController setViewControllers:@[vc] animated:YES];
    //}
}



- (void)handleLaunch
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int currentBuild = [infoDictionary[(NSString*)kCFBundleVersionKey] intValue];
    int oldBuild = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"currentAppVersion"];
    
    //if (currentBuild != oldBuild)
        //[self preDatabaseSetupMigrationFrom:oldBuild to:currentBuild];
    
    //NSLog(@"%@",[DLSettings sharedSettings].databaseManagerClass);
    [[DLSettings sharedSettings].databaseManagerClass setup];
    
    //if (currentBuild != oldBuild)
        //[self postDatabaseSetupMigrationFrom:oldBuild to:currentBuild];
    
    if (oldBuild != currentBuild)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:oldBuild forKey:@"oldAppVersion"];
        [[NSUserDefaults standardUserDefaults] setInteger:currentBuild forKey:@"currentAppVersion"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"oldAppVersion"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadDefaultConfiguration{
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Initializing...";
    
    __weak typeof(self) weakSelf = self;
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSLog(@"\nDeviceName: %@\n",deviceName);
    
    //default
    NSString *tmpConfigID = @"6069";
    NSString *tmpURL = @"/api/configurations/6069?1547978588";
    
    if([deviceName isEqualToString:@"iPad1,1"]){
        //iPad
        tmpConfigID = @"2063";
        tmpURL = @"/api/configurations/2063?1501925749";
        
    }
    else if([deviceName isEqualToString:@"iPad2,1"] || [deviceName isEqualToString:@"iPad2,2"] || [deviceName isEqualToString:@"iPad2,3"] || [deviceName isEqualToString:@"iPad2,4"]){
        //iPad 2
        tmpConfigID = @"2063";
        tmpURL = @"/api/configurations/2063?1501925749";
        
        
    }
    else if([deviceName isEqualToString:@"iPad3,1"] || [deviceName isEqualToString:@"iPad3,2"] || [deviceName isEqualToString:@"iPad3,3"]){
        //iPad (3rd generation)
        tmpConfigID = @"2063";
        tmpURL = @"/api/configurations/2063?1501925749";
        
        
    }
    else if([deviceName isEqualToString:@"iPad3,4"] || [deviceName isEqualToString:@"iPad3,5"] || [deviceName isEqualToString:@"iPad3,6"]){
        //iPad (4th generation)
        tmpConfigID = @"2063";
        tmpURL = @"/api/configurations/2063?1501925749";
        
    }
    else if([deviceName isEqualToString:@"iPad4,1"] || [deviceName isEqualToString:@"iPad4,2"] || [deviceName isEqualToString:@"iPad4,3"]){
        //iPad Air
        tmpConfigID = @"6067";
        tmpURL = @"/api/configurations/6067?1547977465";
        
    }
    else if([deviceName isEqualToString:@"iPad5,3"] || [deviceName isEqualToString:@"iPad5,4"]){
        //iPad Air 2
        //Drifting centre-surround (staircase)_IPadAir2
        tmpConfigID = @"6067";
        tmpURL = @"/api/configurations/6067?1547977465";
    }
    else if ([deviceName isEqualToString:@"iPad6,7"] || [deviceName isEqualToString:@"iPad6,8"]){
        //iPad Pro (12.9-inch)
        //Drifting centre-surround (staircase)_IPadPro_Big
        tmpConfigID = @"6070";
        tmpURL = @"/api/configurations/6070?1549794175";
        
    }
    else if([deviceName isEqualToString:@"iPad6,3"] || [deviceName isEqualToString:@"iPad6,4"]){
        //iPad Pro (9.7-inch)
        
        //Drifting centre-surround (staircase)_IPadPro_9
        tmpConfigID = @"6068";
        tmpURL = @"/api/configurations/6068?1549794236";
        
    }
    else if ([deviceName isEqualToString:@"iPad6,11"] || [deviceName isEqualToString:@"iPad6,12"]){
        //iPad (5th generation)
        
    }
    else if ([deviceName isEqualToString:@"iPad7,1"] || [deviceName isEqualToString:@"iPad7,2"]){
        //iPad Pro (12.9-inch) (2nd generation)
        //tmpConfigID = @"2063";
        //tmpURL = @"/api/configurations/2063?1501925749";
        tmpConfigID = @"6070";
        tmpURL = @"/api/configurations/6070?1549794175";
        
    }
    else if ([deviceName isEqualToString:@"iPad7,3"] || [deviceName isEqualToString:@"iPad7,4"]){
        //iPad Pro (10.5-inch)
        //Drifting centre-surround (staircase)_IPad3
        tmpConfigID = @"6069";
        tmpURL = @"/api/configurations/6069?1547978588";
    }
    else if([deviceName isEqualToString:@"iPad7,5"] || [deviceName isEqualToString:@"iPad7,6"]){
        //iPad (6th generation)
        tmpConfigID = @"6068";
        tmpURL = @"/api/configurations/6068?1549794236";
        
        
    }
    else if([deviceName isEqualToString:@"iPad8,1"] || [deviceName isEqualToString:@"iPad8,2"] || [deviceName isEqualToString:@"iPad8,3"] || [deviceName isEqualToString:@"iPad8,4"]){
        //iPad Pro (11-inch)
        
        
        
    }
    //Starts Mini
    else if([deviceName isEqualToString:@"iPad2,5"] || [deviceName isEqualToString:@"iPad2,6"] || [deviceName isEqualToString:@"iPad2,7"]){
        //iPad Mini
        tmpConfigID = @"6071";
        tmpURL = @"/api/configurations/6071?1549794202";
        
        
    }
    else if([deviceName isEqualToString:@"iPad4,4"] || [deviceName isEqualToString:@"iPad4,5"] || [deviceName isEqualToString:@"iPad4,6"]){
        //iPad Mini2
        
        tmpConfigID = @"6071";
        tmpURL = @"/api/configurations/6071?1549794202";
        
    }
    else if([deviceName isEqualToString:@"iPad4,7"] || [deviceName isEqualToString:@"iPad4,8"] || [deviceName isEqualToString:@"iPad4,9"]){
        //iPad Mini3
        
        tmpConfigID = @"6071";
        tmpURL = @"/api/configurations/6071?1549794202";
        
    }
    else if ([deviceName isEqualToString:@"iPad5,1"] || [deviceName isEqualToString:@"iPad5,2"]){
        //iPad Mini4
        //Drifting centre-surround (staircase)_IPadMini4
        tmpConfigID = @"6071";
        tmpURL = @"/api/configurations/6071?1549794202";
        
    }
    else if([deviceName isEqualToString:@"iPad11,1"] || [deviceName isEqualToString:@"iPad11,2"]){
        //iPad mini (5th generation)
        tmpConfigID = @"6071";
        tmpURL = @"/api/configurations/6071?1549794202";
        
        
    }
    
    else{
        //similator
//        tmpConfigID = @"2063";
//        tmpURL = @"/api/configurations/2063?1501925749";
        tmpConfigID = @"6069";
        tmpURL = @"/api/configurations/6069?1547978588";
    }
    
    //NSString *tmpURL = @"/api/configurations/2063?1501925749";//right one, old one

    NSLog(@"tmpConfigID:%@",tmpConfigID);
    
    [[ServerManager sharedManager] downloadConfiguration:tmpConfigID
                                                   atURL:tmpURL
                                                progress:^(NSString *status, float progress)
     {
         weakSelf.hud.labelText = status;
         weakSelf.hud.progress = progress;
         
     } success:^(TestConfiguration *configuration)
     {
         [weakSelf.hud hide:YES];
         [weakSelf.hud removeFromSuperview];
         
         [self->_activityIndicator setHidden:NO];
         //NSArray *testConfigs = [TestConfiguration MR_findAll];
         //NSLog(@"Newer Number of Testconfigs: %lu", (unsigned long)[testConfigs count]);
         
         
         //Updated 29th Aug
         //Origin: message:@"Initial Setup Successfully. You can Sign-up or Log-in to Do the Tests."
         UIAlertView *aview = [[UIAlertView alloc] initWithTitle:@""
                                     message:@"Initial Setup Successful."
                                    delegate:nil
                           cancelButtonTitle:@"Next"
                                               otherButtonTitles:nil];
         [aview setDelegate:self];
         [aview show];
         
     } failure:^(NSString *error)
     {
         [weakSelf.hud hide:YES];
         [weakSelf.hud removeFromSuperview];
         [self->_activityIndicator setHidden:NO];
         UIAlertView *aview = [[UIAlertView alloc] initWithTitle:@"Failed to Download Default Configuration, Please Check Your Internet Connection and Try Again."
                                     message:error
                                    delegate:nil
                           cancelButtonTitle:@"Try Later"
                                               otherButtonTitles:nil];
         [aview setDelegate:self];
         [aview show];
     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Next"]) {
        //NSLog(@"Running Here");
        [self loadAndNavigation];
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Try Later"]){
        exit(0);
    }
}




- (IBAction)tappedVisitWebsite:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.psypad.net.au/"]];
}

- (IBAction)unimelbWebsite:(UIButton *)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.unimelb.edu.au"]];
}


- (IBAction)arcWebsite:(UIButton *)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.arc.gov.au"]];
}
@end
