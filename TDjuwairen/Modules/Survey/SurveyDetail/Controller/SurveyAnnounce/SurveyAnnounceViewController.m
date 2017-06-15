//
//  SurveyAnnounceViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/4/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SurveyAnnounceViewController.h"
#import "StockAnnounceModel.h"
#import "NetworkManager.h"
#import "HotTableViewCell.h"

@interface SurveyAnnounceViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSInteger page;
@end

@implementation SurveyAnnounceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.page = 1;
    
    [self reloadData];
}

- (void)reloadData {
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *para = @{@"code": self.stockCode,
                           @"page": @(self.page)};
    
    [ma GET:API_SurveyDetailAnnounce parameters:para completion:^(id data, NSError *error){
        if (!error && data && [data isKindOfClass:[NSArray class]]) {
            [self reloadTableViewWithData:data];
        } else {
            // 查询失败
            [self reloadTableViewWithData:nil];
        }
    }];
}

- (void)reloadTableViewWithData:(NSArray *)askList {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[askList count]];
    
    for (NSDictionary *dic in askList) {
        StockAnnounceModel *model = [[StockAnnounceModel alloc] initWithDict:dic];
        [array addObject:model];
    }
    
    self.items = array;
    [self.tableView reloadData];
    
    [self calculateTabelViewHeight];
}

- (void)calculateTabelViewHeight {
    CGFloat height = [self.items count] * 90;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, height);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentDetailController:withHeight:)]) {
        [self.delegate contentDetailController:self withHeight:height];
    }
}

- (CGFloat)contentHeight {
    return CGRectGetHeight(self.tableView.bounds);
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotTableViewCellID"];
    
    StockAnnounceModel *model = self.items[indexPath.row];
    [cell setupAnnounceModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StockAnnounceModel *model = self.items[indexPath.row];
    
    SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
    vc.contentId = model.announceId;
    vc.stockCode = self.stockCode;
    vc.stockName = self.stockName;
    vc.surveyType = kSurveyTypeAnnounce;
    vc.url = model.source;
    [self.rootController.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = 90;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorColor = TDSeparatorColor;
        
        UINib *nib = [UINib nibWithNibName:@"HotTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"HotTableViewCellID"];
    }
    
    return _tableView;
}
@end
