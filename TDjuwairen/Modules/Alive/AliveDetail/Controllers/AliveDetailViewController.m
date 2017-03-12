//
//  AliveDetailViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveDetailViewController.h"

@interface AliveDetailViewController ()
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AliveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播正文";
    [self setUpValue];
    [self setUpUICommon];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.showsVerticalScrollIndicator = NO;
        
    }
    
    return _tableView;
}


- (void)setUpValue {
    
    
}

- (void)setUpUICommon {
    
}





#pragma mark -------------- UITableViewDataSource ---------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return nil;
}

#pragma mark ----------------------------------------------------------



#pragma mark -------------- UITableViewDelegate ---------------------
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//[tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

#pragma mark ----------------------------------------------------------

@end
