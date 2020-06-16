//
//  SettingSplit.h
//  psypad
//
//  Created by LiuYuHan on 10/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StartPage;

@interface SettingSplit : UISplitViewController

@property (nonatomic, strong) UIViewController *parentVC;
@property (nonatomic, strong) StartPage *firstPageVC;


@end
