//
//  ViewController.m
//  PopListViewDemo
//
//  Created by 申露露 on 17/5/22.
//  Copyright © 2017年 申露露. All rights reserved.
//

#import "ViewController.h"
#import "PopListView.h"

@interface ViewController ()<PopListViewDelegate,PopListViewDataSource>
{
    NSArray * array;
    PopListView * ListView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ListView = [[PopListView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    ListView.delegate = self;
    ListView.dataSource = self;
    ListView.TitleName.text = @"选项列表";
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 100, 200, 40);
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showListView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)showListView{
    array = @[@"1",@"2",@"3",@"4",@"5"];
    [ListView.MainPopListView reloadData];
    [ListView show];
}
- (NSInteger)PopListView:(PopListView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}
- (UITableViewCell *)PopListView:(PopListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueResuablePopCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",array[indexPath.row]];
    
    return cell;
}
- (void)PopListView:(PopListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",array[indexPath.row]);
    [self performSelectorOnMainThread:@selector(listDismiss) withObject:nil waitUntilDone:NO];
}
- (void)listDismiss{
    [ListView dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
