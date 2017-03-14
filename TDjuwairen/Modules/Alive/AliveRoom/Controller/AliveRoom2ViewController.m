//
//  AliveRoom2ViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveRoom2ViewController.h"
#import "AliveRoomHeaderView.h"
#import "NetworkManager.h"
#import "AliveRoomMasterModel.h"
#import "AliveMasterListViewController.h"
#import "AliveMessageListViewController.h"
#import "AliveEditMasterViewController.h"
#import "HMSegmentedControl.h"
#import "AliveListTableViewDelegate.h"
#import "MJRefresh.h"
#import "AliveListModel.h"

typedef enum : NSUInteger {
    AliveRoomLiveNormal =0,
    AliveRoomLivePosts  =1,
} AliveRoomLiveType;

@interface AliveRoom2ViewController ()<AliveRoomHeaderViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString *masterId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AliveRoomHeaderView *roomHeaderView;
@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) UIScrollView *scroolView;
@property (nonatomic, assign) AliveRoomLiveType listType;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *aliveList;
@property (nonatomic, strong) AliveListTableViewDelegate *normalAliveTableViewDelegate;
@property (nonatomic, strong) AliveListTableViewDelegate *postsAliveTableViewDelegate;
@end

@implementation AliveRoom2ViewController

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
        _segmentControl.frame = CGRectMake(0, 0, 160, 34);
        [_segmentControl addTarget:self action:@selector(segmentPressed:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _segmentControl;
}

- (UIScrollView *)scroolView {
    if (!_scroolView) {
        _scroolView = [[UIScrollView alloc] init];
        _scroolView.showsVerticalScrollIndicator = NO;
        _scroolView.pagingEnabled = YES;
        _scroolView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight);
        
        UITableView *tableView1 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView1.backgroundColor = TDViewBackgrouondColor;
        tableView1.separatorColor = TDSeparatorColor;
        tableView1.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [_scroolView addSubview:tableView1];
        
        UITableView *tableView2 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView2.backgroundColor = TDViewBackgrouondColor;
        tableView2.separatorColor = TDSeparatorColor;
        tableView2.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
        [_scroolView addSubview:tableView2];
        
        _normalAliveTableViewDelegate = [[AliveListTableViewDelegate alloc] initWithTableView:tableView1 withViewController:self];
        _postsAliveTableViewDelegate = [[AliveListTableViewDelegate alloc] initWithTableView:tableView2 withViewController:self];
    }
    return _scroolView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableHeaderView = self.roomHeaderView;
    [self.view addSubview:self.tableView];
    
    self.listType = AliveRoomLiveNormal;
    self.currentPage = 1;
    [self refreshActions];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setupRoomWithAliveMasterModel:(AliveRoomMasterModel *)model {
    [self.roomHeaderView setupRoomMasterModel:model];
}

- (void)queryRoomInfoWithMasterId:(NSString *)masterId {
    
    if (!masterId.length) {
        return;
    }
    
    __weak AliveRoom2ViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dict = @{@"master_id" :masterId};
    [manager GET:API_AliveGetRoomInfo parameters:dict completion:^(id data, NSError *error){
        
        if (!error) {
            AliveRoomMasterModel *model = [[AliveRoomMasterModel alloc] initWithDictionary:data];
            [wself setupRoomWithAliveMasterModel:model];
            
        } else {
            
        }
        
    }];
}

- (void)refreshActions{
    self.currentPage = 1;
    [self queryAliveListWithType:self.listType withPage:self.currentPage];
}

- (void)loadMoreActions{
    [self queryAliveListWithType:self.listType withPage:self.currentPage];
}

- (void)queryAliveListWithType:(AliveRoomLiveType)listType withPage:(NSInteger)page {
    __weak AliveRoom2ViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{@"master_id":self.masterId,@"tag":@(listType),@"page":@(self.currentPage)};
    
    [manager GET:API_AliveGetRoomLiveList parameters:dict completion:^(id data, NSError *error){
        
        if (wself.tableView.mj_header.isRefreshing) {
            [wself.tableView.mj_header endRefreshing];
        }
        
        if (wself.tableView.mj_footer.isRefreshing) {
            [wself.tableView.mj_footer endRefreshing];
        }
        
        if (!error) {
            NSArray *dataArray = data;
            BOOL scrollToTop = NO;
            
            if (dataArray.count > 0) {
                NSMutableArray *list = nil;
                if (wself.currentPage == 1) {
                    list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                    scrollToTop = YES;
                } else {
                    list = [NSMutableArray arrayWithArray:wself.aliveList];
                }
                
                for (NSDictionary *d in dataArray) {
                    AliveListModel *model = [[AliveListModel alloc] initWithDictionary:d];
                    [list addObject:model];
                    
                }
                
                wself.aliveList = [NSArray arrayWithArray:list];
                
                wself.currentPage++;
            } else {
                if (wself.currentPage == 1) {
                    wself.aliveList = nil;
                }
            }
            
            AliveListTableViewDelegate *tableDelegate = nil;
            if (listType == AliveRoomLiveNormal) {
                tableDelegate = wself.normalAliveTableViewDelegate;
            } else {
                tableDelegate = wself.postsAliveTableViewDelegate;
            }
            
            [tableDelegate reloadWithArray:wself.aliveList];
            
            // 计算高度
            CGFloat height = MAX([tableDelegate contentHeight],kScreenHeight);
            wself.scroolView.frame = CGRectMake(0, 0, kScreenWidth, height);
            wself.scroolView.contentSize = CGSizeMake(kScreenWidth*2, height);
            [wself.tableView reloadData];
            
            for (UITableView *table in wself.scroolView.subviews) {
                table.bounds = CGRectMake(0, 0, kScreenWidth, height);
            }
            
            if (scrollToTop) {
                [wself.tableView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, 1) animated:YES];
            }
            
        } else {
            
        }
        
    }];
}

#pragma mark - Action

- (void)segmentPressed:(id)sender {
    NSInteger index = self.segmentControl.selectedSegmentIndex;
    self.listType = index;
    self.currentPage = 1;
    
    self.scroolView.contentOffset = CGPointMake(kScreenWidth*index, 0);
    
    [self refreshActions];
}

#pragma mark - AliveRoomHeaderViewDelegate

- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView attenPressed:(id)sender {
    
}

- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView attentionListPressed:(id)sender {
    AliveMasterListViewController *aliveMasterListVC = [[AliveMasterListViewController alloc] init];
    aliveMasterListVC.listType = AliveAttentionList;
    aliveMasterListVC.masterId = self.masterId;
    [self.navigationController pushViewController:aliveMasterListVC animated:YES];
}

- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView fansListPressed:(id)sender {
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

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
    self.segmentControl.frame = CGRectMake(0, 0, 150, 34);
    [view addSubview:self.segmentControl];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetHeight(self.scroolView.frame);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveRoomLiveCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AliveRoomLiveCellID"];
        [cell.contentView addSubview:self.scroolView];
    }
    
    return cell;
}
@end
