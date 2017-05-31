//
//  AliveAlertOperateViewController.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/31.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveAlertOperateViewController.h"
#import "STPopup.h"

@interface AliveAlertOperateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AliveAlertOperateViewController
- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, 100);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.scrollEnabled = NO;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setSourceArr:(NSArray *)sourceArr {
    
    _sourceArr = sourceArr;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, self.sourceArr.count*45+55);
    [self.tableView reloadData];
}

- (CGFloat)tableViewHeight {
    
    return self.sourceArr.count*45+55;
}


#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OperateCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OperateCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.backgroundColor = [UIColor yellowColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.text = self.sourceArr[indexPath.row];
    cell.textLabel.textColor = TDTitleTextColor;
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(alertSelectedWithIndex: andTitle:)]) {
        [self.delegate alertSelectedWithIndex:indexPath.row andTitle:self.sourceArr[indexPath.row]];
    }
     [self.popupController dismiss];
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    footerV.backgroundColor = [UIColor clearColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 10, kScreenWidth, 45);
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:TDDetailTextColor forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerV addSubview:btn];
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 55;
}

#pragma mark - 按钮点击事件
- (void)cancelButtonClick:(UIButton *)sender {
    
    [self.popupController dismiss];
}


@end
