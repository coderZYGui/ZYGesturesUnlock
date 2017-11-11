//
//  ZYLabelView.m
//  ZYGesturesUnlock
//
//  Created by 朝阳 on 2017/11/11.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import "ZYLabelView.h"

@implementation ZYLabelView

- (void)drawRect:(CGRect)rect {
    
    NSString *str = @"请输入手势密码";
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    dictM[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    [str drawAtPoint:CGPointZero withAttributes:dictM];
}

@end
