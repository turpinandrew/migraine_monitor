//
//  SettingSplit.m
//  psypad
//
//  Created by LiuYuHan on 10/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "SettingSplit.h"
#import "SettingRoot.h"
#import "SettingContent.h"
#import "SettingListCtrlDelegate.h"

@interface SettingSplit () <SettingListCtrlDelegate>

@end

@implementation SettingSplit

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationController *settingNav = [self.childViewControllers firstObject];
    SettingRoot * settingRootCtrl = [settingNav.childViewControllers firstObject];
    settingRootCtrl.delegate = self;
    settingRootCtrl.parentVC = [[UINavigationController alloc] initWithRootViewController: _parentVC];
    
    UINavigationController *contentNav = [self.childViewControllers lastObject];
    SettingContent<UISplitViewControllerDelegate> *settingContentCtrl = [contentNav.childViewControllers firstObject];
    self.delegate = settingContentCtrl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)settingListController:(SettingRoot *)ctrl didSelectedSetting:(NSString *)setting{
    UINavigationController *contentNav = [self.childViewControllers lastObject];
    
    SettingContent *settingContentCtrl = [contentNav.childViewControllers firstObject];
    settingContentCtrl.firstPageVC = _firstPageVC;
    settingContentCtrl.settingString = setting;
    [settingContentCtrl reloadData];
    [contentNav popToRootViewControllerAnimated:YES];
    
    //SettingContent *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingContent"];
    //vc.settingString = setting;
    //[contentNav pushViewController:vc animated:YES];
    
    
}

@end
