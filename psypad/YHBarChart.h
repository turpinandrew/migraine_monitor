//
//  YHBarChart.h
//  psypad
//
//  Created by LiuYuHan on 23/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHBarChart : UIView <UIScrollViewDelegate>
{
    CGFloat barWidth;
    CGFloat barSpace;
    CGFloat barTop;
    CGFloat barBottom;
}

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) CALayer *mainLayer;


@property (nonatomic, strong) NSMutableArray *barData;
@property (nonatomic, strong) NSMutableArray *barColor;
@property (nonatomic, strong) NSMutableArray *barText;
@property (nonatomic, strong) NSMutableArray *barInfo;

@property (nonatomic, assign) int maxValue;

-(void)reDraw;

@end
