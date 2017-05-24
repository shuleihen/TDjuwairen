//
//  ViewPointViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/25.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ViewPointViewController.h"
#import "CategoryView.h"
#import "ViewPointListModel.h"
#import "SpecialModel.h"
#import "ViewPointTableViewCell.h"
#import "ViewSpecialTableViewCell.h"
#import "DetailPageViewController.h"
#import "PublishViewViewController.h"
#import "LoginViewController.h"
#import "LoginState.h"
#import "SearchViewController.h"
#import "NSString+Ext.h"
#import "UIImageView+WebCache.h"
#import "NetworkManager.h"
#import "MJRefresh.h"
#import "NetworkManager.h"
#import "UIViewController+Refresh.h"
#import "UIViewController+Loading.h"

@interface ViewPointViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGSize titlesize;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *viewNewArr;
@end

@implementation ViewPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabelView];
    
    [self showLoadingAnimationInCenter:CGPointMake(kScreenWidth/2, CGRectGetHeight(self.tableView.bounds)/2)];
    self.page = 1;
    [self requestDataWithPage:self.page];
}

- (void)setupTabelView {
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50) style:UITableViewStylePlain];
    tableview.backgroundColor = TDViewBackgrouondColor;
    tableview.separatorColor = TDSeparatorColor;
    tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    [self addHeaderRefreshWithScroll:self.tableView action:@selector(refreshActions)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (void)refreshActions{
    self.page = 1;
    [self requestDataWithPage:self.page];
}

- (void)loadMoreActions{
    [self requestDataWithPage:self.page];
}

- (void)requestDataWithPage:(NSInteger)aPage{
    __weak ViewPointViewController *wself = self;
    NSString *urlPath = [NSString stringWithFormat:@"%@index.php/View/recLists1_2/page/%ld",API_HOST,(long)self.page];;

    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:urlPath parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            NSArray *dataArray = data;
            if (dataArray.count > 0) {
                NSMutableArray *list = nil;
                
                if (wself.page == 1) {
                    list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                } else {
                    list = [NSMutableArray arrayWithArray:self.viewNewArr];
                }
                
                for (NSDictionary *d in dataArray) {
                    ViewPointListModel *model = [ViewPointListModel getInstanceWithDictionary:d];
                    [list addObject:model];
                }
                wself.viewNewArr = [NSMutableArray arrayWithArray:[list sortedArrayUsingSelector:@selector(compare:)]];
            }

            wself.page++;
        }
        
//        [wself.tableView.mj_header endRefreshing];
        [wself.tableView.mj_footer endRefreshing];
        [wself endHeaderRefresh];
        [wself removeLoadingAnimation];
        
        [wself.tableView reloadData];
    }];
}


#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewNewArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewPointListModel *model = self.viewNewArr[indexPath.row];
    return [ViewPointTableViewCell heightWithViewpointModel:model];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    ViewPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ViewPointTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    ViewPointListModel *model = self.viewNewArr[indexPath.row];
    [cell setupViewPointModel:model];

    return cell;
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailPageViewController *detail = [[DetailPageViewController alloc]init];
    detail.pageMode = @"view";
    ViewPointListModel *model = self.viewNewArr[indexPath.row];
    detail.view_id = model.view_id;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - Action
- (void)GoPublish:(UIButton *)sender{
    if (US.isLogIn == NO) {
        //跳转到登录页面
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }
    else
    {
        //跳转到发布页面
        PublishViewViewController *publishview = [[PublishViewViewController alloc] init];
        publishview.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:publishview animated:YES];
    }
    
}

- (void)GoSearch:(UIButton *)sender{
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchView animated:YES];
}

@end
