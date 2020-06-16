//
//  InitialLoading.h
//  psypad
//
//  Created by LiuYuHan on 8/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface InitialLoading : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) MBProgressHUD *hud;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
