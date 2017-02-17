//
//  VideoViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/19.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "VideoViewController.h"
#import "UIImageView+WebCache.h"
#import "NSString+TimeInfo.h"
#import "NSString+Ext.h"
#import "SurveyListModel.h"
#import "VideoListCell.h"
#import "DetailPageViewController.h"
#import "SearchViewController.h"
#import "UIdaynightModel.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "MJRefresh.h"
#import "YXSearchButton.h"

@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *videos;
@property (nonatomic, assign) NSInteger page;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupWithTableView];
    [self addRefreshView];

    self.page = 1;
    [self requestDataWithVideoList];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"";
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 98, 35)];
    imageView.image = [UIImage imageNamed:@"nav_logo.png"];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.leftBarButtonItem = left;
    
    // 通知
    YXSearchButton *search = [[YXSearchButton alloc] init];
    [search addTarget:self action:@selector(searchPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = search;
    
    search.frame = CGRectMake(120, 7, [UIScreen mainScreen].bounds.size.width-135, 30);
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:@"VideoListCell" bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:@"VideoListCellID"];
    
    [self.view addSubview:self.tableview];
}


#pragma mark - Action
- (void)addRefreshView
{
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
}

- (void)refreshAction {
    self.page = 1;
    [self requestDataWithVideoList];
}

- (void)loadMoreAction {
    [self requestDataWithVideoList];
}

- (void)searchPressed:(UIButton *)sender {
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchView animated:YES];
}

#pragma mark - 请求数据
-(void)requestDataWithVideoList{
    NSString *string = [NSString stringWithFormat:@"%@/%ld",API_GetVideoList,(long)self.page];
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    
    __weak VideoViewController *wself = self;
    [manager GET:string parameters:nil completion:^(id data, NSError *error){
        
        if ([wself.tableview.mj_footer isRefreshing]) {
            [wself.tableview.mj_footer endRefreshing];
        }
        
        if ([wself.tableview.mj_header isRefreshing]) {
            [wself.tableview.mj_header endRefreshing];
        }
        
        if (!error) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[data count]];
            for (NSDictionary *d in data) {
                SurveyListModel *model = [SurveyListModel getInstanceWithDictionary:d];
                [array addObject:model];
            }
            
            if (wself.page == 1) {
                wself.videos = array;
            } else {
                [wself.videos addObjectsFromArray:array];
            }
            
            wself.page++;
            [wself.tableview reloadData];
        } else {
            
        }
    }];
}


#pragma mark - create tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.videos count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoListCellID"];
    
    SurveyListModel *model = self.videos[indexPath.row];
    [cell setupModel:model];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

#pragma mark - 点击文章
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* 取消选中状态 */
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    
    SurveyListModel *model = self.videos[indexPath.row];
    
    DetailPageViewController *DetailView = [[DetailPageViewController alloc] init];
    DetailView.sharp_id = model.sharp_id;
    DetailView.pageMode = @"sharp";
    DetailView.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
    
    if (US.isLogIn) {     //为登录状态
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary *dic = @{@"userid":US.userId,@"module_id":@2,@"item_id":model.sharp_id};
        
        [manager POST:API_AddBrowseHistory parameters:dic completion:^(id data, NSError *error){
            if (!error) {
                
            } else {
                
            }
        }];
    }
    
    [self.navigationController pushViewController:DetailView animated:YES];
}

@end
