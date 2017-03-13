//
//  AliveListViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/7.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListViewController.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "AliveListModel.h"
#import "MJRefresh.h"
#import "UIImage+Color.h"
#import "AliveMasterListViewController.h"
#import "AliveListTableViewDelegate.h"
#import "AlivePublishViewController.h"
#import "AliveEditMasterViewController.h"
#import "AliveMessageListViewController.h"
#import "LoginState.h"

typedef enum : NSUInteger {
    AliveAttention  =0,
    AliveRecommend  =1,
    AliveALL        =2,
} AliveListType;

@interface AliveListViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) AliveListType listType;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *aliveList;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) AliveListTableViewDelegate *tableViewDelegate;
@end

@implementation AliveListViewController

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
    // Do any additional setup after loading the view.
    
    [self setupNavigationBar];
    [self.view addSubview:self.tableView];
    
    self.tableViewDelegate = [[AliveListTableViewDelegate alloc] initWithTableView:self.tableView withViewController:self];
    
    self.listType = AliveAttention;
    self.currentPage = 1;
    [self.segmentControl setSelectedSegmentIndex:self.listType];
    
    [self queryAliveListWithType:self.listType withPage:self.currentPage];
}

- (void)setupNavigationBar {
    
    UIImage *normal = [UIImage imageWithSize:CGSizeMake(45, 28) withColor:[UIColor whiteColor]];
    UIImage *pressed = [UIImage imageWithSize:CGSizeMake(45, 28) withColor:TDThemeColor];
    
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"关注",@"推荐",@"全部"]];
    segmented.layer.cornerRadius = 0.0f;
    segmented.layer.borderWidth = 1.0f;
    segmented.layer.borderColor = TDThemeColor.CGColor;

    [segmented addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: TDThemeColor}
                             forState:UIControlStateNormal];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}
                             forState:UIControlStateHighlighted];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}
                             forState:UIControlStateSelected];
    
    segmented.frame = CGRectMake(0, 0, 135, 28);
    [segmented setBackgroundImage:normal forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:pressed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:pressed forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = segmented;
    self.segmentControl = segmented;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [rightBtn setTitleColor:TDThemeColor forState:UIControlStateNormal];
    [rightBtn setTitle:@"播主" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(anchorPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

#pragma mark - Action
- (void)segmentValueChanged:(UISegmentedControl *)segment {
    self.listType = segment.selectedSegmentIndex;
    self.currentPage = 1;
    [self.segmentControl setSelectedSegmentIndex:self.listType];
    
    [self queryAliveListWithType:self.listType withPage:self.currentPage];
}

- (void)anchorPressed:(id)sender {
    
//    AliveMessageListViewController *vc = [[AliveMessageListViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    [self.navigationController pushViewController:vc animated:YES];

    
//    AliveEditMasterViewController *vc = [[UIStoryboard storyboardWithName:@"Alive" bundle:nil] instantiateViewControllerWithIdentifier:@"AliveEditMasterViewController"];
//    vc.masterId = US.userId;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
//    AlivePublishViewController *vc = [[AlivePublishViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    [self.navigationController pushViewController:vc animated:YES];
    
    AliveMasterListViewController *aliveMasterListVC = [[AliveMasterListViewController alloc] init];
    aliveMasterListVC.listType = AliveMasterList;
    [aliveMasterListVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:aliveMasterListVC animated:YES];
}

- (void)refreshActions{
    self.currentPage = 1;
    [self queryAliveListWithType:self.listType withPage:self.currentPage];
}

- (void)loadMoreActions{
    [self queryAliveListWithType:self.listType withPage:self.currentPage];
}

- (void)queryAliveListWithType:(AliveListType)listType withPage:(NSInteger)page {
    __weak AliveListViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{@"tag" :@(listType),@"page" :@(page)};
    
    [manager GET:API_AliveGetRoomList parameters:dict completion:^(id data, NSError *error){
        
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
            
            [wself.tableViewDelegate reloadWithArray:wself.aliveList];
            
            if (scrollToTop) {
                [wself.tableView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, 1) animated:YES];
            }
            
        } else {
            
        }
        
    }];
}


@end
