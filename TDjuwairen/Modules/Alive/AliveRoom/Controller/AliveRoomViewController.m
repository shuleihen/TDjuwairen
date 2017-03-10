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

@interface AliveRoomViewController ()
@property (nonatomic, strong) NSString *masterId;
@property (strong, nonatomic) AliveRoomHeaderView *roomHeaderV;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AliveRoomViewController

- (id)initWithRoomMasterId:(NSString *)masterId {
    if (self = [super init]) {
        self.view.backgroundColor = TDViewBackgrouondColor;
        [self queryRoomInfoWithMasterId:masterId];
        self.masterId = masterId;
    }
    return self;
}

- (AliveRoomHeaderView *)roomHeaderV {

    if (!_roomHeaderV) {
        __weak typeof(self)weakSelf = self;
        _roomHeaderV = [AliveRoomHeaderView loadAliveRoomeHeaderView];
        _roomHeaderV.frame = CGRectMake(0, 0, kScreenWidth, 210);
        _roomHeaderV.backBlock = ^(){
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        };
    }
    return _roomHeaderV;
}


- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshActions)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
    }
    
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpValue];
    [self setUpUICommon];
}

- (void)setUpValue {


}


- (void)setUpUICommon {
    [self.view addSubview:self.roomHeaderV];
    
    
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

#pragma mark -
- (void)setupRoomInfoWithMasterRoomModel:(AliveRoomMasterModel *)roomModel {
    
    
    
}



//- (void)refreshActions{
//    self.currentPage = 1;
//    [self queryAliveListWithType:self.listType withPage:self.currentPage];
//}
//
//- (void)loadMoreActions{
//    [self queryAliveListWithType:self.listType withPage:self.currentPage];
//}
//
//- (void)queryAliveListWithType:(AliveListType)listType withPage:(NSInteger)page {
//    __weak AliveListViewController *wself = self;
//    
//    NetworkManager *manager = [[NetworkManager alloc] init];
//    
//    NSDictionary *dict = @{@"tag" :@(listType),@"page" :@(page)};
//    
//    [manager GET:API_AliveGetRoomList parameters:dict completion:^(id data, NSError *error){
//        
//        if (wself.tableView.mj_header.isRefreshing) {
//            [wself.tableView.mj_header endRefreshing];
//        }
//        
//        if (wself.tableView.mj_footer.isRefreshing) {
//            [wself.tableView.mj_footer endRefreshing];
//        }
//        
//        if (!error) {
//            NSArray *dataArray = data;
//            BOOL scrollToTop = NO;
//            
//            if (dataArray.count > 0) {
//                NSMutableArray *list = nil;
//                if (wself.currentPage == 1) {
//                    list = [NSMutableArray arrayWithCapacity:[dataArray count]];
//                    scrollToTop = YES;
//                } else {
//                    list = [NSMutableArray arrayWithArray:wself.aliveList];
//                }
//                
//                for (NSDictionary *d in dataArray) {
//                    AliveListModel *model = [[AliveListModel alloc] initWithDictionary:d];
//                    [list addObject:model];
//                    
//                }
//                
//                wself.aliveList = [NSArray arrayWithArray:list];
//                
//                wself.currentPage++;
//            } else {
//                if (wself.currentPage == 1) {
//                    wself.aliveList = nil;
//                }
//            }
//            
//            [wself.tableViewDelegate reloadWithArray:wself.aliveList];
//            
//            if (scrollToTop) {
//                [wself.tableView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, 1) animated:YES];
//            }
//            
//        } else {
//            
//        }
//        
//    }];
//}








@end
