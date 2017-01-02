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
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
#import "SurDetailViewController.h"
#import "NotificationDef.h"
#import "YXTitleButton.h"
#import "SearchViewController.h"
#import "DetailPageViewController.h"
#import "PushMessageViewController.h"
#import "LoginViewController.h"
#import "HexColors.h"
#import "MJRefresh.h"
#import "UIdaynightModel.h"
#import "SurveyDetailViewController.h"
#import "WelcomeView.h"

// 广告栏高度
#define kBannerHeiht 160


@interface SurveyListViewController ()<UITableViewDelegate, UITableViewDataSource, StockManagerDelegate, SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *surveyList;
@property (nonatomic, strong) NSDictionary *stockDict;
@property (nonatomic, strong) StockManager *stockManager;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSArray *bannerLinks;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *stockArr;

@property (nonatomic, strong) UIdaynightModel *daynightModel;

@property (nonatomic, strong) WelcomeView *welcomeView;
@end

@implementation SurveyListViewController

- (StockManager *)stockManager {
    if (!_stockManager) {
        _stockManager = [[StockManager alloc] init];
        _stockManager.delegate = self;
    }
    
    return _stockManager;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kBannerHeiht);
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:self placeholderImage:[UIImage imageNamed:@"bannerPlaceholder"]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    }
    return _cycleScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightModel = [UIdaynightModel sharedInstance];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *daynight = [userdefault objectForKey:@"daynight"];
    if ([daynight isEqualToString:@"yes"]) {
        [self.daynightModel day];
    }
    else
    {
        [self.daynightModel night];
    }
    
    self.stockArr = [NSMutableArray array];
    self.page = 1;
    
    [self setupNavigationBar];
    [self setupTableView];
    
    [self getBanners];
    
    [self getSurveyWithPage:self.page];
    
    [self addRefreshView];
    
    [self requestToLogin];
}

- (void)addRefreshView{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
}

- (void)refreshAction {
    //数据表页数为1
    self.page = 1;
    [self getSurveyWithPage:self.page];
}

- (void)loadMoreAction {
    self.page++;
    //继续请求
    [self getSurveyWithPage:self.page];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.stockManager start];
    
    if (US.isLogIn) {
        UIButton *btn = self.navigationItem.leftBarButtonItem.customView;
        [btn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal];
    }
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
    [avatarBtn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nav_unLoginAvatar.png"]];
    [avatarBtn addTarget:self action:@selector(avatarPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:avatarBtn];
    self.navigationItem.leftBarButtonItem = left;
    
    // 通知
    UIImage *rightImage = [[UIImage imageNamed:@"news_read.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(notificationPressed:)];
    self.navigationItem.rightBarButtonItem = right;
    
    // 搜索
    YXTitleButton *search = [[YXTitleButton alloc] init];
    [search addTarget:self action:@selector(searchPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = search;
}

- (void)setupTableView {
    self.tableView.rowHeight = 125;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.cycleScrollView;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    [self.tableView registerClass:[SurveryStockListCell class] forCellReuseIdentifier:@"SurveryStockListCellID"];
}

#pragma mark - Action 
- (void)updateAvatar:(NSNotification *)notif {
    UIButton *btn = self.navigationItem.leftBarButtonItem.customView;
    [btn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal];
}

- (void)avatarPressed:(id)sender {
    self.tabBarController.selectedIndex = 3;
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

- (void)getBanners {
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *dic = @{@"version":@"2.0"};
    [manager POST:API_GetBanner parameters:dic completion:^(id data, NSError *error) {
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

- (void)getSurveyWithPage:(NSInteger)pageA {
    __weak SurveyListViewController *wself = self;
    
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
                wself.surveyList = [NSMutableArray arrayWithArray:list];
            }
            [self.stockManager addStocks:self.stockArr];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [wself.tableView reloadData];
            
        } else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)pushToSurveyDetailControllerWithRow:(NSInteger)row {
    if (row <0 || row>[self.surveyList count]) {
        return;
    }
    
    SurveyModel *survey = self.surveyList[row];
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
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    //跳转到详情页
    NSString *s = self.bannerLinks[index];
    NSArray *arr = [s componentsSeparatedByString:@"/"];

    if ([arr[0] isEqualToString:@"Survey"]) {
        
        NSString *code = [[arr lastObject] substringWithRange:NSMakeRange(0, 1)];

        NSString *companyCode ;
        if ([code isEqualToString:@"6"]) {
            companyCode = [NSString stringWithFormat:@"sh%@",[arr lastObject]];
        }
        else
        {
            companyCode = [NSString stringWithFormat:@"sz%@",[arr lastObject]];
        }
        
        SurveyDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
        vc.stockId = companyCode;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([arr[0] isEqualToString:@"Sharp"]){
        DetailPageViewController *DetailView = [[DetailPageViewController alloc]init];
        DetailView.sharp_id = [arr lastObject];
        DetailView.pageMode = @"sharp";
        DetailView.hidesBottomBarWhenPushed = YES;
        
        if (US.isLogIn) {     //为登录状态
            NetworkManager *manager = [[NetworkManager alloc] init];
            NSDictionary *dic = @{@"userid":US.userId,
                                  @"module_id":@2,
                                  @"item_id":[arr lastObject]};
            
            [manager POST:API_AddBrowseHistory parameters:dic completion:^(id data, NSError *error){
                if (!error) {
                    
                } else {
                    
                }
            }];
        }
        
        [self.navigationController pushViewController:DetailView animated:YES];
    }
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
    cell.stockNameLabel.textColor = self.daynightModel.textColor;
    cell.surveyTitleLabel.textColor = self.daynightModel.textColor;
    cell.backgroundColor = self.daynightModel.navigationColor;
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
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

#pragma mark - 保持登录
- (void)requestToLogin{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *loginStyle = [user objectForKey:@"loginStyle"];
    NSLog(@"loginStyle is :---%lu",(unsigned long)loginStyle.length);

    if (loginStyle.length > 0) {          //如果有登陆状态
        self.welcomeView = [[WelcomeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [[UIApplication sharedApplication].keyWindow addSubview:self.welcomeView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //删除
            [self.welcomeView removeFromSuperview];
        });
    }
    
    if ([loginStyle isEqualToString:@"QQlogin"]) {
        NSString *openid = [user objectForKey:@"openid"];
        NSDictionary *dic = @{@"openid":openid};
        
        NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
        [manager POST:API_CheckQQLogin parameters:dic completion:^(id data, NSError *error){
            if (!error) {
                NSDictionary *dic = data;
                US.userId=dic[@"user_id"];
                US.userName=dic[@"user_name"];
                US.nickName=dic[@"user_nickname"];
                US.userPhone=dic[@"userinfo_phone"];
                US.headImage=dic[@"userinfo_facesmall"];
                US.company=dic[@"userinfo_company"];
                US.post=dic[@"userinfo_occupation"];
                US.personal=dic[@"userinfo_info"];
                
                US.isLogIn=YES;
                
                UIButton *btn = self.navigationItem.leftBarButtonItem.customView;
                [btn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal];
                NSString *bigface = [US.headImage stringByReplacingOccurrencesOfString:@"_70." withString:@"_200."];
                [self.welcomeView.welHead sd_setImageWithURL:[NSURL URLWithString:bigface]];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                
            }
        }];
    }
    else if ([loginStyle isEqualToString:@"WXlogin"]){
        NSString *unionid = [user objectForKey:@"unionid"];
        NSDictionary *dic = @{@"unionid":unionid};
        
        NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
        [manager POST:API_CheckWeixinLogin parameters:dic completion:^(id data, NSError *error){
            if (!error) {
                NSDictionary *dic = data;
                US.userId=dic[@"user_id"];
                US.userName=dic[@"user_name"];
                US.nickName=dic[@"user_nickname"];
                US.userPhone=dic[@"userinfo_phone"];
                US.headImage=dic[@"userinfo_facesmall"];
                US.company=dic[@"userinfo_company"];
                US.post=dic[@"userinfo_occupation"];
                US.personal=dic[@"userinfo_info"];
                
                US.isLogIn=YES;
                
                UIButton *btn = self.navigationItem.leftBarButtonItem.customView;
                [btn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal];
                NSString *bigface = [US.headImage stringByReplacingOccurrencesOfString:@"_70." withString:@"_200."];
                [self.welcomeView.welHead sd_setImageWithURL:[NSURL URLWithString:bigface]];
                
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                
            }
        }];
    }
    else if([loginStyle isEqualToString:@"normal"])
    {
        NSString *account = [user objectForKey:@"account"];
        NSString *password = [user objectForKey:@"password"];
        if (account != nil ) {
            NetworkManager *manager = [[NetworkManager alloc] init];
            NSDictionary*paras=@{@"account":account,
                                 @"password":password};
            
            [manager POST:API_Login parameters:paras completion:^(id data, NSError *error){
                if (!error) {
                    NSDictionary *dic = data;
                    US.userId=dic[@"user_id"];
                    US.userName=dic[@"user_name"];
                    US.nickName=dic[@"user_nickname"];
                    US.userPhone=dic[@"userinfo_phone"];
                    US.headImage=dic[@"userinfo_facesmall"];
                    US.company=dic[@"userinfo_company"];
                    US.post=dic[@"userinfo_occupation"];
                    US.personal=dic[@"userinfo_info"];
                    
                    US.isLogIn=YES;
                    
                    UIButton *btn = self.navigationItem.leftBarButtonItem.customView;
                    [btn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal];
                    NSString *bigface = [US.headImage stringByReplacingOccurrencesOfString:@"_70." withString:@"_200."];
                    [self.welcomeView.welHead sd_setImageWithURL:[NSURL URLWithString:bigface]];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    
                }
            }];
        }
    }
    
}
@end
