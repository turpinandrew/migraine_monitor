//
//  Congratulations.h
//  psypad
//
//  Created by LiuYuHan on 9/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestLog;

@interface Congratulations : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *userIDField;
@property (strong, nonatomic) IBOutlet UILabel *resultField;
@property (strong, nonatomic) IBOutlet UILabel *totalTestField;
@property (strong, nonatomic) IBOutlet UILabel *totalDaysField;
@property (strong, nonatomic) IBOutlet UILabel *daysInRowField;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) TestLog *log;

@property (strong, nonatomic) NSString *userID;

@property (nonatomic, strong) NSMutableArray *thresholdData;
@property (nonatomic, strong) NSArray *backImages;
@property (nonatomic, assign) BOOL realTest;
@property (nonatomic, assign) BOOL migraine;

@end
