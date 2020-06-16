//
//  Congradulations.m
//  psypad
//
//  Created by LiuYuHan on 9/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "Congraulations.h"
#import "TestLog.h"
#import "TestLogItem.h"

@interface Congraulations ()

@end

@implementation Congraulations


- (void)viewDidLoad {
    [super viewDidLoad];
    _doneButton.hidden = YES;
    self.view.backgroundColor =[UIColor colorWithRed:226 green:226 blue:226 alpha:1];
    _congradulationLabel.text = [[NSString alloc]initWithFormat:@"Congratulations! You have %@ days to go.",_congradulationString];
    [self fireworks];
    
    [self calculateThresholds];
    NSLog(@"%@",self.thresholdData);
    /*
     ((22,26,22,28,26,28),(46,30,32,30,32,26))
     */
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(buttonAction) userInfo:nil repeats:NO];
    
    //NSLog(@"%@", self.view.subviews);
    
    
    
    
    
    
}

- (void) buttonAction{
    [_doneButton setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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






-(IBAction)doneAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:^
     {
     }];
}


@end
