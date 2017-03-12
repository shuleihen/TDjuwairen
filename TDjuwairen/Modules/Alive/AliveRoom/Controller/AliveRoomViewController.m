//
//  AliveRoomViewController.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveRoomViewController.h"
#import "NetworkManager.h"
#import "AliveRoomMasterModel.h"
#import "AliveRoomHeaderView.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "AliveRoomPageSelectView.h"
#import "AliveListTableViewDelegate.h"
#import "AliveMasterListViewController.h"

#import "AliveListModel.h"

@interface AliveRoomViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) AliveRoomHeaderView *roomHeaderV;
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *pageScrollView;
@property (assign, nonatomic) NSInteger selectedPage;
@property (strong, nonatomic) AliveRoomPageSelectView *pHeaderV;


@property (nonatomic, strong) AliveListTableViewDelegate *tableViewDelegate;
@property (strong, nonatomic) UITableView *contentTableView;
@property (assign, nonatomic) NSInteger pageOne;
@property (strong, nonatomic) NSMutableArray *contentArrM1;




@property (nonatomic, strong) AliveListTableViewDelegate *tableViewDelegate2;
@property (strong, nonatomic) UITableView *contentTableView2;
@property (assign, nonatomic) NSInteger pageTwo;
@property (strong, nonatomic) NSMutableArray *contentArrM2;



@property (assign, nonatomic) NSInteger currentPage;






@end

@implementation AliveRoomViewController


- (void)setMasterId:(NSString *)masterId {
    
    _masterId = masterId;
    [self queryRoomInfoWithMasterId:masterId];
    
}


- (AliveRoomHeaderView *)roomHeaderV {
    
    if (!_roomHeaderV) {
        __weak typeof(self)weakSelf = self;
        _roomHeaderV = [AliveRoomHeaderView loadAliveRoomeHeaderView];
        _roomHeaderV.frame = CGRectMake(0, 0, kScreenWidth, 210);
        _roomHeaderV.backBlock = ^(){
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        };
        
        _roomHeaderV.addAttentionBlock = ^(BOOL addAttention){
        
            if (weakSelf.masterId.length <= 0) {
                return ;
            }
            
            NSString *str = API_AliveAddAttention;
            if (addAttention == YES) {
                // 取消关注
                str = API_AliveDelAttention;
            }
            
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            hud.labelText = @"提交中...";
            
            NetworkManager *manager = [[NetworkManager alloc] init];
            
            [manager POST:str parameters:@{@"user_id":weakSelf.masterId} completion:^(id data, NSError *error){
                NSLog(@"---------%@",data);
                if (!error) {
                    
                    if (data && [data[@"status"] integerValue] == 1) {
                        AliveRoomMasterModel *model = weakSelf.roomHeaderV.headerModel;
                        model.isAtten = !model.isAtten;
                        weakSelf.roomHeaderV.headerModel = model;
                        
                        [hud hide:YES afterDelay:0.2];
                    }
                } else {
                    hud.labelText = error.localizedDescription?:@"提交失败";
                    [hud hide:YES afterDelay:0.4];
                }
                
            }];
        
        };
        
        
        _roomHeaderV.btnClickBlock = ^(ButtonType btnType){
            AliveMasterListViewController *aliveMasterListVC = [[AliveMasterListViewController alloc] init];
            if (btnType == ButtonAttentionType) {
                
                aliveMasterListVC.listType = AliveAttentionList;
            }else {
                
                aliveMasterListVC.listType = AliveFansList;
            }
            aliveMasterListVC.masterId = weakSelf.masterId;
            [weakSelf.navigationController pushViewController:aliveMasterListVC animated:YES];
        };
    }
    return _roomHeaderV;
}


- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = self.roomHeaderV;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    
    return _tableView;
}

- (UITableView *)contentTableView {
    
    if (!_contentTableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-255);
        _contentTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _contentTableView.backgroundColor = TDViewBackgrouondColor;
        _contentTableView.separatorColor = TDSeparatorColor;
        _contentTableView.separatorInset = UIEdgeInsetsZero;
        _contentTableView.showsVerticalScrollIndicator = NO;
        
        _contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshActions1)];
        _contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions1)];
        [self refreshActions1];
        
    }
    
    return _contentTableView;
}

- (UITableView *)contentTableView2 {
    
    if (!_contentTableView2) {
        CGRect rect = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-255);
        _contentTableView2 = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _contentTableView2.backgroundColor = TDViewBackgrouondColor;
        _contentTableView2.separatorColor = TDSeparatorColor;
        _contentTableView2.separatorInset = UIEdgeInsetsZero;
        _contentTableView2.showsVerticalScrollIndicator = NO;
        
        _contentTableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshActions2)];
        _contentTableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions2)];
        [self refreshActions2];
    }
    
    return _contentTableView2;
}


- (UIScrollView *)pageScrollView {
    
    if (!_pageScrollView) {
        _pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-255)];
        _pageScrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight-255);
        _pageScrollView.pagingEnabled = YES;
        _pageScrollView.showsHorizontalScrollIndicator = NO;
        _pageScrollView.showsVerticalScrollIndicator = NO;
        _pageScrollView.delegate = self;
        [_pageScrollView addSubview:self.contentTableView];
        [_pageScrollView addSubview:self.contentTableView2];
        
    }
    return _pageScrollView;
}

- (AliveRoomPageSelectView *)pHeaderV {
    
    if (!_pHeaderV) {
        _pHeaderV = [AliveRoomPageSelectView loadAliveRoomPageSelectView];
        
        _pHeaderV.frame = CGRectMake(0, 0, kScreenWidth, 45);
        __weak typeof(self)weakSelf = self;
        _pHeaderV.selectedBtnBlock = ^(UIButton *sender){
            [weakSelf.pageScrollView setContentOffset:CGPointMake((sender.tag-100)*kScreenWidth, 0) animated:YES];
            weakSelf.selectedPage = sender.tag-100;
            
        };
    }
    return _pHeaderV;
}

- (void)setSelectedPage:(NSInteger)selectedPage {
    
    _selectedPage = selectedPage;
    [self.pHeaderV showBtnUI:selectedPage];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpValue];
    [self setUpUICommon];
}

- (void)setUpValue {
    self.selectedPage = 0;
    self.contentArrM1 = [NSMutableArray array];
    self.contentArrM2 = [NSMutableArray array];
    
    
}


- (void)setUpUICommon {
    self.view.backgroundColor = TDViewBackgrouondColor;
    [self.view addSubview:self.tableView];
    self.tableViewDelegate = [[AliveListTableViewDelegate alloc] initWithTableView:self.contentTableView withViewController:self];
    self.tableViewDelegate2 = [[AliveListTableViewDelegate alloc] initWithTableView:self.contentTableView2 withViewController:self];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
            //            [wself setupRoomInfoWithMasterRoomModel:model];
            wself.roomHeaderV.headerModel = model;
        } else {
            
        }
        
    }];
}


- (void)refreshActions1 {
    self.pageOne = 1;
    [self loadAliveRoomListData:@"0" pageNum:self.pageOne];
    
}


- (void)loadMoreActions1 {
    [self loadAliveRoomListData:@"0" pageNum:self.pageOne];
    
}


- (void)refreshActions2 {
    self.pageTwo = 1;
    [self loadAliveRoomListData:@"1" pageNum:self.pageTwo];
}


- (void)loadMoreActions2 {
    [self loadAliveRoomListData:@"1" pageNum:self.pageTwo];
    
}

- (void)loadAliveRoomListData:(NSString *)tagStr pageNum:(NSInteger)pageNum {
    __weak typeof(self)weakSelf = self;
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_AliveGetRoomLiveList parameters:@{@"master_id":self.masterId,@"tag":tagStr,@"page":@(pageNum)} completion:^(id data, NSError *error){
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.contentTableView.mj_header endRefreshing];
        [weakSelf.contentTableView2.mj_header endRefreshing];
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.contentTableView.mj_footer endRefreshing];
        [weakSelf.contentTableView2.mj_footer endRefreshing];
        
        
        if (!error) {
            NSMutableArray *list = [NSMutableArray array];
            
            
            for (NSDictionary *d in data) {
                AliveListModel *model = [[AliveListModel alloc] initWithDictionary:d];
                [list addObject:model];
                
            }
            
            
            if ([tagStr isEqualToString:@"0"]) {
                
                if (pageNum == 1) {
                    [self.contentArrM1 removeAllObjects];
                    
                }
                
                [self.contentArrM1 addObjectsFromArray:[list mutableCopy]];
                [self.tableViewDelegate reloadWithArray:self.contentArrM1];
                
            }else {
                // 贴单
                
                if (pageNum == 1) {
                    [self.contentArrM2 removeAllObjects];
                    
                }
                
                [self.contentArrM2 addObjectsFromArray:[list mutableCopy]];
                [self.tableViewDelegate2 reloadWithArray:self.contentArrM2];
                
                
            }
            
            
        } else {
            
        }
        
    }];
}

#pragma mark -



#pragma mark -------------- UITableViewDataSource ---------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *contentCell =  [tableView dequeueReusableCellWithIdentifier:@"contentTableViewCell"];
    if (contentCell == nil) {
        contentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contentTableViewCell"];
    }
    
    [contentCell.contentView addSubview:self.pageScrollView];
    
    return contentCell;
}

#pragma mark ----------------------------------------------------------



#pragma mark -------------- UITableViewDelegate ---------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    
    return self.pHeaderV;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kScreenHeight-255;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 45;
}



#pragma mark ----------------------------------------------------------







- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if(!decelerate)
    {   //OK,真正停止了，do something}
        [self scrollViewDidEndDecelerating:scrollView];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int currentPage = scrollView.contentOffset.x/kScreenWidth;
    
    if (currentPage == self.selectedPage) {
        return;
    }else {
        
        self.selectedPage = currentPage;
    }
    
    
}




@end
