//
//  YHBarButtonItem.m
//  psypad
//
//  Created by LiuYuHan on 3/8/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "YHBarButtonItem.h"
#import "LoginTable.h"


@implementation YHBarButtonItem

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //self.backgroundColor = [UIColor colorWithRed:203.0/255.0 green:220.0/255.0 blue:235.0/255.0 alpha:1.0];
        //self.layer.backgroundColor = [UIColor colorWithRed:203.0/255.0 green:220.0/255.0 blue:235.0/255.0 alpha:1.0].CGColor;
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        _fillColor = [UIColor clearColor];
    }
    return self;
}



-(void)drawRect:(CGRect)rect{
    [_fillColor set];
    //[[UIColor colorWithRed:203.0/255.0 green:220.0/255.0 blue:235.0/255.0 alpha:1.0] set];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(5, 8, rect.size.width - 10, rect.size.height - 16) cornerRadius:10];
    path.lineWidth = 0.0f;
    [path fill];
}


-(void)addText:(NSString *)text WithColor:(UIColor *)color{
    [self changeTextwithNewText:text];
    [self changeColorwithNewColor:color];
    [self drawText];
}


-(void)changeColorwithNewColor:(UIColor *)newColor{
    _fillColor = newColor;
}

-(void)changeTextwithNewText:(NSString *)newText{
    _text = newText;
}

-(void)drawText{
    /*
    for (CALayer *layer in [self.layer sublayers]) {
        [layer removeFromSuperlayer];
    }
     */
    CATextLayer *textLayer = [[CATextLayer alloc]init];
    textLayer.frame = CGRectMake(5, self.frame.size.height/2.0-12.0, self.frame.size.width-10, self.frame.size.height-16);
    
    //textLayer.foregroundColor = [UIColor colorWithRed:72.0/255.0 green:104.0/255.0 blue:135.0/255.0 alpha:1.0].CGColor;
    textLayer.foregroundColor = [[UIColor blackColor] CGColor];
    textLayer.backgroundColor = [[UIColor clearColor] CGColor];
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.font = CGFontCreateWithFontName((CFStringRef)(@"Verdana"));
    //textLayer.font = CGFontCreateWithFontName((CFStringRef)([UIFont systemFontOfSize:0].fontName));
    textLayer.fontSize = 20;
    textLayer.string = _text;
    
    [self.layer addSublayer:textLayer];
    //NSLog(@"Sublayers:%@", [self.layer sublayers]);
}

@end
