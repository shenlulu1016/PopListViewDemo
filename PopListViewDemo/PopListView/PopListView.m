//
//  PopListView.m
//  PopListViewDemo
//
//  Created by 申露露 on 17/5/22.
//  Copyright © 2017年 申露露. All rights reserved.
//

#import "PopListView.h"
#import <objc/runtime.h>

static const CGFloat PopCustomButtonHeight = 40.0f;
static const char * const PopListViewButtonClickForCancel = "PopListViewButtonClickForCancel";
static const char * const PopListViewButtonClickForDone = "PopListViewButtonClickForDone";

@interface PopListView()
//确认按钮
@property (nonatomic, retain) UIButton * DoneButton;
//取消按钮
@property (nonatomic, retain) UIButton * CancelButton;
//没有按钮的时候，才会使用这个
@property (nonatomic, retain) UIControl * ControlForDismiss;
//初始化界面
- (void)initTheInterface;
//动画进入
- (void)animationIn;
//动画消失
- (void)animationOut;
//展示
- (void)show;
//消失
- (void)dismiss;
@end

@implementation PopListView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTheInterface];
    }
    return self;
}
- (void)initTheInterface{
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = YES;
    
    self.TitleName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.TitleName.font = [UIFont systemFontOfSize:17.0f];
    self.TitleName.backgroundColor = [UIColor redColor];
    self.TitleName.textAlignment = NSTextAlignmentCenter;
    self.TitleName.textColor = [UIColor whiteColor];
    CGFloat xWidth = self.bounds.size.width;
    self.TitleName.lineBreakMode = NSLineBreakByTruncatingTail;
    self.TitleName.frame = CGRectMake(0, 0, xWidth, 32.0f);
    [self addSubview:self.TitleName];
    
    CGRect tableFrame = CGRectMake(0, 32.0f, xWidth, self.bounds.size.height - 32.0f);
    self.MainPopListView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.MainPopListView.delegate = self;
    self.MainPopListView.dataSource = self;
    [self addSubview:self.MainPopListView];
}

- (void)refreshTheUserInterface{
    if (self.CancelButton || self.DoneButton) {
        self.MainPopListView.frame = CGRectMake(0, 32.0f, self.MainPopListView.frame.size.width, self.MainPopListView.frame.size.height-PopCustomButtonHeight);
    }
    if (self.DoneButton && self.CancelButton == nil) {
        self.DoneButton.frame = CGRectMake(0, self.bounds.size.height-PopCustomButtonHeight, self.bounds.size.width, PopCustomButtonHeight);
    }else if (self.DoneButton == nil && self.CancelButton){
        self.CancelButton.frame = CGRectMake(0, self.bounds.size.height-PopCustomButtonHeight, self.bounds.size.width, PopCustomButtonHeight);
    }else if (self.DoneButton && self.CancelButton){
        self.DoneButton.frame = CGRectMake(0, self.bounds.size.height-PopCustomButtonHeight, self.bounds.size.width/2.0f, PopCustomButtonHeight);
        self.CancelButton.frame = CGRectMake(self.bounds.size.height/2.0f, self.bounds.size.height-PopCustomButtonHeight, self.bounds.size.width/2.0f, PopCustomButtonHeight);
    }
    if (self.DoneButton == nil && self.CancelButton == nil) {
        if (self.ControlForDismiss == nil) {
            self.ControlForDismiss = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.ControlForDismiss.backgroundColor = [UIColor colorWithRed:16 green:17 blue:21 alpha:0.5];
            [self.ControlForDismiss addTarget:self action:@selector(TouchForDismissSelf:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (NSIndexPath *)indexPathForSelectedRow{
    return [self.MainPopListView indexPathForSelectedRow];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(PopListView:numberOfRowsInSection:)]) {
        return [self.dataSource PopListView:self numberOfRowsInSection:section];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(PopListView:cellForRowAtIndexPath:)]) {
        return [self.dataSource PopListView:self cellForRowAtIndexPath:indexPath];
    }
    return nil;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(PopListView:didSelectRowAtIndexPath:)]) {
        [self.delegate PopListView:self didSelectRowAtIndexPath:indexPath];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(PopListView:didDeselectRowAtIndexPath:)]) {
        [self.delegate PopListView:self didDeselectRowAtIndexPath:indexPath];
    }
}
#pragma mark animation
- (void)animationIn{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
- (void)animationOut{
    [UIView animateWithDuration:0.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.ControlForDismiss) {
                [self.ControlForDismiss removeFromSuperview];
            }
            [self removeFromSuperview];
        }
    }];
}
#pragma mark 展示 or 消失
- (void)show{
    [self.MainPopListView reloadData];
    [self refreshTheUserInterface];
    UIWindow * keywindow = [[UIApplication sharedApplication] keyWindow];
    if (self.ControlForDismiss) {
        [keywindow addSubview:self.ControlForDismiss];
    }
    [keywindow addSubview:self];
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f, keywindow.bounds.size.height/2.0f);
    [self animationIn];
}
- (void)dismiss{
    [self animationOut];
}
#pragma mark 复用
- (id)dequeueResuablePopCellWithIdentifier:(NSString *)identifier{
    return [self.MainPopListView dequeueReusableCellWithIdentifier:identifier];
}
- (UITableViewCell *)popCellForRoeAtIndexPath:(NSIndexPath *)indexPath{
    return [self.MainPopListView cellForRowAtIndexPath:indexPath];
}
#pragma mark 按钮
- (void)setDoneButtonWithTitle:(NSString *)title withBlock:(PopListViewButtonBlock)block{
    if (self.DoneButton == nil) {
        self.DoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.DoneButton setBackgroundImage:[self GetImageWithColor:[UIColor greenColor] andHeight:PopCustomButtonHeight] forState:UIControlStateNormal];
        [self.DoneButton addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.DoneButton];
    }
    [self.DoneButton setTitle:title forState:UIControlStateNormal];
    objc_setAssociatedObject(self.DoneButton, PopListViewButtonClickForDone, [block copy], OBJC_ASSOCIATION_RETAIN);
}
- (void)setCancelButtonWithTitle:(NSString *)title withBlock:(PopListViewButtonBlock)block{
    if (self.CancelButton == nil) {
        self.CancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.CancelButton setBackgroundImage:[self GetImageWithColor:[UIColor greenColor] andHeight:PopCustomButtonHeight] forState:UIControlStateNormal];
        [self.CancelButton addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.CancelButton];
    }
    [self.DoneButton setTitle:title forState:UIControlStateNormal];
    objc_setAssociatedObject(self.CancelButton, PopListViewButtonClickForCancel, [block copy], OBJC_ASSOCIATION_RETAIN);
}
- (void)buttonWasPressed:(id)sender{
    UIButton * button = (UIButton *)sender;
    PopListViewButtonBlock __block block;
    if (button == self.DoneButton) {
        block = objc_getAssociatedObject(sender, PopListViewButtonClickForDone);
    }else{
        block = objc_getAssociatedObject(sender, PopListViewButtonClickForCancel);
    }
}
#pragma mark 根据颜色生成图片
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
- (void)TouchForDismissSelf:(id)sender{
    [self animationOut];
}
@end
