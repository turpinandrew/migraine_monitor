//
//  YHBarButtonItem.h
//  psypad
//
//  Created by LiuYuHan on 3/8/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHBarButtonItem : UIView

@property (nonatomic, strong) UIColor *fillColor;

@property (nonatomic, strong) NSString *text;

-(void)addText:(NSString *)text WithColor:(UIColor *)color;

@end
