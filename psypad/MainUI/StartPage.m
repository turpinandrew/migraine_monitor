//
//  StartPage.m
//  psypad
//
//  Created by LiuYuHan on 9/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "StartPage.h"
#import "SettingSplit.h"
#import "TestViewController.h"
#import "Congratulations.h"
#import "TestConfiguration.h"
#import "WHWeatherView.h"
#import "YHSocket.h"

@interface StartPage ()

@end

@implementation StartPage
@synthesize welcomeString;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    //NSLog(@"%@",self.navigationController.viewControllers);
    
    _welcomeLabel.text = welcomeString;
    // Do any additional setup after loading the view.
    WHWeatherView *weatherView = [[WHWeatherView alloc] init];
    weatherView.frame = self.view.bounds;
    [self.view addSubview:weatherView];
    [self.view sendSubviewToBack:weatherView];
    [weatherView showWeatherAnimationWithType:WHWeatherTypeClound];
    NSArray *testConfigs = [TestConfiguration MR_findAll];
    if ([testConfigs count] > 0) {
        self.selected_configurations = [testConfigs firstObject];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Test"])
    {
        TestViewController *controller = segue.destinationViewController;
        controller.realTest = self.realTest;
        controller.configurations = @[sender];
    }
    else if ([segue.identifier isEqualToString:@"Finish&Congratulation"]) {
        Congratulations *controller = segue.destinationViewController;
        controller.log = sender;
        controller.migraine = _migraine;
        controller.realTest = _realTest;
    }
}


- (IBAction)friendMode:(UIButton *)sender{
    self.realTest = NO;
    [self startTest];
}

- (IBAction)realMode:(UIButton *)sender{
    self.realTest = YES;
    [self startTest];
}

-(void)showSingleButtonAlertWithTitle:(NSString *)title andContent:(NSString *)content andButton:(NSString *)buttonTitle{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)startTest{
    YHSocket *communication = [[YHSocket alloc]initWithIP:SHAREDIP andPortNo:SHAREDPORT];
    if (![communication checkConnection]){
        [self showSingleButtonAlertWithTitle:@"No Internet Connection" andContent:@"This test requires Internet connection. Please check your Internet status and try again later." andButton:@"Try Again"];
    }
    else{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Did you have a migraine in the last 24 hours?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    //NSMutableAttributedString *alertTitle = [[NSMutableAttributedString alloc]initWithString:@"Did you have a migraine in the last 24 hours?"];
    //[alertTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 2)];
    //[alert setValue:alertTitle forKey:@"attributedMessage"];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes, I have" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //NSLog(@"YES");
        self.migraine = YES;
        if (self.selected_configurations) {
            //NSLog(@"%@",self.selected_configurations);
            [self performSegueWithIdentifier:@"Test" sender:self.selected_configurations];
            
            //TestViewController *aTestCtrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TestVC"];
            //aTestCtrl.configurations = self.selected_configurations;
            
        }
        else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"Please choose a configuration first. You can tap PsyPad Configuration and download new configurations or using existed configurations." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No, I haven't" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //NSLog(@"NO");
        self.migraine = NO;
        if (self.selected_configurations) {
            //NSLog(@"%@",self.selected_configurations);
            [self performSegueWithIdentifier:@"Test" sender:self.selected_configurations];
            
            //TestViewController *aTestCtrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TestVC"];
            //aTestCtrl.configurations = self.selected_configurations;
        }
        else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"Please choose a configuration first. You can tap PsyPad Configuration and download new configurations or using existed configurations." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Do the Test Later" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){}];
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    }
}

-(IBAction)configurationButton:(UIButton *)sender{
    SettingSplit *aSplitViewCtrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingSplit"];
    
    aSplitViewCtrl.parentVC = self.view.window.rootViewController;
    //NSLog(@"ROOTVIEWCONTROLLER:       %@",self.view.window.rootViewController);
    
    aSplitViewCtrl.firstPageVC = self;
    
    [self.view.window setRootViewController:aSplitViewCtrl];
}



- (IBAction)tappedVisitWebsite:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PSYPAD_SERVER]];
}

- (IBAction)unimelbWebsite:(UIButton *)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.unimelb.edu.au"]];
}


- (IBAction)arcWebsite:(UIButton *)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.arc.gov.au"]];
}

-(void)getDefaultTestConfiguration{// Raw data of 2063
    
}

@end
