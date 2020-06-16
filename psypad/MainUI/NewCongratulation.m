//
//  NewCongratulation.m
//  psypad
//
//  Created by LiuYuHan on 7/8/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "NewCongratulation.h"
#import "WHWeatherView.h"


@interface NewCongratulation ()

@end

@implementation NewCongratulation

- (void)viewDidLoad {
    [super viewDidLoad];
    WHWeatherView *weatherView = [[WHWeatherView alloc] init];
    weatherView.frame = self.view.frame;
    
    _mainLayer = [CALayer layer];
    _mainLayer.frame = self.view.frame;
    [self.view.layer addSublayer:_mainLayer];
    
    
    [self.view addSubview:weatherView];
    [self.view sendSubviewToBack:weatherView];
    [weatherView showWeatherAnimationWithType:WHWeatherTypeSun];
    [self setBackgroudImage];
    [self showThanksLabel];
    
    [self drawBarAtPositionX:self.view.frame.size.width+50 WithValue:30 andColor:[UIColor yellowColor] andTime:5.0f];
    
    [self showCompleteLabel];
    
    //NSLog(@"%@", self.view.subviews);
    //NSLog(@"%@", self.view.layer.sublayers);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setBackgroudImage{
    NSArray *backImages = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"con_back1.png"],[UIImage imageNamed:@"con_back2.png"],[UIImage imageNamed:@"con_back3.png"],[UIImage imageNamed:@"con_back4.png"],[UIImage imageNamed:@"con_back5.png"], nil];
    _background = [[UIImageView alloc]initWithFrame:self.view.frame];
    int back_index = arc4random() % (int)([backImages count]);
    _background.image = [backImages objectAtIndex:back_index];
    _background.layer.opacity = 0.2f;
    [self.view addSubview:_background];
    [self.view sendSubviewToBack:_background];
}

-(void)showThanksLabel{
    _thanksLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2 - 50, self.view.frame.size.width, 80)];
    _thanksLabel.text = @"Thank you for completing the test";
    _thanksLabel.font = [UIFont fontWithName:@"Thonburi" size:50];
    _thanksLabel.textAlignment = NSTextAlignmentCenter;
    _thanksLabel.textColor = [UIColor colorWithRed:72.0/255.0 green:104.0/255.0 blue:135.0/255.0 alpha:1.0];
    _thanksLabel.shadowColor = [UIColor grayColor];
    _thanksLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:_thanksLabel];
    
    _thanksLabel.layer.opacity = 0.0f;
    CABasicAnimation *text_animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    text_animation1.duration = 1.5f;
    text_animation1.fromValue = @(0.0f);
    text_animation1.toValue = @(1.0f);
    text_animation1.removedOnCompletion = NO;
    text_animation1.fillMode = kCAFillModeForwards;
    [_thanksLabel.layer addAnimation:text_animation1 forKey:@"thanksLabel1"];
    
    CABasicAnimation *text_animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    text_animation2.beginTime = CACurrentMediaTime()+3.5f;
    text_animation2.duration = 1.0f;
    text_animation2.fromValue = @(1.0f);
    text_animation2.toValue = @(0.0f);
    text_animation2.removedOnCompletion = NO;
    text_animation2.fillMode = kCAFillModeForwards;
    [_thanksLabel.layer addAnimation:text_animation2 forKey:@"thanksLabel2"];
    
}

-(void)showCompleteLabel{
    _completeLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width/2+100, 80)];
    _completeLabel1.text = @"You have already completed";
    _completeLabel1.font = [UIFont fontWithName:@"Thonburi" size:40];
    _completeLabel1.textAlignment = NSTextAlignmentCenter;
    _completeLabel1.textColor = [UIColor colorWithRed:72.0/255.0 green:104.0/255.0 blue:135.0/255.0 alpha:1.0];
    _completeLabel1.shadowColor = [UIColor grayColor];
    _completeLabel1.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:_completeLabel1];
    
    _completeLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 80)];
    _completeLabel2.text = @"                                                   tests in total";
    _completeLabel2.font = [UIFont fontWithName:@"Thonburi" size:40];
    _completeLabel2.textAlignment = NSTextAlignmentCenter;
    _completeLabel2.textColor = [UIColor colorWithRed:72.0/255.0 green:104.0/255.0 blue:135.0/255.0 alpha:1.0];
    _completeLabel2.shadowColor = [UIColor grayColor];
    _completeLabel2.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:_completeLabel2];
    
    
    _completeLabel1.layer.opacity = 0.0f;
    _completeLabel2.layer.opacity = 0.0f;
    
    CABasicAnimation *text_animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    text_animation1.fromValue = @(0.0f);
    text_animation1.toValue = @(1.0f);
    
    CABasicAnimation *text_animation3 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    text_animation3.fromValue = @(_completeLabel1.center.y);
    text_animation3.toValue = @(_completeLabel1.center.y-30.0f);
    
    CAAnimationGroup *text_group1 = [CAAnimationGroup animation];
    text_group1.beginTime = CACurrentMediaTime()+4.3f;
    text_group1.duration = 0.5f;
    text_group1.removedOnCompletion = NO;
    text_group1.fillMode = kCAFillModeForwards;
    text_group1.animations = [[NSArray alloc]initWithObjects:text_animation1,text_animation3, nil];
    [_completeLabel1.layer addAnimation:text_group1 forKey:@"completeText1"];
    
    CABasicAnimation *text_animation4 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    text_animation4.fromValue = @(_completeLabel2.center.y);
    text_animation4.toValue = @(_completeLabel2.center.y-30.0f);
    
    CAAnimationGroup *text_group2 = [CAAnimationGroup animation];
    text_group2.beginTime = CACurrentMediaTime()+5.5f;
    text_group2.duration = 0.5f;
    text_group2.removedOnCompletion = NO;
    text_group2.fillMode = kCAFillModeForwards;
    text_group2.animations = [[NSArray alloc]initWithObjects:text_animation1,text_animation4, nil];
    [_completeLabel2.layer addAnimation:text_group2 forKey:@"completeText2"];
    
}

-(int)getFigureByValue:(int)value{
    int m = 1;
    while(value/10){
        value /= 10;
        ++m;
    }
    return m;
}




-(void)drawBarAtPositionX:(CGFloat)xPos WithValue:(int)value andColor: (UIColor *)color andTime:(float)startTime{
    CAShapeLayer *barlayer = [CAShapeLayer layer];
    
    CGFloat tmpWidth = 40.0f;
    float percent = (float)(value) / (float)(pow(10, [self getFigureByValue:value]));
    CGFloat tmpHeight = (self.view.frame.size.height/2 - 100) * percent;
    
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    [aPath moveToPoint:CGPointMake(xPos + tmpWidth/2.0 , self.view.frame.size.height/2)];
    [aPath addLineToPoint:CGPointMake(xPos + tmpWidth/2.0, self.view.frame.size.height/2 - tmpHeight)];
    barlayer.path = aPath.CGPath;
    barlayer.fillColor = color.CGColor;
    barlayer.strokeColor = color.CGColor;
    barlayer.lineWidth = 40.0f;
    [_mainLayer addSublayer:barlayer];
    
    barlayer.strokeStart = 0.0f;
    barlayer.strokeEnd = 1.0f;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation.beginTime = CACurrentMediaTime()+startTime;
    animation.duration = 1.0f;
    animation.fromValue = @(0.0f);
    animation.toValue = @(1.0f);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [barlayer addAnimation:animation forKey:@"completeBar"];
    
}



@end
