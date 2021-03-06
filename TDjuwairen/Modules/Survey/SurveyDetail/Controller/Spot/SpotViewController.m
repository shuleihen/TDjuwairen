//
//  SpotViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SpotViewController.h"
#import "SpotTableViewCell.h"
#import "StockSurveyModel.h"
#import "NetworkManager.h"
#import "VideoDetailViewController.h"
#import "StockUnlockManager.h"

@interface SpotViewController ()<UITableViewDelegate, UITableViewDataSource, StockUnlockManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) StockUnlockManager *unlockManager;
@property (nonatomic, strong) NSIndexPath *unlockIndexPath;
@end

@implementation SpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.page = 1;
    
    self.unlockManager = [[StockUnlockManager alloc] init];
    self.unlockManager.delegate = self;
    
    [self reloadData];
}

- (void)reloadData {
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *para = @{@"code": self.stockCode,
                           @"page": @(self.page)};
    
    [ma GET:API_SurveyDetailResearch parameters:para completion:^(id data, NSError *error){
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
        StockSurveyModel *model = [[StockSurveyModel alloc] initWithDict:dic];
        [array addObject:model];
    }
    
    self.items = array;
    [self.tableView reloadData];
    [self showNoDataView:(array.count == 0)];
    
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

- (void)pushControllerWithIndexPath:(NSIndexPath *)indexPath {
    StockSurveyModel *model = self.items[indexPath.row];
    
    if (model.surveyType == kSurveyTypeVido) {
        VideoDetailViewController *vc = [[VideoDetailViewController alloc] initWithVideoId:model.surveyId];
        vc.hidesBottomBarWhenPushed = YES;
        [self.rootController.navigationController pushViewController:vc animated:YES];
    } else {
        SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
        vc.contentId = model.surveyId;
        vc.stockCode = self.stockCode;
        vc.stockName = self.stockName;
        vc.surveyType = model.surveyType;
        vc.url = [SurveyDetailContentViewController contenWebUrlWithContentId:model.surveyId withTag:model.surveyType];
        [self.rootController.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
- (void)unlockManager:(StockUnlockManager *)manager withSurveyId:(NSString *)surveyId {
    for (StockSurveyModel *model in self.items) {
        if ([model.surveyId isEqualToString:surveyId]) {
            model.isUnlock = YES;
            break;
        }
    }
    
    if (self.unlockIndexPath) {
        [self pushControllerWithIndexPath:self.unlockIndexPath];
    }
    
    [self.tableView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(unlocked)]) {
        [self.delegate unlocked];
    }
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpotTableViewCellID"];
    
    StockSurveyModel *model = self.items[indexPath.row];
    [cell setupSpotModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    StockSurveyModel *model = self.items[indexPath.row];
    
    if (model.isUnlock == NO) {
        self.unlockIndexPath = indexPath;
        [self.unlockManager unlockSurvey:model.surveyId withSurveyType:model.surveyType withSureyTitle:model.title withController:self.rootController];
    } else {
        [self pushControllerWithIndexPath:indexPath];
    }
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
        
        UINib *nib = [UINib nibWithNibName:@"SpotTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"SpotTableViewCellID"];
    }
    
    return _tableView;
}
@end
