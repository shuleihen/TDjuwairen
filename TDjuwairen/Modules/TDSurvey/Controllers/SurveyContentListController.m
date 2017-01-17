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
#import "LoginState.h"
#import "HexColors.h"
#import "SearchViewController.h"

@interface SurveyContentListController ()<StockManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *surveyList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *stockArr;
@property (nonatomic, strong) NSDictionary *stockDict;
@property (nonatomic, strong) StockManager *stockManager;
@property (nonatomic, strong) UIView *noDataView;
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

- (UIView *)noDataView {
    if (!_noDataView) {
        CGFloat minHeight = kScreenHeight - 64-160-34-10-50;
        
        _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, minHeight)];
        _noDataView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f8f8f8"];
        
        CGPoint center = CGPointMake(kScreenWidth/2, minHeight/2);
        
        UIImage *image;
        if ([self.subjectTitle isEqualToString:@"自选"]) {
            image = [UIImage imageNamed:@"no_result.png"];
        } else {
            image = [UIImage imageNamed:@"no_result.png"];
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [btn setImage:image forState:UIControlStateNormal];
        btn.center = CGPointMake(center.x, center.y-image.size.height/2-5);
        [_noDataView addSubview:btn];
        
        if ([self.subjectTitle isEqualToString:@"自选"]) {
            [btn addTarget:self action:@selector(addStockPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(center.x, center.y+10);
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        
        if ([self.subjectTitle isEqualToString:@"自选"]) {
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
    
    self.stockArr = [NSMutableArray array];
    self.page = 1;
    [self getSurveyWithPage:self.page];
}

- (void)addStockPressed:(id)sender {
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.hidesBottomBarWhenPushed = YES;
    [self.rootController.navigationController pushViewController:searchView animated:YES];
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
    [self getSurveyWithPage:self.page];
}

- (void)getSurveyWithPage:(NSInteger)pageA {
    __weak SurveyContentListController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{};
    if (US.isLogIn) {
        dict = @{@"sub_id" : self.tag,@"page" : @(pageA),@"user_id" : US.userId};
    } else {
        dict = @{@"sub_id" : self.tag,@"page" : @(pageA)};
    }
    
    [manager GET:API_SurveySubjectList parameters:dict completion:^(id data, NSError *error){
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
            wself.page++;

            if (wself.delegate && [self.delegate respondsToSelector:@selector(contentListLoadComplete)]) {
                [wself.delegate contentListLoadComplete];
            }
        } else {
            if (wself.delegate && [self.delegate respondsToSelector:@selector(contentListLoadComplete)]) {
                [wself.delegate contentListLoadComplete];
            }
        }
        
        [wself reloadTableView];
        
        CGFloat height = [wself contentHeight];
        wself.tableView.frame = CGRectMake(0, 0, kScreenWidth, height);
    }];
}

- (void)reloadTableView {
    [self.tableView reloadData];
    
    if ([self.surveyList count] == 0) {
        [self.view addSubview:self.noDataView];
    } else {
        [self.noDataView removeFromSuperview];
    }
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
    
    SurveyDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
    vc.stockInfo = stock;
    vc.stockId = survey.companyCode;
    vc.hidesBottomBarWhenPushed = YES;
    [self.rootController.navigationController pushViewController:vc animated:YES];
}


@end
