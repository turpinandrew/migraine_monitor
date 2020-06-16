//
//  StartPage.h
//  psypad
//
//  Created by LiuYuHan on 9/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstLogin;

@interface StartPage : UIViewController

@property (nonatomic, strong) FirstLogin *parentVC;

@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) NSString *welcomeString;

@property (strong, nonatomic) NSArray *selected_configurations;

@property (nonatomic, assign) BOOL realTest;
@property (nonatomic, assign) BOOL migraine;

@end
