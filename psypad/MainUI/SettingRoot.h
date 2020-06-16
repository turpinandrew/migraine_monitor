//
//  SettingRoot.h
//  psypad
//
//  Created by LiuYuHan on 9/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SettingListCtrlDelegate;
@interface SettingRoot : UITableViewController

@property (nonatomic, strong) NSMutableArray *sectionTitle;
@property (nonatomic, strong) NSMutableArray *sections;

@property (weak, nonatomic) id<SettingListCtrlDelegate> delegate;

@property (nonatomic, strong) UINavigationController *parentVC;

@end
