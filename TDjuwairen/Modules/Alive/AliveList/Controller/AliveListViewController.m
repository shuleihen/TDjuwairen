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
#import "AliveListTableViewCell.h"
#import "AliveListBottomTableViewCell.h"
#import "AliveListModel.h"
#import "MJRefresh.h"
#import "UIImage+Color.h"

typedef enum : NSUInteger {
    AliveAttention  =0,
    AliveRecommend  =1,
    AliveALL        =2,
} AliveListType;

@interface AliveListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) AliveListType listType;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *aliveList;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@end

@implementation AliveListViewController

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;

        UINib *nib = [UINib nibWithNibName:@"AliveListTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"AliveListTableViewCellID"];
        
        UINib *nib1 = [UINib nibWithNibName:@"AliveListBottomTableViewCell" bundle:nil];
        [self.tableView registerNib:nib1 forCellReuseIdentifier:@"AliveListBottomTableViewCellID"];
        
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
    
    [manager GET:API_AliveGetList parameters:dict completion:^(id data, NSError *error){
        
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
            
            [wself.tableView reloadData];
            
            if (scrollToTop) {
                [wself.tableView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, 1) animated:YES];
            }
            
        } else {
            
        }
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.aliveList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AliveListModel *model = self.aliveList[indexPath.section];
        return [AliveListTableViewCell heightWithAliveModel:model];
    } else {
        return 37;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AliveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveListTableViewCellID"];
        
        
        return cell;
    } else {
        AliveListBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveListBottomTableViewCellID"];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    AliveListModel *model = self.aliveList[indexPath.section];
    
    if (indexPath.row == 0) {
        AliveListTableViewCell *scell = (AliveListTableViewCell *)cell;
        [scell setupAliveModel:model];
    } else {
        AliveListBottomTableViewCell *scell = (AliveListBottomTableViewCell *)cell;
        [scell setupAliveModel:model];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AliveListModel *model = self.aliveList[indexPath.section];
}
@end
