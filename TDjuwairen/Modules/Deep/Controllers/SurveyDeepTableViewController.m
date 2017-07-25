//
//  SurveyDeepTableViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SurveyDeepTableViewController.h"
#import "SurveyDeepModel.h"
#import "DeepTableViewCell.h"
#import "NetworkManager.h"
#import "SDCycleScrollView.h"
#import "TDAdvertModel.h"
#import "UIImage+Resize.h"
#import "StockDetailViewController.h"
#import "VideoDetailViewController.h"
#import "TDWebViewHandler.h"
#import "MJRefresh.h"
#import "UIViewController+Refresh.h"
#import "TDADHandler.h"
#import "StockUnlockManager.h"

@interface SurveyDeepTableViewController ()
<SDCycleScrollViewDelegate, StockUnlockManagerDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSArray *bannerLinks;
@property (nonatomic, strong) NSArray *surveyList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) StockUnlockManager *unlockManager;
@end

@implementation SurveyDeepTableViewController

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, 160);
        __weak SurveyDeepTableViewController *wself = self;
        
        UIImage *image = [[UIImage imageNamed:@"bannerPlaceholder.png"] resize:CGSizeMake(kScreenWidth, 160)];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:wself placeholderImage:image];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView.pageControlDotSize = CGSizeMake(7, 7);
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
        _cycleScrollView.pageDotColor = [UIColor colorWithWhite:1.0f alpha:0.5];
        _cycleScrollView.titleLabelTextFont = [UIFont systemFontOfSize:12.0f];
        _cycleScrollView.titleLabelTextColor = [UIColor whiteColor];
    }
    return _cycleScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"深度调研";
    
    UINib *nib = [UINib nibWithNibName:@"DeepTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"DeepTableViewCellID"];
    
    self.tableView.rowHeight = 125.0f;
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.tableHeaderView = self.cycleScrollView;
    self.tableView.tableFooterView = [UIView new];
    
    // header 刷新控件
    [self addHeaderRefreshWithScroll:self.tableView action:@selector(refreshAction)];
    
    // footer 刷新控件
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    
    self.unlockManager = [[StockUnlockManager alloc] init];
    
    [self getBanners];
    [self refreshAction];
}


- (void)getBanners {
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    [manager GET:API_IndexDeepBanner parameters:nil completion:^(id data, NSError *error) {
        if (!error) {
            NSArray *banners = data;
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:banners.count];
            NSMutableArray *titles = [NSMutableArray arrayWithCapacity:banners.count];
            NSMutableArray *urls = [NSMutableArray arrayWithCapacity:banners.count];
            for (NSDictionary *dict in banners) {
                TDAdvertModel *model = [[TDAdvertModel alloc] initWithDictionary:dict];
                [array addObject:model];
                [titles addObject:model.adTitle];
                [urls addObject:model.adImageUrl];
            }
            
            self.bannerLinks = array;
            
//            self.cycleScrollView.titlesGroup = titles;
            self.cycleScrollView.imageURLStringsGroup = urls;
        } else {
            
        }
    }];
}

- (void)refreshAction {
    self.page = 1;
    [self getSurveyWithPage:self.page];
}

- (void)loadMoreAction {
    [self getSurveyWithPage:self.page];
}

- (void)getSurveyWithPage:(NSInteger)pageA {
    __weak SurveyDeepTableViewController *wself = self;
    
    UIActivityIndicatorView *hud = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    hud.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    [self.navigationController.view addSubview:hud];
    
    hud.hidesWhenStopped = YES;
    [hud startAnimating];
    
    NSDictionary *dict = @{@"page" : @(pageA)};
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_SurveyGetDeepList parameters:dict completion:^(id data, NSError *error){
        
        [hud stopAnimating];
        
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
                    SurveyDeepModel *model = [[SurveyDeepModel alloc] initWithDict:d];
                    [list addObject:model];
                    
                }
                wself.surveyList = [NSArray arrayWithArray:list];

                
                wself.page++;
            } else {
                if (pageA == 1) {
                    wself.surveyList = nil;
                }
            }
        }
        
        [wself endHeaderRefresh];
        [wself.tableView.mj_footer endRefreshing];
        [wself.tableView reloadData];
    }];
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    //跳转到详情页
    TDAdvertModel *model = self.bannerLinks[index];
    [TDADHandler pushWithAdModel:model inNav:self.navigationController];
}

#pragma mark - StockUnlockManagerDelegate
- (void)unlockManager:(StockUnlockManager *)manager withDeepId:(NSString *)deepId {
    for (SurveyDeepModel *model in self.surveyList) {
        if ([model.surveyId isEqualToString:deepId]) {
            model.isUnlock = YES;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.surveyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeepTableViewCellID"];
    SurveyDeepModel *model = self.surveyList[indexPath.row];
    [cell setupDeepModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SurveyDeepModel *model = self.surveyList[indexPath.row];

    if (!model.isUnlock) {
        [self.unlockManager unlockDeep:model.surveyId withController:self];
    } else {
        
    }
}

@end
