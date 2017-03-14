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
    
    [self setupWithNavigation];
    [self setupTabelView];
    
    self.page = 1;
    [self requestDataWithPage:self.page];
}

- (void)setupTabelView {
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50) style:UITableViewStylePlain];
    tableview.backgroundColor = TDViewBackgrouondColor;
    tableview.separatorColor = TDSeparatorColor;
    tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshActions)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
}

- (void)setupWithNavigation{
    self.title = @"观点";

    UIButton *publish = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [publish setImage:[UIImage imageNamed:@"nav_publish.png"] forState:UIControlStateNormal];
    [publish addTarget:self action:@selector(GoPublish:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:publish];
    
    UIButton*search = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [search setImage:[UIImage imageNamed:@"nav_search.png"] forState:UIControlStateNormal];
    [search addTarget:self action:@selector(GoSearch:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:search];
    
    self.navigationItem.rightBarButtonItems = @[rightItem1,rightItem2];
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
            
            [wself.tableView.mj_header endRefreshing];
            [wself.tableView.mj_footer endRefreshing];
            wself.page++;
            [wself.tableView reloadData];
        } else {
            [wself.tableView.mj_header endRefreshing];
            [wself.tableView.mj_footer endRefreshing];
            [wself.tableView reloadData];
        }
    }];
    
}


#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewNewArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    ViewPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ViewPointTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    ViewPointListModel *model = self.viewNewArr[indexPath.row];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:model.user_facemin]];
    NSString *isoriginal;
    if ([model.view_isoriginal isEqualToString:@"0"]) {
        isoriginal = @"";
    }else
    {
        isoriginal = @"原创";
    }
    cell.nicknameLabel.text = [NSString stringWithFormat:@"%@  %@  %@",model.user_nickname,model.view_wtime,isoriginal];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    cell.titleLabel.font = font;
    cell.titleLabel.numberOfLines = 0;
    titlesize = CGSizeMake(kScreenWidth-30, 500.0);
    titlesize = [model.view_title calculateSize:titlesize font:font];
    cell.titleLabel.text = model.view_title;
    [cell.titleLabel setFrame:CGRectMake(15, 15+25+10, kScreenWidth-30, titlesize.height)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 15+25+10+titlesize.height+15;
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
