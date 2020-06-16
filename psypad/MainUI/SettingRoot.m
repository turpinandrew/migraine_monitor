//
//  SettingRoot.m
//  psypad
//
//  Created by LiuYuHan on 9/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "SettingRoot.h"
#import "SettingListCtrlDelegate.h"

@interface SettingRoot ()

@end

@implementation SettingRoot

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_sectionTitle = [[NSMutableArray alloc]initWithObjects:@"Basic",@"User",@"Admin", nil];
    _sectionTitle = [[NSMutableArray alloc]initWithObjects:@"Data",@"User", nil];
    //NSMutableArray *section_1 = [[NSMutableArray alloc]initWithObjects:@"Test Configurations",@"Server URL", nil];
    NSMutableArray *section_2 = [[NSMutableArray alloc]initWithObjects:@"Records", nil];
    NSMutableArray *section_3 = [[NSMutableArray alloc]initWithObjects:@"User Info",@"Change Password",@"Log out of Migraine Monitor", nil];
    //_sections = [[NSMutableArray alloc]initWithObjects: section_1,section_2,section_3,nil];
    _sections = [[NSMutableArray alloc]initWithObjects: section_2, section_3,nil];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    //[[[self tableView] cellForRowAtIndexPath:0] setSelected:YES];
}

- (void)viewWillAppear:(BOOL)animated{
}


-(IBAction)backAction:(UIButton *)sender{
    [self.view.window setRootViewController:_parentVC];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_sectionTitle objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    /*
    if (section == [_sectionTitle count] - 1) {
        return 20;
    }
    else
        return 0;
     */
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 2) {
        //Log out of PsyPad
         [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@" " forKey:@"LoginUser"];
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[NSUserDefaults standardUserDefaults] setObject:@"UNSET" forKey:@"Notification"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //UIViewController *vc;
        //vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FirstLogin"];
        //[_parentVC.navigationController setViewControllers:@[vc] animated:YES];
        [_parentVC popToRootViewControllerAnimated:YES];
        [self.view.window setRootViewController:_parentVC];
    }
    else{
        if ([self.delegate respondsToSelector:@selector(settingListController: didSelectedSetting:)]) {
            NSString *setting = [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            //NSLog(@"%@",setting);
            [self.delegate settingListController:self didSelectedSetting:setting];
        }
    }
}

@end
