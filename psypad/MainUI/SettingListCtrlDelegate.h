//
//  SettingListCtrlDelegate.h
//  psypad
//
//  Created by LiuYuHan on 10/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SettingRoot;

@protocol SettingListCtrlDelegate <NSObject>

@optional

- (void)settingListController:(SettingRoot *)ctrl didSelectedSetting:(NSString *)setting;

@end
