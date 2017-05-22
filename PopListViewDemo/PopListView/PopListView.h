//
//  PopListView.h
//  PopListViewDemo
//
//  Created by 申露露 on 17/5/22.
//  Copyright © 2017年 申露露. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PopListViewButtonBlock)();

@class PopListView;
@protocol PopListViewDataSource <NSObject>

- (NSInteger)PopListView:(PopListView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)PopListView:(PopListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol PopListViewDelegate <NSObject>

- (void)PopListView:(PopListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)PopListView:(PopListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface PopListView : UIView<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) id<PopListViewDelegate>delegate;
@property (nonatomic, retain) id<PopListViewDataSource>dataSource;
@property (nonatomic, retain) UILabel * TitleName;
//弹出的主要部分
@property (nonatomic, retain) UITableView * MainPopListView;
//展示
- (void)show;
//消失
- (void)dismiss;
//cell复用
- (id)dequeueResuablePopCellWithIdentifier:(NSString *)identifier;
//cell初始化
- (UITableViewCell *)popCellForRoeAtIndexPath:(NSIndexPath *)indexPath;
//设置确认按钮的标题，如果不设置，不显示确认按钮
- (void)setDoneButtonWithTitle:(NSString *)title withBlock:(PopListViewButtonBlock)block;
//设置取消按钮的标题，如果不设置，不显示取消按钮
- (void)setCancelButtonWithTitle:(NSString *)title withBlock:(PopListViewButtonBlock)block;
- (NSIndexPath *)indexPathForSelectedRow;
@end
