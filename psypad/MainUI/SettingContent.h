//
//  SettingContent.h
//  psypad
//
//  Created by LiuYuHan on 10/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StartPage,YHBarChart;

@interface SettingContent : UITableViewController <UITextFieldDelegate>

-(void) reloadData;

@property (nonatomic, strong) StartPage *firstPageVC;

@property (strong, nonatomic) NSString *settingString;

@property (strong, nonatomic) NSMutableDictionary *settingToSectionTitles;
@property (strong, nonatomic) NSMutableDictionary *settingToSections;

@property (strong, nonatomic) NSMutableArray *sectionTitle;
@property (strong, nonatomic) NSMutableArray *sections;

@property (nonatomic, strong) NSArray *downloadedConfigurations;
@property (nonatomic, strong) NSArray *updatableConfigurations;
@property (nonatomic, strong) NSArray *availableConfigurations;

@property (nonatomic, strong) UITextField *urlField;
@property (nonatomic, strong) UITextField *fileField;
@property (nonatomic, strong) UITextField *pwdOldField;
@property (nonatomic, strong) UITextField *pwdNew1Field;
@property (nonatomic, strong) UITextField *pwdNew2Field;

@property (nonatomic, strong) YHBarChart * barchartView;
@property (strong, nonatomic) NSMutableArray *recordData;

@end
