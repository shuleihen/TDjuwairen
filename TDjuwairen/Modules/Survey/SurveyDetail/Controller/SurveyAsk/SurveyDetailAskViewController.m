//
//  SurveyDetailCommentViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/30.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyDetailAskViewController.h"
#import "NetworkManager.h"
#import "LoginStateManager.h"
#import "AskModel.h"
#import "AnsModel.h"
#import "AnsPublishViewController.h"
#import "AskPublishViewController.h"
#import "AskAndAnsTableViewCell.h"

@interface SurveyDetailAskViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *askList;
@end

@implementation SurveyDetailAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    
    [self reloadData];
}

- (void)reloadData {
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *para = @{@"code": self.stockCode};
    
    [ma POST:API_SurveyDetailAsk parameters:para completion:^(id data, NSError *error){
        if (!error && data) {
            [self reloadTableViewWithData:data];
        } else {
            // 查询失败
        }
    }];
}

- (void)reloadTableViewWithData:(NSArray *)askList {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[askList count]];
    
    for (NSDictionary *dic in askList) {
        AskModel *model = [[AskModel alloc] initWithDict:dic];
        [array addObject:model];
    }
    
    self.askList = array;
    [self.tableView reloadData];
    [self showNoDataView:(array.count == 0)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGFloat height = [self calculateTabelViewHeight];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.frame = CGRectMake(0, 0, kScreenWidth, height);
            if (self.delegate && [self.delegate respondsToSelector:@selector(contentDetailController:withHeight:)]) {
                [self.delegate contentDetailController:self withHeight:height];
            }
        });
    });
}

- (CGFloat )calculateTabelViewHeight {
    
    CGFloat height = 0.f;
    for (AskModel *ask in self.askList) {
        height += [AskAndAnsTableViewCell cellHeightWithSurveyAskModel:ask];
    }
    
    return height;
}

- (CGFloat)contentHeight {
    return CGRectGetHeight(self.tableView.bounds);
}

- (void)askWithIndexPath:(NSIndexPath *)indexPath {
    AskModel *ask = self.askList[indexPath.section];
    AnsPublishViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"AnsPublishViewController"];
    vc.ask = ask;
    [self.rootController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.askList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AskModel *ask = self.askList[section];
    return [ask.ansList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AskModel *ask = self.askList[indexPath.section];
    return [AskAndAnsTableViewCell cellHeightWithSurveyAskModel:ask];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AskAndAnsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AskCellID"];
    
    AskModel *ask = self.askList[indexPath.section];
    [cell setupAskModel:ask];
    
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorColor = TDSeparatorColor;
        
        UINib *ask = [UINib nibWithNibName:@"AskAndAnsTableViewCell" bundle:nil];
        [_tableView registerNib:ask forCellReuseIdentifier:@"AskCellID"];
    }
    
    return _tableView;
}
@end
