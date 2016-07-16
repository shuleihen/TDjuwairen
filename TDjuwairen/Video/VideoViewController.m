//
//  VideoViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/19.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "VideoViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "NSString+TimeInfo.h"
#import "NSString+Ext.h"
//刷新
#import "FCXRefreshFooterView.h"
#import "FCXRefreshHeaderView.h"
#import "UIScrollView+FCXRefresh.h"

#import "SurveyNavigationView.h"
#import "SurveyListModel.h"
#import "SurveyTableViewCell.h"
#import "SharpDetailsViewController.h"
#import "SearchViewController.h"

#import "LoginState.h"
@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
    FCXRefreshHeaderView *headerView;
    FCXRefreshFooterView *footerView;
    BOOL isFirstRequest;
}
@property (nonatomic,strong) NSMutableArray *VideoListArray;//文章列表数据

@property (nonatomic,strong) UITableView *tableview; //创建tableview
@property (nonatomic,strong) UIRefreshControl *refresh;//创建下拉刷新

@property (nonatomic,strong) SurveyNavigationView *NavigationView;    //自定义navigation

@property (nonatomic,strong) LoginState *loginstate;

//进入页面时的加载
@property (nonatomic,strong) UIImageView *loadingImageView;
@property (nonatomic,strong) UIActivityIndicatorView *loading;
@property (nonatomic,strong) UILabel *loadingLabel;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWithNavigation];
    self.loginstate = [LoginState addInstance];
    page = 1;
    isFirstRequest = YES;
    self.VideoListArray = [NSMutableArray array];
    [self requestDataWithVideoList];
    [self setupWithTableView];
    
    //添加刷新
    [self addRefreshView];
    
    [self setupWithLoading];    //设置进入加载页面
}

#pragma mark - 进入时加载页面
- (void)setupWithLoading{
    //加载页面
    self.loadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    self.loadingImageView.image = [UIImage imageNamed:@"加载页.png"];
    
    self.loading = [[UIActivityIndicatorView alloc]init];
    self.loading.frame = CGRectMake(kScreenWidth/3+5, kScreenHeight/2, 20, 20);
    /* 停止的时候消失 */
    self.loading.hidesWhenStopped = YES;
    self.loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    /* 让指示符开始转 */
    [self.loading startAnimating];
    
    self.loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/3+35, kScreenHeight/2, kScreenWidth/3-20, 20)];
    self.loadingLabel.text = @"内容加载中";
    self.loadingLabel.textColor = [UIColor grayColor];
    self.loadingLabel.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:self.loadingImageView];
    [self.loadingImageView addSubview:self.loading];
    [self.loadingImageView addSubview:self.loadingLabel];
}

#pragma mark - 设置navigation
- (void)setupWithNavigation{
    [self.navigationController.navigationBar setHidden:YES];
    //    self.navigationController.navigationBar.translucent = NO; //设置navigation为不透明，默认为YES半透明
    self.edgesForExtendedLayout = UIRectEdgeNone;    //iOS7及以后的版本支持，self.view.frame.origin.y会下移64像素至navigationBar下方
    
    //设置返回button
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    [backItem setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage* image = [UIImage imageNamed:@"back"];
    [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 60, 0, 10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
}

#pragma mark - 刷新
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    headerView = [self.tableview addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshAction];
    }];
    
    //上拉加载更多
    footerView = [self.tableview addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf loadMoreAction];
    }];
    
    //自动刷新
    //    footerView.autoLoadMore = self.autoLoadMore;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
    });
}

- (void)refreshAction {
    __weak UITableView *weakTableView = self.tableview;
    __weak FCXRefreshHeaderView *weakHeaderView = headerView;
    //数据表页数为1
    page = 1;
    [self requestDataWithVideoList];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakHeaderView endRefresh];
        [weakTableView reloadData];
    });
}

- (void)loadMoreAction {
    __weak UITableView *weakTableView = self.tableview;
    __weak FCXRefreshFooterView *weakFooterView = footerView;
    page++;
    //继续请求
    [self requestDataWithVideoList];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakFooterView endRefresh];
        [weakTableView reloadData];
    });
}

#pragma mark - 请求数据
-(void)requestDataWithVideoList{
    NSString *string = [NSString stringWithFormat:@"%@VideoList/page/%d",kAPI_Sharp,page];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (page == 1) {
            //            [self.VideoListArray removeAllObjects];
            if (isFirstRequest) {
                NSArray *dataArray = responseObject[@"data"];
                for (NSDictionary *d in dataArray) {
                    SurveyListModel *model = [SurveyListModel getInstanceWithDictionary:d];
                    [self.VideoListArray addObject:model];
                }
                isFirstRequest = NO;
            }
            else
            {
                SurveyListModel *mod = self.VideoListArray[0];
                NSArray *data = responseObject[@"data"];
                for (int i=0 ; i<data.count; i++) {
                    NSDictionary *d = data[i];
                    SurveyListModel *model = [SurveyListModel getInstanceWithDictionary:d];
                    if ([model.sharp_wtime intValue] > [mod.sharp_wtime intValue]) {
                        [self.VideoListArray insertObject:model atIndex:i];
                    }
                }
            }
        }
        else
        {
            NSArray *dataArray = responseObject[@"data"];
            /* 判断数组是否为空 */
            if ((NSNull *)dataArray != [NSNull null]) {
                for (NSDictionary *d in dataArray) {
                    SurveyListModel *model = [SurveyListModel getInstanceWithDictionary:d];
                    [self.VideoListArray addObject:model];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            __weak FCXRefreshFooterView *weakFooterView = footerView;
            [weakFooterView endRefresh];
            
            [self.loading stopAnimating]; //停止
            self.loadingLabel.alpha = 0.0;
            [self.loadingLabel removeFromSuperview];
            self.loadingImageView.alpha = 0.0;
            [self.loadingImageView removeFromSuperview];
            
            
            [self.tableview reloadData];//主线程刷新tableview
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络出错！请求失败");
    }];
}

#pragma mark - 设置tableview
-(void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-44) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    
    //取消分割线
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.NavigationView = [[SurveyNavigationView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    [self.NavigationView.searchButton addTarget:self action:@selector(ClickSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableview];//先添加tableview
    [self.view addSubview:self.NavigationView];  //自定义导航栏放在页面最上层
}
#pragma mark - 点击搜索
- (void)ClickSearchButton:(UIButton *)sender{
    SearchViewController *searchView = [self.storyboard instantiateViewControllerWithIdentifier:@"searchview"];
    [self.navigationController pushViewController:searchView animated:YES];
}

#pragma mark - create tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.VideoListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView registerNib:[UINib nibWithNibName:@"SurveyTableViewCell" bundle:nil] forCellReuseIdentifier:@"surveycell"];
    SurveyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"surveycell"];
    cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    SurveyListModel *model = self.VideoListArray[indexPath.row];
    cell.titlelabel.text = model.sharp_title;
    [cell.imgview sd_setImageWithURL:[NSURL URLWithString:model.sharp_imgurl]];
    [cell.userhead sd_setImageWithURL:[NSURL URLWithString:model.user_facemin]];
    NSString *currenttiem = [NSString prettyDateWithReference:model.sharp_wtime];
    cell.usernickname.text = [NSString stringWithFormat:@"%@ · %@",model.user_nickname,currenttiem];
    if (model.sharp_commentNumber >= 999) {
        cell.commentnumber.text = @"999+";
    }
    else{
        cell.commentnumber.text = [NSString stringWithFormat:@"%d",model.sharp_commentNumber];
        
    }
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
    
    SurveyListModel *model = self.VideoListArray[indexPath.row];
    SharpDetailsViewController *DetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    DetailView.sharp_id = model.sharp_id;
    DetailView.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
    
    if (self.loginstate.isLogIn) {     //为登录状态
        //添加浏览记录
        NSString *strurl = [NSString stringWithFormat:@"%@addBrowseHistory",kAPI_Public];
        NSDictionary *dic = @{@"userid":self.loginstate.userId,@"module_id":@2,@"item_id":model.sharp_id};
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:strurl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"code"] intValue] == 200) {
                NSLog(@"插入成功");
            }
            else
            {
                NSLog(@"插入失败");
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败");
        }];
    }
    
    [self.navigationController pushViewController:DetailView animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
