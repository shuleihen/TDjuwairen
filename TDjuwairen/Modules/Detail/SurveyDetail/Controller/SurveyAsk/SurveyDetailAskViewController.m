//
//  SurveyDetailCommentViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/30.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyDetailAskViewController.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "AskModel.h"
#import "AnsModel.h"
#import "AskTableViewCell.h"
#import "AnsTableViewCell.h"
#import "AnsPublishViewController.h"
#import "AskPublishViewController.h"

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
    NSDictionary *para = [self contentParmWithTag:self.tag];
    
    [ma POST:API_SurveyDetail parameters:para completion:^(id data, NSError *error){
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
        AskModel *model = [AskModel getInstanceWithDictionary:dic];
        [array addObject:model];
    }
    
    self.askList = array;
    [self.tableView reloadData];
    
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
        
        CGFloat sectionHeight = 0.0f;
        CGFloat askHeight = [AskTableViewCell heightWithContent:ask.surveyask_content];
        CGFloat ansHeight = 0.0f;
        
        for (AnsModel *ans in ask.ans_list) {
            ansHeight += [AnsTableViewCell heightWithContent:ans.surveyanswer_content isFirst:NO];
        }
        
        if ([ask.ans_list count]) {
            sectionHeight = askHeight + 30 + ansHeight;
        } else {
            sectionHeight = askHeight;
        }
        
        height += sectionHeight;
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
    return [ask.ans_list count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AskModel *ask = self.askList[indexPath.section];
        
        return [AskTableViewCell heightWithContent:ask.surveyask_content];
    } else {
        AskModel *ask = self.askList[indexPath.section];
        AnsModel *ans = ask.ans_list[indexPath.row-1];

        BOOL isFirst = (indexPath.row == 2);
        return [AnsTableViewCell heightWithContent:ans.surveyanswer_content isFirst:isFirst];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AskModel *ask = self.askList[indexPath.section];
        AskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AskCellID"];
        [cell setupAsk:ask];
        
        __weak SurveyDetailAskViewController *wself = self;
        cell.askBlcok = ^{
            [wself askWithIndexPath:indexPath];
        };
        return cell;
    } else {
        AskModel *ask = self.askList[indexPath.section];
        AnsModel *ans = ask.ans_list[indexPath.row-1];
        AnsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnsCellID"];
        [cell setupAns:ans];
        return cell;
    }
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
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        UINib *ask = [UINib nibWithNibName:@"AskTableViewCell" bundle:nil];
        UINib *ans = [UINib nibWithNibName:@"AnsTableViewCell" bundle:nil];
        [_tableView registerNib:ask forCellReuseIdentifier:@"AskCellID"];
        [_tableView registerNib:ans forCellReuseIdentifier:@"AnsCellID"];
    }
    
    return _tableView;
}
@end
