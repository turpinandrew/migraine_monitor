//
//  Congradulations.h
//  psypad
//
//  Created by LiuYuHan on 9/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestLog;

@interface Congraulations : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *congradulationLabel;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) NSString *congradulationString;
@property (strong, nonatomic) TestLog *log;

@property (nonatomic, strong) NSMutableArray *thresholdData;


@end
