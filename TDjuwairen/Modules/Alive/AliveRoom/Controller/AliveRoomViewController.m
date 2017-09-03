//
//  AliveRoom2ViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveRoomViewController.h"
#import "AliveRoomMasterModel.h"
#import "AliveRoomLiveViewController.h"
#import "AliveMasterListViewController.h"
#import "AliveRoomHeaderView.h"
#import "HMSegmentedControl.h"
#import "MJRefresh.h"
#import "NetworkManager.h"
#import "UINavigationBar+Awesome.h"
#import "UIImage+Color.h"
#import "MBProgressHUD.h"
#import "DCPathButton.h"
#import "AlivePublishViewController.h"
#import "NotificationDef.h"
#import "AliveRoomPopupViewController.h"
#import "STPopup.h"
#import "AliveRoomNavigationBar.h"
#import "MessageTableViewController.h"
#import "StockPoolListViewController.h"
#import "AliveRoomStockPoolTableViewCell.h"
#import "StockPoolListViewController.h"
#import "StockPoolCommentViewController.h"

#define kAliveHeaderHeight  195
#define kAliveStockPoolHeight 151
#define kAliveSegmentHeight 34

@interface AliveRoomViewController ()<UITableViewDelegate, UITableViewDataSource, UIPageViewControllerDataSource, UIPageViewControllerDelegate, AliveRoomHeaderViewDelegate, AliveRoomLiveContentListDelegate, DCPathButtonDelegate, AliveRoomNavigationBarDelegate>
@property (nonatomic, strong) NSString *masterId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *aliveList;

@property (nonatomic, strong) AliveRoomNavigationBar *roomNavigationBar;
@property (nonatomic, strong) AliveRoomHeaderView *roomHeaderView;
@property (nonatomic, strong) UIScrollView *segmentContentScrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentControl;

@property (nonatomic, strong) NSArray *contentControllers;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) AliveRoomMasterModel *roomMasterModel;

@property (nonatomic, strong) DCPathButton *publishBtn;


@property (copy, nonatomic) NSString *saveGuessRateInfoStr;
@property (copy, nonatomic) NSString *saveLevelInfo;

/// 股票池button
@property (strong, nonatomic) UIButton *stockPoolBtn;
@property (nonatomic, strong) UIButton *messageBoardBtn;

@end

@implementation AliveRoomViewController
- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithMasterId:(NSString *)masterId {
    if (self = [super init]) {
        self.masterId = masterId;
        
        [self queryRoomInfoWithMasterId:masterId];
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.backgroundView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.alwaysBounceVertical = NO;
        
        UINib *nib = [UINib nibWithNibName:@"AliveRoomStockPoolTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"AliveRoomStockPoolTableViewCellID"];
    }
    return _tableView;
}

- (AliveRoomNavigationBar *)roomNavigationBar {
    if (!_roomNavigationBar) {
        _roomNavigationBar = [AliveRoomNavigationBar loadAliveRoomeNavigationBar];
        _roomNavigationBar.delegate = self;
    }
    
    return _roomNavigationBar;
}

- (AliveRoomHeaderView *)roomHeaderView {
    if (!_roomHeaderView) {
        _roomHeaderView = [AliveRoomHeaderView loadAliveRoomeHeaderView];
        _roomHeaderView.delegate = self;
    }
    
    return _roomHeaderView;
}

- (UIScrollView *)segmentContentScrollView {
    if (!_segmentContentScrollView) {
        UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kAliveSegmentHeight)];
        view.backgroundColor = [UIColor whiteColor];
        view.showsHorizontalScrollIndicator = NO;
        
        [view addSubview:self.segmentControl];
        [view addSubview:self.stockPoolBtn];
        self.messageBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.messageBoardBtn.frame = CGRectMake(kScreenWidth-72, kAliveSegmentHeight-31, 50, 31);
        self.messageBoardBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.messageBoardBtn setBackgroundColor:TDThemeColor];
        [self.messageBoardBtn setTitle:@"留言板" forState:UIControlStateNormal];
        [self.messageBoardBtn addTarget:self action:@selector(messageBoardBtnClick) forControlEvents:UIControlEventTouchUpInside];
       
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.messageBoardBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = self.messageBoardBtn.bounds;
        maskLayer.path = maskPath.CGPath;
        self.messageBoardBtn.layer.mask = maskLayer;
        [view addSubview:self.messageBoardBtn];
        
        _segmentContentScrollView = view;
    }
    
    return _segmentContentScrollView;
}

- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc] init];
        _segmentControl.backgroundColor = [UIColor clearColor];
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.titleTextAttributes =@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                               NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#666666"]};
        _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                                        NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#3371e2"]};
        _segmentControl.selectionIndicatorHeight = 3.0f;
        _segmentControl.selectionIndicatorColor = [UIColor hx_colorWithHexRGBAString:@"#3371e2"];
        _segmentControl.sectionTitles = @[@"全部动态",@"推单",@"股票池",@""];
        _segmentControl.frame = CGRectMake(0, 0, 270, kAliveSegmentHeight);
        [_segmentControl addTarget:self action:@selector(segmentPressed:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _segmentControl;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        
        NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                           forKey: UIPageViewControllerOptionSpineLocationKey];
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        
        [self addChildViewController:_pageViewController];
    }
    return _pageViewController;
}

- (NSArray *)contentControllers {
    if (!_contentControllers) {
        AliveRoomLiveViewController *one = [[AliveRoomLiveViewController alloc] init];
        one.masterId = self.masterId;
        one.listType = kAliveRoomListAll;
        one.delegate = self;
        
        AliveRoomLiveViewController *two = [[AliveRoomLiveViewController alloc] init];
        two.masterId = self.masterId;
        two.listType = kAliveRoomListPosts;
        two.delegate = self;
        
        StockPoolCommentViewController *three = [[StockPoolCommentViewController alloc] init];
        three.masterId = self.masterId;
        three.commentType = kCommentPlayStock;
      
        
        _contentControllers = @[one,two,three];
    }
    
    return _contentControllers;
}

- (DCPathButton *)publishBtn {
    if (!_publishBtn) {
        DCPathButton *dcPathButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"alive_publish_normal.png"]
                                                             highlightedImage:[UIImage imageNamed:@"alive_publish_pressed.png"]];
        dcPathButton.delegate = self;
        
        // Configure item buttons
        //
        DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc] initWithTitle:@"推单"
                                                                 backgroundImage:[UIImage imageNamed:@"alive_publish_small.png"]
                                                      backgroundHighlightedImage:[UIImage imageNamed:@"alive_publish_small.png"]];
        
        DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc] initWithTitle:@"话题"
                                                                 backgroundImage:[UIImage imageNamed:@"alive_publish_small.png"]
                                                      backgroundHighlightedImage:[UIImage imageNamed:@"alive_publish_small.png"]];
        
        // Add the item button into the center button
        //
        [dcPathButton addPathItems:@[itemButton_1,
                                     itemButton_2
                                     ]];
        
        dcPathButton.bloomDirection = kDCPathButtonBloomDirectionTopLeft;
        
        // Change the bloom radius, default is 105.0f
        //
        dcPathButton.bloomRadius = 90.0f;
        dcPathButton.bloomAngel = 60.0f;
        
        // Change the DCButton's center
        //
        dcPathButton.dcButtonCenter = CGPointMake(self.view.frame.size.width - 26 - dcPathButton.frame.size.width/2, self.view.bounds.size.height -dcPathButton.frame.size.height/2 - 50);
        
        // Setting the DCButton appearance
        //
        dcPathButton.allowSounds = YES;
        dcPathButton.allowCenterButtonRotation = YES;
        
        dcPathButton.bottomViewColor = [UIColor grayColor];
        
        _publishBtn = dcPathButton;
    }
    
    return _publishBtn;
}

- (UIButton *)stockPoolBtn {
    if (_stockPoolBtn == nil) {
        _stockPoolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stockPoolBtn.frame = CGRectMake(160, 0, 90, kAliveSegmentHeight);
        [_stockPoolBtn addTarget:self action:@selector(stockPoolBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stockPoolBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTableView];
    
    self.currentPage = 1;
    self.segmentControl.selectedSegmentIndex = 0;
    [self segmentPressed:self.segmentControl];
    
    self.roomNavigationBar.frame = CGRectMake(0, 0, kScreenWidth, 64);
    [self.view addSubview:self.roomNavigationBar];
    
    self.publishBtn.hidden = YES;
    [self.view addSubview:self.publishBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publishNotifi:) name:kAlivePublishNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.masterId isEqualToString:US.userId]) {
        self.roomMasterModel.masterNickName = US.nickName;
        self.roomMasterModel.roomInfo = US.personal;
        self.roomMasterModel.city = US.city;
    }
    
    [self.roomHeaderView setupRoomMasterModel:self.roomMasterModel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setupTableView {
    [self.view addSubview:self.tableView];
    
    // 表头
    self.tableView.tableHeaderView = self.roomHeaderView;
    // 表尾
    self.tableView.tableFooterView = self.pageViewController.view;
    
    // 自定义悬浮segment
    self.segmentContentScrollView.frame = CGRectMake(0, kAliveHeaderHeight+kAliveStockPoolHeight, kScreenWidth, kAliveSegmentHeight);
    [self.tableView addSubview:self.segmentContentScrollView];
    
    //添加监听，动态观察tableview的contentOffset的改变
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSexNotifi:) name:kUpdateAliveSexNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCityNotifi:) name:kUpdateAliveCityNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIntroNotifi:) name:kUpdateAliveIntroNotification object:nil];
}

- (void)setRoomMasterModel:(AliveRoomMasterModel *)roomMasterModel {
    _roomMasterModel = roomMasterModel;
    
    [self.roomNavigationBar setupRoomMasterModel:roomMasterModel];
    [self.roomHeaderView setupRoomMasterModel:roomMasterModel];
    
    BOOL isMaster = [roomMasterModel.masterId isEqualToString:US.userId];
    self.publishBtn.hidden = !isMaster;
    
    AliveRoomStockPoolTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell) {
        cell.timeLabel.text = [NSString stringWithFormat:@"最新：%@",roomMasterModel.poolTime];
        cell.descLabel.text = roomMasterModel.poolDesc.length?roomMasterModel.poolDesc:@"他很赖吆~，还没设置股票池简介";
        NSString *subscribe = [NSString stringWithFormat:@"%@人已订阅",roomMasterModel.poolSubscribeNum];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:subscribe attributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#548DF5"],NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]}];
        [attr setAttributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#3F3F3F"],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(subscribe.length -3, 3)];
        cell.subscribeLabel.attributedText = attr;
    }
    
}

- (void)queryRoomInfoWithMasterId:(NSString *)masterId {
    
    if (!masterId.length) {
        return;
    }
    
    __weak AliveRoomViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dict = @{@"master_id" :masterId};
    [manager GET:API_AliveGetRoomInfo parameters:dict completion:^(id data, NSError *error){
        
        if (!error) {
            AliveRoomMasterModel *model = [[AliveRoomMasterModel alloc] initWithDictionary:data];
            [wself setRoomMasterModel:model];
            
        } else {
            
        }
        
    }];
}

#pragma mark - Action
- (void)segmentPressed:(HMSegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    if (index >= self.contentControllers.count-1) {
        return;
    }
    __weak AliveRoomViewController *wself = self;
    AliveRoomLiveViewController *vc = self.contentControllers[index];
    
    [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finish){
        [wself reloadTableView];
    }];
}

- (void)stockPoolBtnClick {
//    if (self.segmentControl.selectedSegmentIndex !=2) {
//        self.segmentControl.selectedSegmentIndex = 2;
//        [self segmentPressed:self.segmentControl];
//    }
    
    StockPoolListViewController *stockPoolVC = [[StockPoolListViewController alloc] init];
    stockPoolVC.userId = self.masterId;
    [self.navigationController pushViewController:stockPoolVC animated:YES];
    
    
}

- (void)messageBoardBtnClick {
    self.segmentControl.selectedSegmentIndex = 3;
    __weak AliveRoomViewController *wself = self;
    AliveRoomLiveViewController *vc = self.contentControllers[2];
    [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finish){
        [wself reloadTableView];
    }];
}

- (void)refreshAction {
    AliveRoomLiveViewController *vc = [self currentContentViewController];
    [vc refreshAction];
}

- (void)refreshSubListAction {
    
}

- (void)loadMoreAction {
    AliveRoomLiveViewController *vc = [self currentContentViewController];
    [vc loadMoreAction];
}

- (AliveRoomLiveViewController *)currentContentViewController {
    NSInteger index = self.segmentControl.selectedSegmentIndex;
    if (index >= 0 && index < [self.contentControllers count]-1) {
        return self.contentControllers[index];
    } else {
        return nil;
    }
}

- (void)reloadTableView {
    CGFloat contentHeight = [[self currentContentViewController] contentHeight];
    CGFloat minHeight = kScreenHeight -kAliveHeaderHeight-kAliveStockPoolHeight-kAliveSegmentHeight;
    CGFloat height = MAX(contentHeight, minHeight);
    self.pageViewController.view.frame = CGRectMake(0, 0, kScreenWidth, height);
    // iOS10以下需要添加以下
    self.tableView.tableFooterView = self.pageViewController.view;
    
    [self.tableView reloadData];
}

#pragma mark - Notifi
- (void)updateSexNotifi:(NSNotification *)notifi {
    NSString *sex = notifi.object;
    if (!sex.length) {
        return;
    }
    
    NSString *sexString;
    if ([sex isEqualToString:@"male"]) {
        sexString = @"男";
    } else if ([sex isEqualToString:@"female"]) {
        sexString = @"女";
    }
    
    self.roomMasterModel.sex = sexString;
    [self.roomHeaderView setupRoomMasterModel:self.roomMasterModel];
}

- (void)updateCityNotifi:(NSNotification *)notifi {
    
    NSString *city = notifi.object;
    if (!city.length) {
        return;
    }
    
    self.roomMasterModel.city = city;
    [self.roomHeaderView setupRoomMasterModel:self.roomMasterModel];
}

- (void)updateIntroNotifi:(NSNotification *)notifi {
    
    NSString *intro = notifi.object;
    if (!intro.length) {
        return;
    }
    
    self.roomMasterModel.roomInfo = intro;
    [self.roomHeaderView setupRoomMasterModel:self.roomMasterModel];
}

- (void)publishNotifi:(NSNotification *)notifi {
    // 先直接刷新列表
    [self refreshAction];
    
}


#pragma mark - DCPathButtonDelegate
- (void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    
    AlivePublishViewController *vc = [[AlivePublishViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.publishType = (itemButtonIndex == 0)?kAlivePublishPosts:kAlivePublishNormal;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - AliveRoomLiveContentListDelegate
- (void)contentListLoadComplete {
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    
    [self reloadTableView];
}

#pragma mark - AliveRoomNavigationBarDelegate

- (void)aliveRoomNavigationBar:(AliveRoomNavigationBar *)navigationBar attenPressed:(id)sender {
    
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    
    if (!self.roomMasterModel) {
        return;
    }
    
    __weak AliveRoomViewController *wself = self;
    
    if (self.roomMasterModel.isAtten) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"取消关注";
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary *dict = @{@"user_id" :self.masterId?:@""};
        [manager POST:API_AliveDelAttention parameters:dict completion:^(id data, NSError *error){
            
            if (!error) {
                hud.label.text = @"取消成功";
                [hud hideAnimated:YES];
                
                wself.roomMasterModel.isAtten = NO;
                
                NSInteger fans = [self.roomMasterModel.fansNum integerValue];
                NSNumber *fansNumber = [NSNumber numberWithInteger:(fans-1)];
                wself.roomMasterModel.fansNum = fansNumber;
                
                [wself.roomNavigationBar setupRoomMasterModel:wself.roomMasterModel];
                [wself.roomHeaderView setupRoomMasterModel:wself.roomMasterModel];
            } else {
                hud.label.text = @"取消失败";
                [hud hideAnimated:YES afterDelay:0.8];
            }
        }];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"添加关注";
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary *dict = @{@"user_id" :self.masterId?:@""};
        [manager POST:API_AliveAddAttention parameters:dict completion:^(id data, NSError *error){
            
            if (!error) {
                hud.label.text = @"关注成功";
                [hud hideAnimated:YES];
                
                wself.roomMasterModel.isAtten = YES;
                
                NSInteger fans = [self.roomMasterModel.fansNum integerValue];
                NSNumber *fansNumber = [NSNumber numberWithInteger:(fans+1)];
                wself.roomMasterModel.fansNum = fansNumber;
                
                [wself.roomNavigationBar setupRoomMasterModel:wself.roomMasterModel];
                [wself.roomHeaderView setupRoomMasterModel:wself.roomMasterModel];
            } else {
                hud.label.text = @"关注失败";
                [hud hideAnimated:YES afterDelay:0.8];
            }
        }];
    }
}

- (void)aliveRoomNavigationBar:(AliveRoomNavigationBar *)navigationBar editPressed:(id)sender {

}

- (void)aliveRoomNavigationBar:(AliveRoomNavigationBar *)navigationBar messagePressed:(id)sender {
    MessageTableViewController *vc = [[MessageTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)aliveRoomNavigationBar:(AliveRoomNavigationBar *)navigationBar backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AliveRoomHeaderViewDelegate
- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView attentionListPressed:(id)sender {
    if (!self.roomMasterModel) {
        return;
    }
    
    AliveMasterListViewController *aliveMasterListVC = [[AliveMasterListViewController alloc] init];
    aliveMasterListVC.listType = kAliveAttentionList;
    aliveMasterListVC.masterId = self.masterId;
    [self.navigationController pushViewController:aliveMasterListVC animated:YES];
}

- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView fansListPressed:(id)sender {
    if (!self.roomMasterModel) {
        return;
    }
    
    AliveMasterListViewController *aliveMasterListVC = [[AliveMasterListViewController alloc] init];
    aliveMasterListVC.listType = kAliveFansList;
    aliveMasterListVC.masterId = self.masterId;
    [self.navigationController pushViewController:aliveMasterListVC animated:YES];
}


- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView levelPressed:(id)sender {
    
    if (self.saveLevelInfo.length <= 0) {
        
        [self loadGuessRateInfoOrAttentionInfo:NO];
    }else {
        [self showGuessRateInfoOrShowAttentionInfo:NO];
    }
}

- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView guestRulePressed:(id)sender {
    if (self.saveGuessRateInfoStr.length <= 0) {
        
        [self loadGuessRateInfoOrAttentionInfo:YES];
    }else {
        [self showGuessRateInfoOrShowAttentionInfo:YES];
    }
    
}

- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView editPressed:(id)sender {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"MyInfoSetting" bundle:nil] instantiateInitialViewController];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView attenPressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    
    if (!self.roomMasterModel) {
        return;
    }
    
    __weak AliveRoomViewController *wself = self;
    
    if (self.roomMasterModel.isAtten) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"取消关注";
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary *dict = @{@"user_id" :self.masterId?:@""};
        [manager POST:API_AliveDelAttention parameters:dict completion:^(id data, NSError *error){
            
            if (!error) {
                hud.label.text = @"取消成功";
                [hud hideAnimated:YES];
                
                wself.roomMasterModel.isAtten = NO;
                
                NSInteger fans = [self.roomMasterModel.fansNum integerValue];
                NSNumber *fansNumber = [NSNumber numberWithInteger:(fans-1)];
                wself.roomMasterModel.fansNum = fansNumber;
                
                [wself.roomNavigationBar setupRoomMasterModel:wself.roomMasterModel];
                [wself.roomHeaderView setupRoomMasterModel:wself.roomMasterModel];
            } else {
                hud.label.text = @"取消失败";
                [hud hideAnimated:YES afterDelay:0.8];
            }
        }];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"添加关注";
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary *dict = @{@"user_id" :self.masterId?:@""};
        [manager POST:API_AliveAddAttention parameters:dict completion:^(id data, NSError *error){
            
            if (!error) {
                hud.label.text = @"关注成功";
                [hud hideAnimated:YES];
                
                wself.roomMasterModel.isAtten = YES;
                
                NSInteger fans = [self.roomMasterModel.fansNum integerValue];
                NSNumber *fansNumber = [NSNumber numberWithInteger:(fans+1)];
                wself.roomMasterModel.fansNum = fansNumber;
                
                [wself.roomNavigationBar setupRoomMasterModel:wself.roomMasterModel];
                [wself.roomHeaderView setupRoomMasterModel:wself.roomMasterModel];
            } else {
                hud.label.text = @"关注失败";
                [hud hideAnimated:YES afterDelay:0.8];
            }
        }];
    }
}

- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView sharePressed:(id)sender {
    
}

- (void)showGuessRateInfoOrShowAttentionInfo:(BOOL)isGuessRate {
    AliveRoomPopupViewController *vc = [[UIStoryboard storyboardWithName:@"Popup" bundle:nil] instantiateViewControllerWithIdentifier:@"AliveRoomPopupViewController"];
    
    if (isGuessRate == YES) {
        vc.titleString = @"股神指数规则";
        vc.content = self.saveGuessRateInfoStr;
    }else {
        vc.titleString = @"等级规则";
        vc.content = self.saveLevelInfo;
        
    }
    
    CGSize size = [vc.content boundingRectWithSize:CGSizeMake(220-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]} context:nil].size;
    
    vc.contentSizeInPopup = CGSizeMake(220, size.height+140);
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.containerView.layer.cornerRadius = 4;
    
    popupController.navigationBarHidden = YES;
    [popupController presentInViewController:self];
}

- (void)loadGuessRateInfoOrAttentionInfo:(BOOL)isGuessRate {
    
    NSString *urlStr = nil;
    if (isGuessRate == YES) {
        urlStr = API_AliveGetGuessRateInfo;
    }else {
        
        urlStr = API_AliveGetAttenInfo;
    }
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    __weak typeof(self)weakSelf = self;
    [manager GET:urlStr parameters:nil completion:^(NSString *data, NSError *error){
        
        [indicator stopAnimating];
        
        if (!error) {
            data = [data stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
            
            if (isGuessRate == YES) {
                
                weakSelf.saveGuessRateInfoStr = data;
            }else {
                
                weakSelf.saveLevelInfo = data;
            }
            if (data.length > 0) {
                [weakSelf showGuessRateInfoOrShowAttentionInfo:isGuessRate];
            }
            
        } else {
            
        }
    }];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15.0f)];
    view.backgroundColor = TDViewBackgrouondColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 121.0f;
    } else if (indexPath.section == 1) {
        return kAliveSegmentHeight;
    }
    return 0.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        AliveRoomStockPoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveRoomStockPoolTableViewCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveRoomContentCellID"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AliveRoomContentCellID"];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // 股票池
        StockPoolListViewController *vc = [[StockPoolListViewController alloc] init];
        vc.userId = self.roomMasterModel.masterId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger index = [self.contentControllers indexOfObject:viewController];
    NSInteger before = index - 1;
    
    if (before < 0) {
        return nil;
    } else {
        return self.contentControllers[before];
    }
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSInteger index = [self.contentControllers indexOfObject:viewController];
    NSInteger after = index + 1;
    
    if (after >= [self.contentControllers count]) {
        return nil;
    } else {
        return self.contentControllers[after];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        return;
    }
    if (!finished) {
        return;
    }
    
    UIViewController *currentVc = [pageViewController.viewControllers firstObject];
    NSInteger index = [self.contentControllers indexOfObject:currentVc];
    
    if (index != self.segmentControl.selectedSegmentIndex) {
        if (index == 2) {
            
            index = 3;
        }
        self.segmentControl.selectedSegmentIndex = index;
        
        [self reloadTableView];
    }
}

#pragma mark - UIScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    CGFloat headerHeight = kAliveHeaderHeight + kAliveStockPoolHeight;
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        if (offset.y > (kAliveHeaderHeight - 64)) {
            [self.roomNavigationBar showNavigationBar:YES withTitle:self.roomMasterModel.masterNickName];
        } else {
            [self.roomNavigationBar showNavigationBar:NO withTitle:@""];
        }
        
        if (offset.y > (headerHeight - 64)) {
            CGRect newFrame = CGRectMake(0, offset.y+64, self.view.frame.size.width, kAliveSegmentHeight);
            self.segmentContentScrollView.frame = newFrame;
        } else {
            CGRect newFrame = CGRectMake(0, headerHeight, self.view.frame.size.width, kAliveSegmentHeight);
            self.segmentContentScrollView.frame = newFrame;
        }
    }
}
@end
