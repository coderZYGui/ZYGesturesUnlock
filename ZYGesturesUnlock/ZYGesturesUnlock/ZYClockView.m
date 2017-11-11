//
//  ZYClockView.m
//  ZYGesturesUnlock
//
//  Created by 朝阳 on 2017/11/11.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import "ZYClockView.h"
#import "ZYViewController.h"

@interface ZYClockView()

/** 当前选中的按钮数组 */
@property (nonatomic, strong) NSMutableArray *selectBtnArray;

@property (nonatomic, assign) CGPoint curPoint;

@property (nonatomic, strong) ZYViewController *ZYVC;

@end

@implementation ZYClockView

- (ZYViewController *)ZYVC
{
    if (!_ZYVC) {
        
        _ZYVC = [[ZYViewController alloc] init];
    }
    return _ZYVC;
}

- (NSMutableArray *)selectBtnArray
{
    if (!_selectBtnArray) {
        _selectBtnArray = [NSMutableArray array];
    }
    return _selectBtnArray;
}

/**
 当从xib或storyboard中加载完后调用
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self setUp];
    
    // 沙盒位置
    NSLog(@"%@",NSHomeDirectory());
    
}

/**
 初始化ZYClockView
 */
- (void)setUp
{
    // 创建Button
    for (int i = 0; i < 9; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 因为在下面TouchesBegin:方法中,当点击btn的时候,btn来处理事件,因为这个类是lockView类\
        TouchesBegin:方法只有在这个View内才可以响应.当让这个View上的子控件btn来处理事件时,\
        TouchesBegin: 方法不能响应. 所以应该禁止btn处理事件
        button.userInteractionEnabled = NO;
        
        button.tag = i;
        
        [button setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
        
        [self addSubview:button];
        
    }
}

/**
 布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 取出每个button,设置其frame
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat btnWH = 74;
    
    // 九宫格
    // 总共列
    int column = 3;
    // button之间的间距
    CGFloat margin = (self.bounds.size.width - (btnWH * column)) / (column + 1);
    // 记录当前行号 和 列号
    int curRow  = 0;
    int curCol = 0;
    
    for (int i = 0; i < self.subviews.count; ++i) {
        
        curRow = i / column;
        curCol = i % column;
        
        x = margin + (btnWH + margin) * curCol;
        y = margin + (btnWH + margin) * curRow;
        
        // 取出每一个button
        UIButton *button = self.subviews[i];
        button.frame = CGRectMake(x, y, btnWH, btnWH);
        
    }
}

/**
 获取当前手指的点
 */
- (CGPoint)getCurrentPoint:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}

// 给定一个点,判断点是否在按钮身上
- (UIButton *)btnRectContainsPoint:(CGPoint)point
{
    // 取出所有的按钮
    for (UIButton *button in self.subviews) {
        if (CGRectContainsPoint(button.frame, point)) {
            return button;
        }
    }
    return nil;
}

/**
 开始点击的时候调用
 
 @param touches 不规则的UITouch集合
 @param event 触发的事件
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1. 获取当前手指所在的点
    //    UITouch *touch = [touches anyObject];
    //    CGPoint curPoint = [touch locationInView:self];
    
    CGPoint curPoint = [self getCurrentPoint:touches];
    
    //2. 取出所有的按钮
    //    for (UIButton *button in self.subviews) {
    //        // 判断当前手指所在的点,是否在按钮范围内
    //        // CGRectContainsRect方法: 某一个点是否在某个范围内
    //        //  arg1: 某一范围   arg2: 某一点
    //        if (CGRectContainsPoint(button.frame, curPoint)) {
    //            button.selected = YES;
    //        }
    //    }
    
    // 判断当前手指是否在按钮的frame内,如果在则设置按钮为选中状态
    UIButton *button = [self btnRectContainsPoint:curPoint];
    if (button && button.selected == NO) {
        button.selected = YES;
        // 保存当前选中的按钮
        [self.selectBtnArray addObject:button];
    }
}

/**
 开始移动的时候调用
 */
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1. 获取当前手指所在的点
    CGPoint curPoint = [self getCurrentPoint:touches];
    // 记录当前手指所在的点
    self.curPoint = curPoint;
    
    //2. 取出所有的按钮
    UIButton *button = [self btnRectContainsPoint:curPoint];
    // 只是当前点在button上 和 button不是选中状态下
    if (button && button.selected == NO) {
        button.selected = YES;
        // 保存当前选中的按钮
        [self.selectBtnArray addObject:button];
    }
    // 重绘
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSMutableString *string = [NSMutableString string];
    //1. 取消选中按钮的选中状态
    for (UIButton *button in self.selectBtnArray) {
//        NSLog(@"%ld",button.tag);
        button.selected = NO;
        // 拼接button的索引
        [string appendFormat:@"%ld",button.tag];
    }
    
    //2. 移除绘制路径
    [self.selectBtnArray removeAllObjects];
    [self setNeedsDisplay];
    
    // 查看是否是第一次设置密码
    NSString *keyPwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"keyPwd"];
    if (!keyPwd) {
        // 使用偏好设置保存用户的信息到沙盒Library/Preferences目录中
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"keyPwd"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{
        if ([keyPwd isEqualToString:string]) {
            NSLog(@"密码正确");
//            UIAlertView *alertV =[[UIAlertView alloc] initWithTitle:@"手势输入正确" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertV show];
            
            // 主窗口的根控制器
            UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootVC presentViewController:self.ZYVC animated:YES completion:nil];
            
        }else{
            NSLog(@"密码错误");
            UIAlertView *alertV =[[UIAlertView alloc] initWithTitle:@"手势输入错误,请重试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertV show];
            
        }
    }
    
    //3. 查看当前选中按钮的顺序
    NSLog(@"选中按钮的顺序为:%@",string);
}

/**
 绘制方法
 */
- (void)drawRect:(CGRect)rect
{
    // 当程序一进来就调用drawRect方法,此时self.curPoint还没有值,选中按钮数组中没有值.
    if (self.selectBtnArray.count) {
        //1. 创建路径
        UIBezierPath *path = [UIBezierPath bezierPath];
        //2. 取出所有选中按钮
        for (int i = 0; i < self.selectBtnArray.count; ++i) {
            // 取出选中的button
            UIButton *selectBtn = self.selectBtnArray[i];
            // 如果是第一个按钮,就设置为起点
            if (i == 0) {
                [path moveToPoint:selectBtn.center];
            }else{
                // 连接一根线到btn的中心
                [path addLineToPoint:selectBtn.center];
            }
        }
        
        // 在当前手指所在的点上添加一根线
        [path addLineToPoint:self.curPoint];
        
        // 设置连线的状态
        [path setLineWidth:5];
        [[UIColor blueColor] set];
        [path setLineJoinStyle:kCGLineJoinRound];
        
        //3. 绘制
        [path stroke];
    }
}

@end
