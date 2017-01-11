//
//  SurveyContentListController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SurveyContentListController.h"
#import "SurveyDetailViewController.h"
#import "SurveryStockListCell.h"
#import "NetworkManager.h"

@interface SurveyContentListController ()<StockManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *surveyList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *stockArr;
@property (nonatomic, strong) NSDictionary *stockDict;
@property (nonatomic, strong) StockManager *stockManager;

@end

@implementation SurveyContentListController

- (StockManager *)stockManager {
    if (!_stockManager) {
        _stockManager = [[StockManager alloc] init];
        _stockManager.delegate = self;
    }
    
    return _stockManager;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = 114;
        
        [self.tableView registerClass:[SurveryStockListCell class] forCellReuseIdentifier:@"SurveryStockListCellID"];
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    
    self.stockArr = [NSMutableArray array];
    self.page = 1;
    [self getSurveyWithPage:self.page];
}

- (CGFloat)contentHeight {
    CGFloat height = 0.0f;
    
    height = 114*[self.surveyList count];
    return height;
}

- (void)refreshData {
    self.page = 1;
    [self getSurveyWithPage:self.page];
}

- (void)loadMoreData {
    self.page++;
    [self getSurveyWithPage:self.page];
}

- (void)getSurveyWithPage:(NSInteger)pageA {
    __weak SurveyContentListController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@Survey/lists?page=%ld",API_HOST,(long)pageA];
    [manager GET:url parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            NSArray *dataArray = data;
            
            if (dataArray.count > 0) {
                NSMutableArray *list = nil;
                if (wself.page == 1) {
                    list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                } else {
                    list = [NSMutableArray arrayWithArray:wself.surveyList];
                }
                
                for (NSDictionary *d in dataArray) {
                    SurveyModel *model = [SurveyModel getInstanceWithDictionary:d];
                    [list addObject:model];
                    [wself.stockArr addObject:model.companyCode];
                    
                }
                wself.surveyList = [NSArray arrayWithArray:list];
            }
            
            [wself.stockManager addStocks:self.stockArr];
            [wself.tableView reloadData];
            
            if (wself.delegate && [self.delegate respondsToSelector:@selector(contentListLoadComplete)]) {
                [wself.delegate contentListLoadComplete];
            }
        } else {
            if (wself.delegate && [self.delegate respondsToSelector:@selector(contentListLoadComplete)]) {
                [wself.delegate contentListLoadComplete];
            }
        }
        
        CGFloat height = [wself contentHeight];
        wself.tableView.frame = CGRectMake(0, 0, kScreenWidth, height);
    }];
}

#pragma mark - StockManagerDelegate
- (void)reloadWithStocks:(NSDictionary *)stocks {
    self.stockDict = stocks;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.surveyList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SurveryStockListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SurveryStockListCellID"];
    cell.isLeft = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SurveryStockListCell *scell = (SurveryStockListCell *)cell;
    SurveyModel *survey = self.surveyList[indexPath.section];
    [scell setupSurvey:survey];
    
    StockInfo *stock = [self.stockDict objectForKey:survey.companyCode];
    [scell setupStock:stock];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SurveyModel *survey = self.surveyList[indexPath.section];
    StockInfo *stock = [self.stockDict objectForKey:survey.companyCode];
    
    //    SurDetailViewController *vc = [[SurDetailViewController alloc] init];
    //    vc.company_name = survey.companyName;
    //    vc.company_code = survey.companyCode;
    //    vc.survey_cover = survey.surveyCover;
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
    //
    SurveyDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
    vc.stockInfo = stock;
    vc.stockId = survey.companyCode;
    vc.hidesBottomBarWhenPushed = YES;
    [self.rootController.navigationController pushViewController:vc animated:YES];
}


@end
