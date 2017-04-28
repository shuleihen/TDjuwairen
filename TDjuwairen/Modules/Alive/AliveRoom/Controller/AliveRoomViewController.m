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
#import "AliveEditMasterViewController.h"
#import "AliveMessageListViewController.h"
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

#define kAliveHeaderHeight  210
#define kAliveSegmentHeight 34

@interface AliveRoomViewController ()<UITableViewDelegate, UITableViewDataSource, UIPageViewControllerDataSource, UIPageViewControllerDelegate, AliveRoomHeaderViewDelegate, AliveRoomLiveContentListDelegate, DCPathButtonDelegate>
@property (nonatomic, strong) NSString *masterId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *aliveList;

@property (nonatomic, strong) AliveRoomHeaderView *roomHeaderView;
@property (nonatomic, strong) UIScrollView *segmentContentScrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentControl;

@property (nonatomic, strong) NSArray *contentControllers;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) AliveRoomMasterModel *roomMasterModel;

@property (nonatomic, strong) DCPathButton *publishBtn;
@end

@implementation AliveRoomViewController
- (void)dealloc {
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
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
        _segmentControl.sectionTitles = @[@"全部动态",@"贴单"];
        
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
        
        _contentControllers = @[one,two];
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
        DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc] initWithTitle:@"贴单"
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTableView];
    
    self.currentPage = 1;
    self.segmentControl.selectedSegmentIndex = 0;
    [self segmentPressed:self.segmentControl];
    
    self.publishBtn.hidden = YES;
    [self.view addSubview:self.publishBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publishNotifi:) name:kAlivePublishNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setupTableView {
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    [self.view addSubview:self.tableView];
    
    // 表头
    self.tableView.tableHeaderView = self.roomHeaderView;
    // 表尾
    self.tableView.tableFooterView = self.pageViewController.view;
    
    // 自定义悬浮segment
    self.segmentContentScrollView.frame = CGRectMake(0, kAliveHeaderHeight+10, kScreenWidth, kAliveSegmentHeight);
    [self.tableView addSubview:self.segmentContentScrollView];
    
    //添加监听，动态观察tableview的contentOffset的改变
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSexNotifi:) name:kUpdateAliveSexNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCityNotifi:) name:kUpdateAliveCityNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIntroNotifi:) name:kUpdateAliveIntroNotification object:nil];
}

- (void)setRoomMasterModel:(AliveRoomMasterModel *)roomMasterModel {
    _roomMasterModel = roomMasterModel;
    
    [self.roomHeaderView setupRoomMasterModel:roomMasterModel];
    
    BOOL isMaster = [roomMasterModel.masterId isEqualToString:US.userId];
    self.publishBtn.hidden = !isMaster;
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
    __weak AliveRoomViewController *wself = self;
    AliveRoomLiveViewController *vc = self.contentControllers[index];
    
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
    if (index >= 0 && index < [self.contentControllers count]) {
        return self.contentControllers[index];
    } else {
        return nil;
    }
}

- (void)reloadTableView {
    CGFloat contentHeight = [[self currentContentViewController] contentHeight];
    CGFloat minHeight = kScreenHeight -kAliveHeaderHeight-kAliveSegmentHeight-10;
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

#pragma mark - AliveRoomHeaderViewDelegate

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
        hud.labelText = @"取消关注";
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary *dict = @{@"user_id" :self.masterId?:@""};
        [manager POST:API_AliveDelAttention parameters:dict completion:^(id data, NSError *error){
            
            if (!error) {
                hud.labelText = @"取消成功";
                [hud hide:YES];
                
                wself.roomMasterModel.isAtten = NO;
                
                NSInteger fans = [self.roomMasterModel.fansNum integerValue];
                NSNumber *fansNumber = [NSNumber numberWithInteger:(fans-1)];
                wself.roomMasterModel.fansNum = fansNumber;
                
                [wself.roomHeaderView setupRoomMasterModel:wself.roomMasterModel];
            } else {
                hud.labelText = @"取消失败";
                [hud hide:YES afterDelay:0.8];
            }
        }];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"添加关注";
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary *dict = @{@"user_id" :self.masterId?:@""};
        [manager POST:API_AliveAddAttention parameters:dict completion:^(id data, NSError *error){
            
            if (!error) {
                hud.labelText = @"关注成功";
                [hud hide:YES];
                
                wself.roomMasterModel.isAtten = YES;
                
                NSInteger fans = [self.roomMasterModel.fansNum integerValue];
                NSNumber *fansNumber = [NSNumber numberWithInteger:(fans+1)];
                wself.roomMasterModel.fansNum = fansNumber;
                
                [wself.roomHeaderView setupRoomMasterModel:wself.roomMasterModel];
            } else {
                hud.labelText = @"关注失败";
                [hud hide:YES afterDelay:0.8];
            }
        }];
    }
}

- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView attentionListPressed:(id)sender {
    if (!self.roomMasterModel) {
        return;
    }
    
    AliveMasterListViewController *aliveMasterListVC = [[AliveMasterListViewController alloc] init];
    aliveMasterListVC.listType = AliveAttentionList;
    aliveMasterListVC.masterId = self.masterId;
    [self.navigationController pushViewController:aliveMasterListVC animated:YES];
}

- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView fansListPressed:(id)sender {
    if (!self.roomMasterModel) {
        return;
    }
    
    AliveMasterListViewController *aliveMasterListVC = [[AliveMasterListViewController alloc] init];
    aliveMasterListVC.listType = AliveFansList;
    aliveMasterListVC.masterId = self.masterId;
    [self.navigationController pushViewController:aliveMasterListVC animated:YES];
}

- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView editPressed:(id)sender {
    AliveEditMasterViewController *vc = [[UIStoryboard storyboardWithName:@"Alive" bundle:nil] instantiateViewControllerWithIdentifier:@"AliveEditMasterViewController"];
    vc.masterId = self.masterId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView messagePressed:(id)sender {
    AliveMessageListViewController *vc = [[AliveMessageListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView levelPressed:(id)sender {
    AliveRoomPopupViewController *vc = [[UIStoryboard storyboardWithName:@"Alive" bundle:nil] instantiateViewControllerWithIdentifier:@"AliveRoomPopupViewController"];
    vc.titleString = @"等级规则";
    vc.content = @"根据关注数1级 0-20人；2级 21-40人；100以内，每增加20个关注度，增加一级；500以内，每增加50个关注度，增加一级";
    vc.contentSizeInPopup = CGSizeMake(220, 230);
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.containerView.layer.cornerRadius = 4;
    popupController.navigationBarHidden = YES;
    [popupController presentInViewController:self];

}

- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView guestRulePressed:(id)sender {
    AliveRoomPopupViewController *vc = [[UIStoryboard storyboardWithName:@"Alive" bundle:nil] instantiateViewControllerWithIdentifier:@"AliveRoomPopupViewController"];
    vc.titleString = @"股神指数规则";
    vc.content = @"1.用户起始指数为50，指数上不封顶\n\
    2.比谁准中指数竞猜获得大奖（猜中）+20，5倍+10，2倍+1，lose-1\n\
    3.个股竞猜中，赢一场+4，输一场-0.5\n\
    4.pc猜红绿赢一场+2，输一场-2";
    vc.contentSizeInPopup = CGSizeMake(220, 300);
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.containerView.layer.cornerRadius = 4;
    popupController.navigationBarHidden = YES;
    [popupController presentInViewController:self];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kAliveSegmentHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveRoomContentCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AliveRoomContentCellID"];
    }
    
    return cell;
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
        self.segmentControl.selectedSegmentIndex = index;
        
        [self reloadTableView];
    }
}

#pragma mark - UIScroll
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat headerHeight = kAliveHeaderHeight + 10;
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (offset.y > (headerHeight-20)) {
            
            CGRect newFrame = CGRectMake(0, offset.y, self.view.frame.size.width, kAliveSegmentHeight+20);
            self.segmentContentScrollView.frame = newFrame;
            self.segmentControl.frame = CGRectMake(0, 20, 160, 34);
            
        } else {
            CGRect newFrame = CGRectMake(0, headerHeight, self.view.frame.size.width, kAliveSegmentHeight);
            self.segmentContentScrollView.frame = newFrame;
            self.segmentControl.frame = CGRectMake(0, 0, 160, 34);
        }
    }
}
@end
