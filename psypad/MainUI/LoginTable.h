//
//  LoginTable.h
//  psypad
//
//  Created by LiuYuHan on 8/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTable : UITableViewController <UITextFieldDelegate>

@property (nonatomic, weak) UIViewController *parentVC;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *serverURL;
@property (nonatomic, strong) UITextField *urlField;
@property (nonatomic, strong) UITextField *idField;

@property (nonatomic, strong) UIToolbar *topToolBarView;

-(void)buttonAction:(UIButton *)button;

@end
