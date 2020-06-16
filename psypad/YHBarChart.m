//
//  YHBarChart.m
//  psypad
//
//  Created by LiuYuHan on 23/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "YHBarChart.h"

@implementation YHBarChart

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        barWidth = 40.0;
        barTop = 40.0;
        barBottom = 40.0;
        barSpace = 35.0;
        
        _scrollView = [[UIScrollView alloc]init];
        _mainLayer = [CALayer layer];
        [_scrollView.layer addSublayer:_mainLayer];
        [self addSubview:_scrollView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //[self reDraw];
}

-(void)reDraw{
    for (CALayer *layer in [_mainLayer sublayers]) {
        [layer removeFromSuperlayer];
    }
    [self prepareData];
    if ([_barData count] == 0) {
        //Null
        _scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        _mainLayer.frame = CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height);
        
        CATextLayer *textLayer = [[CATextLayer alloc]init];
        textLayer.frame = CGRectMake((self.frame.size.width-barWidth-barSpace-50)/2.0, self.frame.size.height/2.0, barWidth+barSpace+50, 30);
        textLayer.foregroundColor = [UIColor grayColor].CGColor;
        textLayer.backgroundColor = [[UIColor clearColor] CGColor];
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.contentsScale = [[UIScreen mainScreen] scale];
        textLayer.font = CGFontCreateWithFontName((CFStringRef)([UIFont systemFontOfSize:0].fontName));
        textLayer.fontSize = 24;
        textLayer.string = @"NO DATA";
        [_mainLayer addSublayer:textLayer];
    }
    else{
        _scrollView.contentSize = CGSizeMake((barWidth+barSpace)*(CGFloat)([_barData count]), self.frame.size.height);
        _mainLayer.frame = CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height);
        for (int i = 0; i < [_barData count]; i++) {
            [self showBarAtIndex:i];
        }
    }
    [self drawHorizontalLines];
}

-(void)prepareData{
    _maxValue = 0;
    /*
     _barData = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:24], nil];
     _barColor = [[NSMutableArray alloc]initWithObjects:[UIColor redColor], nil];
     _barInfo = [[NSMutableArray alloc]initWithObjects:@"24", nil];
     _barText = [[NSMutableArray alloc]initWithObjects:@"17/JUL", nil];
     */
    
    //_barData = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:24],[NSNumber numberWithInt:28],[NSNumber numberWithInt:22],[NSNumber numberWithInt:20],[NSNumber numberWithInt:16],[NSNumber numberWithInt:2],[NSNumber numberWithInt:12],[NSNumber numberWithInt:24],[NSNumber numberWithInt:28],[NSNumber numberWithInt:22],[NSNumber numberWithInt:20],[NSNumber numberWithInt:16],[NSNumber numberWithInt:2],[NSNumber numberWithInt:12],[NSNumber numberWithInt:24],[NSNumber numberWithInt:28],[NSNumber numberWithInt:22],[NSNumber numberWithInt:20],[NSNumber numberWithInt:16],[NSNumber numberWithInt:2],[NSNumber numberWithInt:12],[NSNumber numberWithInt:24],[NSNumber numberWithInt:28],[NSNumber numberWithInt:22],[NSNumber numberWithInt:20],[NSNumber numberWithInt:16],[NSNumber numberWithInt:2],[NSNumber numberWithInt:12], nil];
    //_barColor = [[NSMutableArray alloc]initWithObjects:[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor greenColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor greenColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor greenColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor greenColor],[UIColor redColor],[UIColor redColor],[UIColor redColor], nil];
    //_barInfo = [[NSMutableArray alloc]initWithObjects:@"24",@"28",@"22",@"20",@"16",@"2",@"12",@"24",@"28",@"22",@"20",@"16",@"2",@"12",@"24",@"28",@"22",@"20",@"16",@"2",@"12",@"24",@"28",@"22",@"20",@"16",@"2",@"12", nil];
    //_barText = [[NSMutableArray alloc]initWithObjects:@"17/JUL",@"18/JUL",@"19/JUL",@"20/JUL",@"21/JUL",@"22/JUL",@"23/JUL",@"17/JUL",@"18/JUL",@"19/JUL",@"20/JUL",@"21/JUL",@"22/JUL",@"23/JUL",@"17/JUL",@"18/JUL",@"19/JUL",@"20/JUL",@"21/JUL",@"22/JUL",@"23/JUL",@"17/JUL",@"18/JUL",@"19/JUL",@"20/JUL",@"21/JUL",@"22/JUL",@"23/JUL", nil];
    if ([_barData count] > 0) {
        for (NSNumber *num in _barData) {
            int tmpValue = [num intValue];
            if (tmpValue > _maxValue) {
                _maxValue = tmpValue;
            }
        }
        _maxValue += 10;
    }
    if ([_barData count] < 9) {
        barWidth = ((self.frame.size.width - barSpace) / 8.0) - barSpace;
    }
    else if ([_barData count] < 15) {
        barWidth = ((self.frame.size.width - barSpace) / (float)([_barData count])) - barSpace;
    }
    else{
        barWidth = ((self.frame.size.width - barSpace) / 14.0) - barSpace;
    }
}

- (void)showBarAtIndex:(int)index{
    CGFloat posX = barSpace + (CGFloat)(index) * (barWidth + barSpace);
    CGFloat posY = [self dataToHeight:1.0/(float)(_maxValue)*(float)([[_barData objectAtIndex:index] intValue])];
    UIColor *barColor = [_barColor objectAtIndex:index];
    [self drawBarAtPositionX:posX andY:posY withColor:barColor];
    NSString *textString = [[NSString alloc]initWithFormat:@"%d",[[_barInfo objectAtIndex:index] intValue]];
    [self drawBarText:textString AtPositionX:posX - barSpace/2.0 andY:posY - 30.0 withColor:barColor];
    [self drawBarTitle:[_barText objectAtIndex:index] AtPositionX:posX - barSpace/2 andY:_mainLayer.frame.size.height - barBottom + 10.0 withColor:barColor];
}

-(CGFloat) dataToHeight: (float) height{
    CGFloat tmpHeight = (CGFloat)(height) * (_mainLayer.frame.size.height - barBottom - barTop);
    return _mainLayer.frame.size.height - barBottom - tmpHeight;
}

-(void)drawBarAtPositionX:(CGFloat)xPos andY:(CGFloat)yPos withColor: (UIColor *)color{
    CAShapeLayer *barlayer = [CAShapeLayer layer];
    
    CGFloat tmpWidth = barWidth;
    CGFloat tmpHeight = _mainLayer.frame.size.height - barBottom - yPos;
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    [aPath moveToPoint:CGPointMake(xPos + tmpWidth/2.0 , yPos)];
    [aPath addLineToPoint:CGPointMake(xPos + tmpWidth/2.0, yPos + tmpHeight)];
    barlayer.path = aPath.CGPath;
    barlayer.fillColor = [UIColor clearColor].CGColor;
    barlayer.strokeColor = color.CGColor;
    barlayer.lineWidth = barWidth;
    [_mainLayer addSublayer:barlayer];
    
    barlayer.strokeStart = 0.0f;
    barlayer.strokeEnd = 1.0f;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation.duration = 1.0f;
    animation.fromValue = @(1.0f);
    animation.toValue = @(0.0f);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [barlayer addAnimation:animation forKey:@""];
}

-(void)drawBarText:(NSString*)text AtPositionX:(CGFloat)xPos andY:(CGFloat)yPos withColor: (UIColor *)color{
    CATextLayer *textLayer = [[CATextLayer alloc]init];
    textLayer.frame = CGRectMake(xPos, yPos, barWidth+barSpace, 22);
    //textLayer.foregroundColor = color.CGColor;
    textLayer.foregroundColor = [[UIColor colorWithRed:72.0/255.0 green:104.0/255.0 blue:135.0/255.0 alpha:1.0] CGColor];
    textLayer.backgroundColor = [[UIColor clearColor] CGColor];
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.font = CGFontCreateWithFontName((CFStringRef)([UIFont systemFontOfSize:0].fontName));
    textLayer.fontSize = 14;
    textLayer.string = text;
    [_mainLayer addSublayer:textLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 2.0f;
    animation.fromValue = @(0.0f);
    animation.toValue = @(1.0f);
    animation.removedOnCompletion = NO;
    [textLayer addAnimation:animation forKey:@""];
    
}

-(void)drawBarTitle:(NSString*)title AtPositionX:(CGFloat)xPos andY:(CGFloat)yPos withColor: (UIColor *)color{
    CATextLayer *textLayer = [[CATextLayer alloc]init];
    textLayer.frame = CGRectMake(xPos, yPos, barWidth+barSpace, 22);
    textLayer.foregroundColor = [[UIColor blackColor] CGColor];
    textLayer.backgroundColor = [[UIColor clearColor] CGColor];
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.font = CGFontCreateWithFontName((CFStringRef)([UIFont systemFontOfSize:0].fontName));
    textLayer.fontSize = 14;
    textLayer.string = title;
    [_mainLayer addSublayer:textLayer];
}

-(void)drawHorizontalLines{
    [self drawLineWithValue:0.0 andDash:NO];
    [self drawLineWithValue:0.25 andDash:YES];
    [self drawLineWithValue:0.5 andDash:YES];
    [self drawLineWithValue:0.75 andDash:YES];
    [self drawLineWithValue:1.0 andDash:NO];
}

-(void)drawLineWithValue:(float)value andDash:(BOOL)dashed{
    CGFloat xPos = 0.0;
    CGFloat yPos = [self dataToHeight:value];
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(xPos, yPos)];
    if (_scrollView.contentSize.width < self.frame.size.width) {
        [path addLineToPoint:CGPointMake(self.frame.size.width, yPos)];
    }else{
        [path addLineToPoint:CGPointMake(_scrollView.contentSize.width, yPos)];
    }
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = path.CGPath;
    
    if (dashed == YES) {
        lineLayer.lineDashPattern = @[@(4),@(4)];
        lineLayer.lineWidth = 1.0;
    }
    else{
        lineLayer.lineWidth = 2.0;
    }
    lineLayer.strokeColor = [UIColor colorWithRed:0.8039 green:0.8039 blue:0.8039 alpha:1].CGColor;
    [_mainLayer insertSublayer:lineLayer atIndex:0];
}
@end
