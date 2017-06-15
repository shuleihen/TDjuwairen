//
//  SurveyContentListController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SurveyContentListController.h"
#import "StockDetailViewController.h"
#import "SurveryStockListCell.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "HexColors.h"
#import "SearchViewController.h"
#import "NSString+Util.h"
#import "MBProgressHUD.h"
#import "SurveyDetailWebViewController.h"
#import "StockUnlockManager.h"
#import "SurveyListTableViewCell.h"
#import "DetailPageViewController.h"

@interface SurveyContentListController ()
<StockManagerDelegate, UITableViewDelegate, UITableViewDataSource,
SurveyStockListCellDelegate, StockUnlockManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *surveyList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *stockArr;
@property (nonatomic, strong) NSDictionary *stockDict;
@property (nonatomic, strong) StockManager *stockManager;
@property (nonatomic, strong) UIView *noDataView;
@property (assign, nonatomic) CGFloat cellHeight;
@property (nonatomic, strong) StockUnlockManager *unlockManager;
@property (nonatomic, assign) BOOL isOptional;
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
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[SurveryStockListCell class] forCellReuseIdentifier:@"SurveryStockListCellID"];
        [_tableView registerClass:[SurveyListTableViewCell class] forCellReuseIdentifier:@"SurveyListTableViewCellID"];
    }
    
    return _tableView;
}

- (UIView *)noDataView {
    if (!_noDataView) {
        CGFloat minHeight = kScreenHeight - 64-160-34-10-50;
        
        _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, minHeight)];
        _noDataView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f8f8f8"];
        
        CGPoint center = CGPointMake(kScreenWidth/2, minHeight/2);
        
        UIImage *image;
        if (self.isOptional) {
            image = [UIImage imageNamed:@"add_specialno.png"];
        } else {
            image = [UIImage imageNamed:@"no_result.png"];
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [btn setImage:image forState:UIControlStateNormal];
        btn.center = CGPointMake(center.x, center.y-image.size.height/2-5);
        [_noDataView addSubview:btn];
        
        if (self.isOptional) {
            [btn addTarget:self action:@selector(addStockPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(center.x, center.y+10);
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        
        if (self.isOptional) {
            label.text = @"还没有增加自选股票~";
        } else {
            label.text = [NSString stringWithFormat:@"还没有%@股票~",self.subjectTitle];
        }
        [_noDataView addSubview:label];
    }
    return _noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f8f8f8"];
    
    self.isOptional = [self.subjectId isEqualToString:kSurveyListOptional];
    if (self.isOptional) {
        self.cellHeight = 118;
    }else {
        self.cellHeight = 97;
    }
    self.tableView.rowHeight = self.cellHeight;
    
    self.unlockManager = [[StockUnlockManager alloc] init];
    self.unlockManager.delegate = self;
    
    self.stockArr = [NSMutableArray array];
    [self refreshData];
}

- (void)addStockPressed:(id)sender {
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.hidesBottomBarWhenPushed = YES;
    [self.rootController.navigationController pushViewController:searchView animated:YES];
}

- (CGFloat)contentHeight {
    CGFloat height = 0.0f;
    height = self.cellHeight*[self.surveyList count];
    return height;
}

- (void)refreshData {
    self.page = 1;
    [self getSurveyWithPage:self.page];
}

- (void)loadMoreData {
    [self getSurveyWithPage:self.page];
}

- (void)getSurveyWithPage:(NSInteger)pageA {
    __weak SurveyContentListController *wself = self;
    
    NSDictionary *dict = @{@"sub_id" : self.subjectId,@"page" : @(pageA)};
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_SurveySubjectList parameters:dict completion:^(id data, NSError *error){
        if (!error) {
            NSArray *dataArray = data;
            
            if (dataArray.count > 0) {
                NSMutableArray *list = nil;
                if (pageA == 1) {
                    list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                } else {
                    list = [NSMutableArray arrayWithArray:wself.surveyList];
                }
                
                for (NSDictionary *d in dataArray) {
                    SurveyListModel *model = [SurveyListModel getInstanceWithDictionary:d];
                    [list addObject:model];
                    [wself.stockArr addObject:model.stockCode];
                    
                }
                wself.surveyList = [NSArray arrayWithArray:list];
                
                if (self.isOptional) {
                    [wself.stockManager addStocks:self.stockArr];
                }
                
                wself.page++;
            } else {
                if (pageA == 1) {
                    wself.surveyList = nil;
                }
            }
        }
        
        [wself reloadTableView];
        
        if (wself.delegate && [self.delegate respondsToSelector:@selector(contentListLoadComplete)]) {
            [wself.delegate contentListLoadComplete];
        }
    }];
}

- (void)reloadTableView {
    [self.tableView reloadData];
    
    if ([self.surveyList count] == 0) {
        [self.view addSubview:self.noDataView];
    } else {
        [self.noDataView removeFromSuperview];
    }
    
    CGFloat height = [self contentHeight];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, height);
}

#pragma mark - StockManagerDelegate
- (void)reloadWithStocks:(NSDictionary *)stocks {
    self.stockDict = stocks;
    [self.tableView reloadData];
}

#pragma mark - StockUnlockManagerDelegate

- (void)unlockManager:(StockUnlockManager *)manager withStockCode:(NSString *)stockCode {
    
    for (SurveyListModel *model in self.surveyList) {
        if ([model.companyCode isEqualToString:stockCode]) {
            model.isUnlocked = YES;
        }
    }
    
    [self.tableView reloadData];
}


#pragma mark - SurveyStockListCellDelegate
- (void)surveyStockListTitlePressedWithSurveyListModel:(SurveyListModel *)model {
    
    if (model.isUnlocked) {
        if (model.surveyType == kSurveyTypeVido) {
            DetailPageViewController *vc = [[DetailPageViewController alloc] init];
            vc.sharp_id = model.surveyId;
            vc.pageMode = @"sharp";
            [self.rootController.navigationController pushViewController:vc animated:YES];
        } else {
            SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
            vc.contentId = model.surveyId;
            vc.stockCode = model.companyCode;
            vc.stockName = model.companyName;
            vc.surveyType = model.surveyType;
            vc.url = [SurveyDetailContentViewController contenWebUrlWithContentId:model.surveyId withTag:model.surveyType];
            vc.hidesBottomBarWhenPushed = YES;
            [self.rootController.navigationController pushViewController:vc animated:YES];
        }
        
    } else {
        if (!US.isLogIn) {
            LoginViewController *login = [[LoginViewController alloc] init];
            login.hidesBottomBarWhenPushed = YES;
            [self.rootController.navigationController pushViewController:login animated:YES];
            return;
        }
        
        [self.unlockManager unlockStock:model.companyCode withStockName:model.companyName withController:self.rootController];
    }

}



- (void)surveyStockListStockNamePressedWithSurveyListModel:(SurveyListModel *)model {
    
    StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
    vc.stockCode = model.companyCode;
    vc.hidesBottomBarWhenPushed = YES;
    [self.rootController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.surveyList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SurveyListModel *survey = self.surveyList[indexPath.section];
    
    if (self.isOptional) {
        SurveyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SurveyListTableViewCellID"];
        cell.delegate = self;
        [cell setupSurvey:survey];
        
        StockInfo *stock = [self.stockDict objectForKey:survey.stockCode];
        [cell setupStock:stock];
        
        return cell;
    } else {
        SurveryStockListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SurveryStockListCellID"];
        cell.delegate = self;
        [cell setupSurvey:survey];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SurveyListModel *survey = self.surveyList[indexPath.section];
    
    StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
    vc.stockCode = survey.companyCode;
    vc.hidesBottomBarWhenPushed = YES;
    [self.rootController.navigationController pushViewController:vc animated:YES];
}


@end
