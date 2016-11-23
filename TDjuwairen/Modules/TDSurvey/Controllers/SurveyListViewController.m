//
//  SurveyListViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/10/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyListViewController.h"
#import "SurveryStockListCell.h"
#import "NetworkManager.h"
#import "StockManager.h"
#import "SurveyModel.h"
#import "LoginState.h"
#import "UIButton+WebCache.h"
#import "SDCycleScrollView.h"
#import "SurDetailViewController.h"
#import "NotificationDef.h"
#import "YXTitleButton.h"
#import "SearchViewController.h"
#import "DetailPageViewController.h"
#import "PushMessageViewController.h"
#import "LoginViewController.h"
#import "HexColors.h"

// 广告栏高度
#define kBannerHeiht 160


@interface SurveyListViewController ()<UITableViewDelegate, UITableViewDataSource, StockManagerDelegate, SDCycleScrollViewDelegate>
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *surveyList;
@property (nonatomic, strong) NSDictionary *stockDict;
@property (nonatomic, strong) StockManager *stockManager;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSArray *bannerLinks;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *stockArr;
@end

@implementation SurveyListViewController

//- (UITableView *)tableView {
//    if (!_tableView) {
//        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-114);
//        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.rowHeight = 132;
//        [self.view addSubview:_tableView];
//    }
//    return _tableView;
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (StockManager *)stockManager {
    if (!_stockManager) {
        _stockManager = [[StockManager alloc] init];
        _stockManager.delegate = self;
    }
    
    return _stockManager;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kBannerHeiht);
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:self placeholderImage:[UIImage imageNamed:@"bannerPlaceholder"]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    }
    return _cycleScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stockArr = [NSMutableArray array];
    
    [self setupNavigationBar];
    [self setupTableView];
    
    [self getBanners];
    
    self.page = 1;
<<<<<<< Updated upstream
//    [self getSurveyWithPage:self.page];
=======

    [self getSurveyWithPage:self.page];

>>>>>>> Stashed changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAvatar:) name:kLoginSuccessedNotification object:nil];
    
//    [self defatul];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.stockManager start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.stockManager stop];
}

- (void)setupNavigationBar {
    UIButton *avatarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    avatarBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarBtn.imageView.layer.cornerRadius = 15.0f;
    avatarBtn.imageView.clipsToBounds = YES;
    [avatarBtn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nav_unLoginAvatar"]];
    [avatarBtn addTarget:self action:@selector(avatarPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:avatarBtn];
    self.navigationItem.leftBarButtonItem = left;
    
    // 通知
    UIImage *rightImage = [[UIImage imageNamed:@"news_unread"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(notificationPressed:)];
    self.navigationItem.rightBarButtonItem = right;
    
    // 搜索
    YXTitleButton *search = [[YXTitleButton alloc] init];
    [search addTarget:self action:@selector(searchPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = search;
}

- (void)setupTableView {
    self.tableView.rowHeight = 125;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.cycleScrollView;
    self.tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f0f2f5"];
    [self.tableView registerClass:[SurveryStockListCell class] forCellReuseIdentifier:@"SurveryStockListCellID"];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
}

#pragma mark - Action 
- (void)updateAvatar:(NSNotification *)notif {
    UIButton *btn = self.navigationItem.leftBarButtonItem.customView;
    [btn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal];
}

- (void)avatarPressed:(id)sender {
    
}

- (void)notificationPressed:(id)sender {
    if (US.isLogIn==NO) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    } else {
        PushMessageViewController *messagePush = [[PushMessageViewController alloc]init];
        messagePush.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messagePush animated:YES];
    }
}

- (void)searchPressed:(id)sender {
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchView animated:YES];
}

- (void)refresh:(id)sender {
    [self defatul];
    [self.refreshControl endRefreshing];
}

- (void)getBanners {
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_GetBanner parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            NSArray *dataArr = data;
            NSMutableArray *titles = [NSMutableArray arrayWithCapacity:[data count]];
            NSMutableArray *urls = [NSMutableArray arrayWithCapacity:[data count]];
            NSMutableArray *links = [NSMutableArray arrayWithCapacity:[data count]];
            for (NSDictionary *d in dataArr) {
                [urls addObject:d[@"ad_imgurl"]];
                [titles addObject:d[@"ad_title"]];
                [links addObject:d[@"ad_link"]];
            }
            
            self.bannerLinks = links;
            self.cycleScrollView.titlesGroup = titles;
            self.cycleScrollView.imageURLStringsGroup = urls;
        } else {
            
        }
    }];
}

- (void)defatul {
    /*
     {
     "survey_id": "569",
     "company_code": "sh900904",
     "survey_title": "other test",
     "survey_cover": "http://static.juwairen.net/Pc/Uploads/Images/Survey/200_sc_569_20161122090120.jpg",
     "survey_url": "http://192.168.1.103/Survey/survey_show_header",
     "company_name": "神奇B股(900904)"
     },
     {
     "survey_id": "568",
     "company_code": "sh600646",
     "survey_title": "测试 调研",
     "survey_cover": "http://static.juwairen.net/Pc/Uploads/Images/Survey/200_sc_568_20161122085843.jpg",
     "survey_url": "http://192.168.1.103/Survey/survey_show_header",
     "company_name": "ST国嘉(600646)"
     },
     */
    SurveyModel *one = [[SurveyModel alloc] init];
    one.surveyId = @"569";
    one.companyName = @"神奇B股(900904)";
    one.companyCode = @"sh900904";
    one.surveyTitle = @"other test";
    one.surveyUrl = @"http://192.168.1.103/Survey/survey_show_header";
    one.surveyCover = @"http://static.juwairen.net/Pc/Uploads/Images/Survey/200_sc_569_20161122090120.jpg";
    
    SurveyModel *two = [[SurveyModel alloc] init];
    two.surveyId = @"568";
    two.companyName = @"ST国嘉(600646)";
    two.companyCode = @"sh600646";
    two.surveyTitle = @"测试 调研";
    two.surveyUrl = @"http://192.168.1.103/Survey/survey_show_header";
    two.surveyCover = @"http://static.juwairen.net/Pc/Uploads/Images/Survey/200_sc_568_20161122085843.jpg";
    
    SurveyModel *three = [[SurveyModel alloc] init];
    three.surveyId = @"567";
    three.companyName = @"红宇新材(300345)";
    three.companyCode = @"sz300345";
    three.surveyTitle = @"shidi test";
    three.surveyUrl = @"http://192.168.1.103/Survey/survey_show_header";
    three.surveyCover = @"http://static.juwairen.net/Pc/Uploads/Images/Survey/200_sc_567_20161121144553.jpg";
    
    SurveyModel *four = [[SurveyModel alloc] init];
    four.surveyId = @"566";
    four.companyName = @"宏源证券(000562)";
    four.companyCode = @"sz000562";
    four.surveyTitle = @"tttt";
    four.surveyUrl = @"http://192.168.1.103/Survey/survey_show_header";
    four.surveyCover = @"http://static.juwairen.net/Pc/Uploads/Images/Survey/200_sc_566_20161114141316.jpg";
    
    self.surveyList = [NSMutableArray arrayWithObjects:one,two,three,four, nil];
    [self.tableView reloadData];
    
    [self.stockManager addStocks:@[@"sh900904",@"sh600646",@"sz300345",@"sz000562"]];
}

- (void)getSurveyWithPage:(NSInteger)pageA {
    __weak SurveyListViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSString *url = [NSString stringWithFormat:@"http://192.168.1.107/Survey/lists/%ld",pageA];
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
                    
                }
                
                wself.page ++;
//                wself.surveyList = [NSMutableArray arrayWithArray:[list sortedArrayUsingSelector:@selector(compare:)]];
                wself.surveyList = [NSMutableArray arrayWithArray:list];
            }
            
            [wself.tableView reloadData];
        } else {
            
        }
    }];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    //跳转到详情页
    DetailPageViewController *DetailView = [[DetailPageViewController alloc]init];
    NSString *s = self.bannerLinks[index];
    NSArray *arr = [s componentsSeparatedByString:@"/"];
    DetailView.sharp_id = [arr lastObject];
    DetailView.pageMode = @"sharp";
    DetailView.hidesBottomBarWhenPushed = YES;
    
    if (US.isLogIn) {     //为登录状态
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary *dic = @{@"userid":US.userId,
                              @"module_id":@2,
                              @"item_id":self.bannerLinks[index]};
        
        [manager POST:API_AddBrowseHistory parameters:dic completion:^(id data, NSError *error){
            if (!error) {
                
            } else {
                
            }
        }];
    }
    
    [self.navigationController pushViewController:DetailView animated:YES];
}

#pragma mark - StockManagerDelegate
- (void)reloadWithStocks:(NSDictionary *)stocks {
    self.stockDict = stocks;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.surveyList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SurveryStockListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SurveryStockListCellID"];
    cell.isLeft = indexPath.section%2;
    
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
    SurDetailViewController *vc = [[SurDetailViewController alloc] init];
    vc.company_name = survey.companyName;
    vc.company_code = survey.companyCode;
    vc.survey_cover = survey.surveyCover;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}
@end
