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
#import "SurveyNavigationView.h"
#import "SurveyListModel.h"
#import "SurveyTableViewCell.h"
#import "SharpDetailsViewController.h"
#import "SearchViewController.h"
#import "UIdaynightModel.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "MJRefresh.h"

@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
    BOOL isFirstRequest;
}
@property (nonatomic,strong) NSMutableArray *VideoListArray;//文章列表数据

@property (nonatomic,strong) UITableView *tableview; //创建tableview
@property (nonatomic,strong) UIRefreshControl *refresh;//创建下拉刷新

@property (nonatomic,strong) SurveyNavigationView *NavigationView;    //自定义navigation

@property (nonatomic,strong) UIdaynightModel *daynightmodel;

//进入页面时的加载
@property (nonatomic,strong) UIImageView *loadingImageView;
@property (nonatomic,strong) UIActivityIndicatorView *loading;
@property (nonatomic,strong) UILabel *loadingLabel;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 1;
    isFirstRequest = YES;
    self.VideoListArray = [NSMutableArray array];
    
    self.daynightmodel = [UIdaynightModel sharedInstance];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *daynight = [userdefault objectForKey:@"daynight"];
    if ([daynight isEqualToString:@"yes"]) {
        [self.daynightmodel day];
    }
    else
    {
        [self.daynightmodel night];
    }
    
    
    [self requestDataWithVideoList];
    [self setupWithTableView];
    
    //添加刷新
    [self addRefreshView];
    
    [self setupWithLoading];    //设置进入加载页面
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    
    self.NavigationView.backgroundColor = self.daynightmodel.navigationColor;
    self.tabBarController.tabBar.barTintColor = self.daynightmodel.navigationColor;
    self.view.backgroundColor = self.daynightmodel.navigationColor;
    self.tableview.backgroundColor = self.daynightmodel.navigationColor;
    self.NavigationView.line.layer.borderColor = self.daynightmodel.lineColor.CGColor;
    [self.tableview reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


#pragma mark - 进入时加载页面
- (void)setupWithLoading{
    //加载页面
    self.loadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    self.loadingImageView.image = [UIImage imageNamed:@"LaunchImage.png"];
    
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


#pragma mark - 刷新
- (void)addRefreshView
{
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
}

- (void)refreshAction {
    //数据表页数为1
    page = 1;
    [self requestDataWithVideoList];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview.mj_header endRefreshing];
        [self.tableview reloadData];
    });
}

- (void)loadMoreAction {
    page++;
    //继续请求
    [self requestDataWithVideoList];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview.mj_footer endRefreshing];
        [self.tableview reloadData];
    });
}

#pragma mark - 请求数据
-(void)requestDataWithVideoList{
    NSString *string = [NSString stringWithFormat:@"%@/%d",API_GetVideoList,page];
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    
    [manager GET:string parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            if (page == 1) {
                
                if (isFirstRequest) {
                    NSArray *dataArray = data;
                    for (NSDictionary *d in dataArray) {
                        SurveyListModel *model = [SurveyListModel getInstanceWithDictionary:d];
                        [self.VideoListArray addObject:model];
                    }
                    isFirstRequest = NO;
                }
                else
                {
                    SurveyListModel *mod = self.VideoListArray[0];
                    NSArray *array = data;
                    for (int i=0 ; i<array.count; i++) {
                        NSDictionary *d = array[i];
                        SurveyListModel *model = [SurveyListModel getInstanceWithDictionary:d];
                        if ([model.sharp_wtime intValue] > [mod.sharp_wtime intValue]) {
                            [self.VideoListArray insertObject:model atIndex:i];
                        }
                    }
                }
            }
            else
            {
                NSArray *dataArray = data;
                /* 判断数组是否为空 */
                if ((NSNull *)dataArray != [NSNull null]) {
                    for (NSDictionary *d in dataArray) {
                        SurveyListModel *model = [SurveyListModel getInstanceWithDictionary:d];
                        [self.VideoListArray addObject:model];
                    }
                }
            }
            
            [self.tableview.mj_footer endRefreshing];
            
            [self.loading stopAnimating]; //停止
            self.loadingLabel.alpha = 0.0;
            [self.loadingLabel removeFromSuperview];
            self.loadingImageView.alpha = 0.0;
            [self.loadingImageView removeFromSuperview];
            
            [self.tableview reloadData];//主线程刷新tableview
        } else {
            
        }
    }];
}

#pragma mark - 设置tableview
-(void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-50) style:UITableViewStylePlain];
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
    SearchViewController *searchView = [[SearchViewController alloc] init];
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
    
    SurveyListModel *model = self.VideoListArray[indexPath.row];
    cell.titlelabel.text = model.sharp_title;
    cell.imgview.layer.masksToBounds = YES;
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
    cell.backgroundColor = self.daynightmodel.backColor;
    cell.titlelabel.textColor = self.daynightmodel.textColor;
    cell.backview.backgroundColor = self.daynightmodel.navigationColor;
    cell.titlelabel.backgroundColor = self.daynightmodel.navigationColor;
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
    SharpDetailsViewController *DetailView = [[SharpDetailsViewController alloc] init];
    DetailView.sharp_id = model.sharp_id;
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
