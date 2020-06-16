//
//  Congradulations.m
//  psypad
//
//  Created by LiuYuHan on 9/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "Congratulations.h"
#import "TestLog.h"
#import "TestLogItem.h"
#import "YHSocket.h"
#import "WHWeatherView.h"

@interface Congratulations ()

@end

@implementation Congratulations


- (void)viewDidLoad {
    [super viewDidLoad];
    //Background Cloud
    /*
    WHWeatherView *weatherView = [[WHWeatherView alloc] init];
    weatherView.frame = self.view.frame;
    [self.view addSubview:weatherView];
    [self.view sendSubviewToBack:weatherView];
    [weatherView showWeatherAnimationWithType:WHWeatherTypeClound];
    */
    
    //Background Image
    //_backImages = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"con_back1.png"],[UIImage imageNamed:@"con_back2.png"],[UIImage imageNamed:@"con_back3.png"],[UIImage imageNamed:@"con_back4.png"],[UIImage imageNamed:@"con_back5.png"], nil];
    //UIImageView * background = [[UIImageView alloc]initWithFrame:self.view.frame];
    //int back_index = arc4random() % (int)([_backImages count]);
    //background.image = [_backImages objectAtIndex:back_index];
    //background.alpha = 0.1f;
    //background.layer.opacity = 0.2f;
    //[self.view addSubview:background];
    //[self.view sendSubviewToBack:background];
    //self.view.backgroundColor =[UIColor colorWithRed:203.0/255.0 green:220.0/255.0 blue:235.0/255.0 alpha:1.0];
    
    //UserID Text
    _userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUser"];
    _userIDField.text = _userID;
    
    //Fireworks
    [self fireworks];
    
    //Result
    [self calculateThresholds];
    _resultField.text = [NSString stringWithFormat:@"%d",[self calculateResult]];
    _resultField.layer.opacity = 0.0f;
    CABasicAnimation *text_animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    text_animation1.beginTime = CACurrentMediaTime();
    text_animation1.duration = 1.0f;
    text_animation1.fromValue = @(0.0f);
    text_animation1.toValue = @(1.0f);
    text_animation1.removedOnCompletion = NO;
    text_animation1.fillMode = kCAFillModeForwards;
    [_resultField.layer addAnimation:text_animation1 forKey:@"resultField"];
    
    
    //Upload Data
    if ([self uploadData]) {
        [self storeData];
    }
    
    //Achievement
    [self setAchievement];
    
    _totalTestField.layer.opacity = 0.0f;
    CABasicAnimation *text_animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    text_animation2.beginTime = CACurrentMediaTime()+0.8f;
    text_animation2.duration = 1.0f;
    text_animation2.fromValue = @(0.0f);
    text_animation2.toValue = @(1.0f);
    text_animation2.removedOnCompletion = NO;
    text_animation2.fillMode = kCAFillModeForwards;
    [_totalTestField.layer addAnimation:text_animation2 forKey:@"resultField"];
    
    _totalDaysField.layer.opacity = 0.0f;
    CABasicAnimation *text_animation3 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    text_animation3.beginTime = CACurrentMediaTime()+1.6f;
    text_animation3.duration = 1.0f;
    text_animation3.fromValue = @(0.0f);
    text_animation3.toValue = @(1.0f);
    text_animation3.removedOnCompletion = NO;
    text_animation3.fillMode = kCAFillModeForwards;
    [_totalDaysField.layer addAnimation:text_animation3 forKey:@"resultField"];
    
    _daysInRowField.layer.opacity = 0.0f;
    CABasicAnimation *text_animation4 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    text_animation4.beginTime = CACurrentMediaTime()+2.4f;
    text_animation4.duration = 1.0f;
    text_animation4.fromValue = @(0.0f);
    text_animation4.toValue = @(1.0f);
    text_animation4.removedOnCompletion = NO;
    text_animation4.fillMode = kCAFillModeForwards;
    [_daysInRowField.layer addAnimation:text_animation4 forKey:@"resultField"];
    
    
    //Done Button
    //[_doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventAllEvents];
    _doneButton.layer.opacity = 0.0f;
    CABasicAnimation *button_animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    button_animation.beginTime = CACurrentMediaTime()+3.5f;
    button_animation.duration = 1.5f;
    button_animation.fromValue = @(0.0f);
    button_animation.toValue = @(1.0f);
    button_animation.removedOnCompletion = NO;
    button_animation.fillMode = kCAFillModeForwards;
    [_doneButton.layer addAnimation:button_animation forKey:@"button"];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(setButtonOpacity) userInfo:nil repeats:NO];
    [_doneButton becomeFirstResponder];
    
    //Notifications
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Notification"]) {
        NSString *tmpSet = [[NSUserDefaults standardUserDefaults] objectForKey:@"Notification"];
        if ([tmpSet isEqualToString:@"UNSET"]) {
            [self setNotifications];
        }
    }else{
        [self setNotifications];
    }
}

-(void)setButtonOpacity{
    _doneButton.layer.opacity = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fireworks {
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    
    fireworksEmitter.backgroundColor =[UIColor redColor].CGColor;
    //[UIColor colorWithRed:226 green:226 blue:226 alpha:1].CGColor;
    
    CGRect viewBounds = self.view.layer.bounds;
    fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
    fireworksEmitter.emitterSize    = CGSizeMake(viewBounds.size.width/2.0, 0.0);
    fireworksEmitter.emitterMode    = kCAEmitterLayerOutline;
    fireworksEmitter.emitterShape   = kCAEmitterLayerLine;
    fireworksEmitter.renderMode     = kCAEmitterLayerAdditive;
    fireworksEmitter.seed = (arc4random()%100)+1;
    
    // Create the rocket
    CAEmitterCell* rocket = [CAEmitterCell emitterCell];
    
    rocket.birthRate        = 1.0;
    rocket.emissionRange    = 0.25 * M_PI;  // some variation in angle
    rocket.velocity         = 380;
    rocket.velocityRange    = 100;
    rocket.yAcceleration    = 75;
    rocket.lifetime         = 1.02; // we cannot set the birthrate < 1.0 for the burst
    
    rocket.contents         = (id) [[UIImage imageNamed:@"DazRing"] CGImage];
    rocket.scale            = 0.2;
    rocket.color            = [[UIColor redColor] CGColor];
    rocket.greenRange       = 1.0;      // different colors
    rocket.redRange         = 1.0;
    rocket.blueRange        = 1.0;
    rocket.spinRange        = M_PI;     // slow spin
    
    // the burst object cannot be seen, but will spawn the sparks
    // we change the color here, since the sparks inherit its value
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    
    burst.birthRate         = 1.0;      // at the end of travel
    burst.velocity          = 0;        //speed 0
    burst.scale             = 2.5;      //size
    burst.redSpeed          =-1.5;      // shifting
    burst.blueSpeed         =+1.5;      // shifting
    burst.greenSpeed        =+1.0;      // shifting
    burst.lifetime          = 0.35;     //lasting time
    
    // the sparks
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate         = 400;
    spark.velocity          = 125;
    spark.emissionRange     = 2* M_PI;  // 360
    spark.yAcceleration     = 75;       // gravity
    spark.lifetime          = 3;
    
    spark.contents          = (id) [[UIImage imageNamed:@"DazStarOutline"] CGImage];
    spark.scaleSpeed        =-0.2;
    spark.greenSpeed        =-0.1;
    spark.redSpeed          = 0.4;
    spark.blueSpeed         =-0.1;
    spark.alphaSpeed        =-0.25;
    spark.spin              = 2* M_PI;
    spark.spinRange         = 2* M_PI;
    
    fireworksEmitter.emitterCells   = [NSArray arrayWithObject:rocket];
    rocket.emitterCells             = [NSArray arrayWithObject:burst];
    burst.emitterCells              = [NSArray arrayWithObject:spark];
    [self.view.layer addSublayer:fireworksEmitter];
    
}

-(void) calculateThresholds{
    self.thresholdData = [NSMutableArray array];
    int i = 0; long count = self.log.logitems.count;
    TestLogItem *item;
    item = [self.log.logitems objectAtIndex:(NSUInteger)i++];
    NSDictionary *config = [NSJSONSerialization JSONObjectWithData:[item.info dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    int num_staircases = [(NSNumber *)[config objectForKey:@"number_of_staircases"] intValue];
    for (int j = 0; j < num_staircases; j++)
    {
        [self.thresholdData addObject:[NSMutableArray array]];
    }
    int level = 0, current_staircase = 0;
    while (i < count)
    {
        while (i < count)
        {
            item = [self.log.logitems objectAtIndex:(NSUInteger)i++];
            
            if ([item.type isEqualToString:@"reversal"])
            {
                NSMutableArray *arr = [self.thresholdData objectAtIndex:(NSUInteger)current_staircase];
                [arr addObject:@(level)];
                continue;
            }
            
            if ([item.type isEqualToString:@"currentStaircase"])
                break;
        }
        
        if ( ! [item.type isEqualToString:@"currentStaircase"])
        {
            break;
        }
        
        current_staircase = item.info.intValue;
        
        while (i < count)
        {
            item = [self.log.logitems objectAtIndex:(NSUInteger)i++];
            
            if ([item.type isEqualToString:@"presented_image"])
                break;
        }
        
        if ( ! [item.type isEqualToString:@"presented_image"])
        {
            break;
        }
        
        NSString *image = [item.info stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *identifier = [[image componentsSeparatedByString:@"/"] objectAtIndex:0];
        level = identifier.intValue;
    }
}

-(int)calculateThreshold1{
    long value1, value2, value3, value4;
    if ([self.thresholdData[0] count] >= 3) {
        value1 = [self.thresholdData[0][2] integerValue];
    }else{
        value1 = 0;
    }
    if ([self.thresholdData[0] count] >= 4) {
        value2 = [self.thresholdData[0][3] integerValue];}
    else{
        value2 = 0;
    }
    if ([self.thresholdData[0] count] >= 5) {
        value3 = [self.thresholdData[0][4] integerValue];}
    else{
        value3 = 0;
    }
    if ([self.thresholdData[0] count] >= 6) {
        value4 = [self.thresholdData[0][5] integerValue];}
    else{
        value4 = 0;
    }
    
    int threshold1 = (int)((float)(value3+value4)/2.0);
    return threshold1;
}

-(int)calculateThreshold2{
    long value5, value6, value7, value8;
    if ([self.thresholdData[1] count] >= 3) {
        value5 = [self.thresholdData[1][2] integerValue];}
    else{
        value5 = 0;
    }
    if ([self.thresholdData[1] count] >= 4) {
        value6 = [self.thresholdData[1][3] integerValue];}
    else{
        value6 = 0;
    }
    if ([self.thresholdData[1] count] >= 5) {
        value7 = [self.thresholdData[1][4] integerValue];}
    else{
        value7 = 0;
    }
    if ([self.thresholdData[1] count] >= 6) {
        value8 = [self.thresholdData[1][5] integerValue];}
    else{
        value8 = 0;
    }
    int threshold2 = (int)((float)(value7+value8)/2.0);
    return threshold2;
}



-(int)calculateResult{
    
    int threshold1 = [self calculateThreshold1];
    int threshold2 = [self calculateThreshold2];
    
    int averageThreshold = (int)((float)(threshold1+threshold2)/2.0);
    return averageThreshold;
}

-(void)setAchievement{
    NSString *sendMessage = [[NSString alloc]initWithFormat:@"AnalyseRecord:%@",_userID];
    YHSocket *communication = [[YHSocket alloc]initWithIP:SHAREDIP andPortNo:SHAREDPORT];
    NSString *receiveString = [communication receiveStringWithMessage:sendMessage];
    //NSLog(@"Received: %@", receiveString);
    NSArray *parts = [receiveString componentsSeparatedByString:@","];
    if ([parts count] == 3) {
        _totalTestField.text = parts[0];
        _totalDaysField.text = parts[1];
        _daysInRowField.text = parts[2];
    }else{
        _totalTestField.text = @"0";
        _totalDaysField.text = @"0";
        _daysInRowField.text = @"0";
    }
}


-(BOOL)uploadData{
    if(_realTest){
        //Upload log
        NSString *sendMessage = [[NSString alloc]initWithFormat:@"Record:%@;%d;%d;%@",_userID,[self calculateThreshold1],[self calculateThreshold2],_migraine?@"YES":@"NO"];
        YHSocket *communication = [[YHSocket alloc]initWithIP:SHAREDIP andPortNo:SHAREDPORT];
        NSString *receiveString = [communication receiveStringWithMessage:sendMessage];
        //NSLog(@"Received: %@", receiveString);
        if (![receiveString isEqualToString:@"Success"]) {
            //NSLog(@"%@",receiveString);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"Error: %@ The data hasn't uploaded to the server successfully, please try again.", receiveString] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *tryAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([self uploadData]) {
                    [self storeData];
                }
            }];
            UIAlertAction *noactionAction = [UIAlertAction actionWithTitle:@"Dismiss This Result" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:tryAction];
            [alert addAction:noactionAction];
            [self presentViewController:alert animated:YES completion:nil];
            return NO;
        }else{
            return YES;
        }
    }
    else{
        return YES;
    }
}

-(BOOL)storeData{
    if(_realTest){
        //Local Log
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MMM"];
        NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
        //NSLog(@"%@",currentDateString);
        
        NSString *aKey = [[NSString alloc]initWithFormat:@"%@Data",_userID];
        NSNumber *thresholdNumber = [NSNumber numberWithInt:[self calculateResult]];
        
        //NSLog(@"%@", thresholdNumber);
        
        NSMutableDictionary *newRecord = [[NSMutableDictionary alloc]init];
        [newRecord setValue:thresholdNumber forKey:@"Threshold"];
        [newRecord setValue:[NSString stringWithFormat:@"%d",[self calculateResult]] forKey:@"Threshold_str"];
        [newRecord setValue:[NSNumber numberWithBool:_migraine] forKey:@"Migraine"];
        [newRecord setValue:currentDateString forKey:@"Date_str"];
        [newRecord setValue:currentDate forKey:@"Date"];
        //NSArray *data = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:averageThreshold],[NSNumber numberWithBool:_migraine], nil];
        //NSLog(@"%@",newRecord);
        
        if ([userdefault objectForKey:aKey]) {
            NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithArray:[userdefault objectForKey:aKey]];
            NSDictionary *lastRecord = [tmpArray lastObject];
            if ([currentDateString isEqualToString:[lastRecord objectForKey:@"Date_str"]]) {
                [tmpArray removeLastObject];
            }
            [tmpArray addObject:newRecord];
            [userdefault setObject:tmpArray forKey:aKey];
            [userdefault synchronize];
        }
        else{
            NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithObjects:newRecord, nil];
            [userdefault setObject:tmpArray forKey:aKey];
            [userdefault synchronize];
        }
    }
    return YES;
}



-(void)addNotificationWithDay:(int)day andBody:(NSString *)body{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:day*86400];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.alertBody = body;
    [[UIApplication sharedApplication]scheduleLocalNotification:notification];
}

-(void)setNotifications{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSArray *bodies1 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Don't forget today's Migraine Monitor! You have finished %@ tests in total.", _totalTestField.text],[NSString stringWithFormat:@"Don't forget today's Migraine Monitor! You have participated in this test for %@ days.", _totalDaysField.text],[NSString stringWithFormat:@"Don't forget today's Migraine Monitor! You have kept it for %@ days in row.", _daysInRowField.text],@"Migraine Monitor is waiting for your daily test. Do it now!", @"One thing you might want to experiment with now is having a Migraine test.",[NSString stringWithFormat:@"Would you like to do a Migraine test now? You are up to %@ days in a row!", _totalDaysField.text],@"It seems like you didn’t have a chance to do your daily test. No worries! Open Migraine Monitor and keep testing now.", nil];
    
    for (int i = 1; i <= [bodies1 count]; i++) {
        [self addNotificationWithDay:i andBody:[bodies1 objectAtIndex:i-1]];
    }
    
    NSArray *bodies2 = [NSArray arrayWithObjects:@"Do you still remember Migraine Monitor? Have a test today!",[NSString stringWithFormat:@"You have participated in this test for %@ days. Don't give up!", _totalDaysField.text], @"Do you still have migraine? Don't forget to do a test in Migraine Monitor!", @"Migraine Monitor is waiting for you to come back.", @"Thanks for joining Migraine Monitor. It's time to come back!", @"It seems like you have ignored me for several days. Would you like to come back and have a test today?", nil];
    
    for (int i = (int)([bodies1 count]) + 1; i < 31; i++) {
        int index = arc4random() % [bodies2 count];
        [self addNotificationWithDay:i andBody:[bodies2 objectAtIndex:index]];
    }
    //[[NSUserDefaults standardUserDefaults] setObject:@"SET" forKey:@"Notification"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
}
/*
- (IBAction)doneAction:(id)sender {
    //NSLog(@"Close Congratulations.");
    [self dismissViewControllerAnimated:YES completion:^
     {
     }];
}
*/

-(IBAction)doneAction:(UIButton *)sender{
    //NSLog(@"Close Congratulations.");
    [self dismissViewControllerAnimated:YES completion:^
     {
     }];
}

@end
