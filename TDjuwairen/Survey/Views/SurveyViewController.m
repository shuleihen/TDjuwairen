//
//  SurveyViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/11.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyViewController.h"
#import "SDCycleScrollView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "NSString+TimeInfo.h"
#import "NSString+Ext.h"

#import "SurveyNavigationView.h"
#import "SurveyTableViewCell.h"
#import "NewTableViewCell.h"
#import "SurveyListModel.h"
#import "SharpDetailsViewController.h"
#import "SearchViewController.h"
#import "UIdaynightModel.h"

/* 登录状态 */
#import "LoginState.h"

#import "MJRefresh.h"
#import "NetworkManager.h"
#import "Masonry.h"

@interface SurveyViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UIAlertViewDelegate>
{    
    CGSize titlesize;
    CGSize descsize;
    BOOL isFirstRequest;
    NSString *trackViewUrl;
    
}

@property (nonatomic,strong) NSMutableArray *scrollImageArray;  //轮播图片数据
@property (nonatomic,strong) NSMutableArray *scrollTitleArray;  //轮播标题数据
@property (nonatomic,strong) NSMutableArray *scrollIDArray;   //轮播链接数据
@property (nonatomic,strong) NSMutableArray *surveyListDataArray;//文章列表数据

@property (nonatomic,strong) UITableView *tableview; //创建tableview
@property (nonatomic,strong) UIRefreshControl *refresh;//创建下拉刷新

@property (nonatomic,strong) SurveyNavigationView *NavigationView;    //自定义navigation

@property (nonatomic,strong) LoginState *loginstate;

@property (nonatomic,strong) UIdaynightModel *daynightmodel;

//进入页面时的加载
@property (nonatomic,strong) UIImageView *loadingImageView;
@property (nonatomic,strong) UIActivityIndicatorView *loading;
@property (nonatomic,strong) UILabel *loadingLabel;

@property (nonatomic, assign) int page;
@end

@implementation SurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

/*    FIXME: @fql didLoad 规范 参考 detailController
    - (void)setupUICommon;
    - (void)setupTableView;
    - (void)loadRequest;
 */
//    [self judgeAPPVersion];
    self.loginstate = [LoginState addInstance];
    self.page = 1;
    isFirstRequest = YES;
    self.surveyListDataArray = [NSMutableArray array];
    
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
    
    [self requestToLogin];
    
    [self requestDataWithSurveyList];//请求调研列表数据
    
    [self setupWithTableView];       //设置tableview
    
    [self addRefreshView];           //设置刷新
    
    // Do any additional setup after loading the view.
    
    [self setupWithLoading];   //设置加载页面
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    self.NavigationView.backgroundColor = self.daynightmodel.navigationColor;
    
    self.tabBarController.tabBar.barTintColor = self.daynightmodel.navigationColor;
    
    self.tableview.backgroundColor = self.daynightmodel.navigationColor;
    
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

- (void)stopLoading {
    [self.loading stopAnimating]; //停止
    self.loadingLabel.alpha = 0.0;
    [self.loadingLabel removeFromSuperview];
    self.loadingImageView.alpha = 0.0;
    [self.loadingImageView removeFromSuperview];
}

#pragma mark - 添加刷新
- (void)addRefreshView {

    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
}

- (void)refreshAction {
    //数据表页数为1
    self.page = 1;
    [self requestDataWithSurveyList];
}

- (void)loadMoreAction {
    self.page++;
    //继续请求
    [self requestDataWithSurveyList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求调研列表数据
-(void)requestDataWithSurveyList{
    __weak SurveyViewController *wself = self;
    // @fql 这里可以不用 weak 类型，在下面的block里面直接使用self，不会造成循环引用
    /*
    NSString *urlPath = [NSString stringWithFormat:@"index.php/Sharp/surveyList/page/%d",self.page];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:urlPath parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            NSArray *dataArray = data;

            if (dataArray.count > 0) {
            NSMutableArray *list = nil;
            if (wself.page == 1) {
            list = [NSMutableArray arrayWithCapacity:[dataArray count]];
            } else {
            list = [NSMutableArray arrayWithArray:wself.surveyListDataArray];
            }

            for (NSDictionary *d in dataArray) {
            SurveyListModel *model = [SurveyListModel getInstanceWithDictionary:d];
            [list addObject:model];
            }

            wself.surveyListDataArray = [NSMutableArray arrayWithArray:[list sortedArrayUsingSelector:@selector(compare:)]];
            }

            [wself.tableview.mj_header endRefreshing];
            [wself.tableview.mj_footer endRefreshing];
            [wself stopLoading];
            [wself.tableview reloadData];
        } else {
            [wself stopLoading];
            [wself.tableview.mj_header endRefreshing];
            [wself.tableview.mj_footer endRefreshing];
        }
    }];
    */
    
    NSString *string = [NSString stringWithFormat:@"%@index.php/Sharp/surveyList/page/%d",API_HOST,self.page];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //如果当前请求的是第一页，就清空文章列表数组
        NSArray *dataArray = responseObject[@"data"];
        
        if (dataArray.count > 0) {
            NSMutableArray *list = nil;
            if (wself.page == 1) {
                list = [NSMutableArray arrayWithCapacity:[dataArray count]];
            } else {
                list = [NSMutableArray arrayWithArray:wself.surveyListDataArray];
            }
            
            for (NSDictionary *d in dataArray) {
                SurveyListModel *model = [SurveyListModel getInstanceWithDictionary:d];
                [list addObject:model];
            }
            
            wself.surveyListDataArray = [NSMutableArray arrayWithArray:[list sortedArrayUsingSelector:@selector(compare:)]];
        }
        
        [wself.tableview.mj_header endRefreshing];
        [wself.tableview.mj_footer endRefreshing];
        [wself stopLoading];
        [wself.tableview reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [wself stopLoading];
        [wself.tableview.mj_header endRefreshing];
        [wself.tableview.mj_footer endRefreshing];
    }];
}

#pragma mark - 设置tableview
- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-50) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    
    
//    FIXME: @fql 自定义nav单独放到一个方法在添加，在UICommon方法中调用，没一个独立的试图创建和设置，都单独创建一个方法
    self.NavigationView = [[SurveyNavigationView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    [self.NavigationView.searchButton addTarget:self action:@selector(ClickSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    //取消分割线
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableview];//先添加tableview
    [self.view addSubview:self.NavigationView];  //自定义导航栏放在页面最上层
    
    //设置tableheadview无限轮播
    [self setupWithTableHeaderView];
}

#pragma mark - 设置tableHeaderView无限轮播
- (void)setupWithTableHeaderView{
    //FIXME: @fql setupWithTableHeaderView 方法只在didload中调用一次，如果第一次加载失败，后面就一直不会显示
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/4) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;//page样式
    cycleScrollView.titlesGroup = self.scrollTitleArray;
    cycleScrollView.imageURLStringsGroup = self.scrollImageArray;
    self.tableview.tableHeaderView = cycleScrollView;
    //    cycleScrollView.autoScrollTimeInterval = 2.0;// 滚动时间为两秒一张
    //185534916
    //请求轮播数据
    NSString *string = @"http://appapi.juwairen.net/index.php/Index/indexBanner";
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            self.scrollImageArray = [NSMutableArray array];
            self.scrollTitleArray = [NSMutableArray array];
            self.scrollIDArray = [NSMutableArray array];
            NSArray *dataArr = responseObject[@"data"];
            for (NSDictionary *d in dataArr) {
                [self.scrollImageArray addObject:d[@"ad_imgurl"]];
                [self.scrollTitleArray addObject:d[@"ad_title"]];
                [self.scrollIDArray addObject:d[@"ad_link"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableview reloadData];//页面刷新
                cycleScrollView.titlesGroup = self.scrollTitleArray;//设置轮播图片的标题
                cycleScrollView.imageURLStringsGroup = self.scrollImageArray;//设置轮播图片
            });
        }
        else
        {
            NSLog(@"code == 400");
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络出错!");
    }];
}

#pragma mark - create tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.surveyListDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView registerNib:[UINib nibWithNibName:@"NewTableViewCell" bundle:nil] forCellReuseIdentifier:@"newcell"];
    NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newcell"];
    if (cell == nil) {
        cell = [[NewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newcell"];
    }
    SurveyListModel *model = self.surveyListDataArray[indexPath.row];
    
    [cell.userHead sd_setImageWithURL:[NSURL URLWithString:model.user_facemin]];
    
    NSString *currenttime = [NSString prettyDateWithReference:model.sharp_wtime];
    cell.nickname.text = [NSString stringWithFormat:@"%@ · %@",model.user_nickname,currenttime];
    
    NSString *text = model.sharp_title;
    
    UIFont *font = [UIFont systemFontOfSize:16];
    cell.titleLabel.font = font;
    cell.titleLabel.numberOfLines = 0;
    titlesize = CGSizeMake(kScreenWidth-16-90-15, 20000.0f);
    titlesize = [text calculateSize:titlesize font:font];
    cell.titleLabel.text = text;
    [cell.titleLabel setFrame:CGRectMake(15, 55, kScreenWidth-16-90-15, titlesize.height)];
    cell.descLabel.frame = CGRectMake(15, 55+titlesize.height+10, kScreenWidth-16-90-15, 55);
    cell.descLabel.font = [UIFont systemFontOfSize:14];
    cell.descLabel.numberOfLines = 3;
    cell.descLabel.text = model.sharp_desc;
    cell.descLabel.textColor = [UIColor grayColor];
    
    cell.titleimg.frame = CGRectMake(kScreenWidth-8-90, 15+25+15, 90, 90);
    [cell.titleimg sd_setImageWithURL:[NSURL URLWithString:model.sharp_imgurl]];
    
    cell.lineLabel.frame = CGRectMake(0, 15+25+15+titlesize.height+10+55+17, kScreenWidth, 0.5);
    
    cell.nickname.textColor = self.daynightmodel.titleColor;
    cell.titleLabel.textColor = self.daynightmodel.textColor;
    cell.descLabel.textColor = self.daynightmodel.titleColor;
    cell.backgroundColor = self.daynightmodel.navigationColor;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 15+25+15+titlesize.height+10+55+18;
}

#pragma mark - 点击搜索
// FIXME: 方法名和变量命名首字母小写
- (void)ClickSearchButton:(UIButton *)sender{
    SearchViewController *searchView = [self.storyboard instantiateViewControllerWithIdentifier:@"searchview"];
    
    [self.navigationController pushViewController:searchView animated:YES];
}

#pragma mark - 点击图片
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //跳转到详情页
    SharpDetailsViewController *DetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    NSString *s = self.scrollIDArray[index];
    NSArray *arr = [s componentsSeparatedByString:@"/"];
    DetailView.sharp_id = [arr lastObject];
    DetailView.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
    
    if (self.loginstate.isLogIn) {     //为登录状态
        //添加浏览记录
        NSString *strurl = [NSString stringWithFormat:@"%@index.php/Public/addBrowseHistory",API_HOST];
        NSDictionary *dic = @{@"userid":self.loginstate.userId,@"module_id":@2,@"item_id":self.scrollIDArray[index]};
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:strurl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"code"] intValue] == 200) {
                NSLog(@"添加成功");
            }
            else
            {
                NSLog(@"添加失败");
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败");
        }];
    }
    
    [self.navigationController pushViewController:DetailView animated:YES];
}

#pragma mark - 点击文章
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* 取消选中状态 */
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    
    SurveyListModel *model = self.surveyListDataArray[indexPath.row];
    SharpDetailsViewController *DetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    DetailView.sharp_id = model.sharp_id;
    DetailView.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
    
    
    if (self.loginstate.isLogIn) {     //为登录状态
        //添加浏览记录
        NSString *strurl = [NSString stringWithFormat:@"%@index.php/Public/addBrowseHistory",API_HOST];
        NSDictionary *dic = @{@"userid":self.loginstate.userId,@"module_id":@2,@"item_id":model.sharp_id};
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:strurl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"code"] intValue] == 200) {
                NSLog(@"添加成功");
            }
            else
            {
                NSLog(@"添加失败");
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败");
        }];
    }
    
    //    [self presentViewController:DetailView animated:YES completion:nil];
    [self.navigationController pushViewController:DetailView animated:YES];
}


- (void)requestToLogin{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *loginStyle = [user objectForKey:@"loginStyle"];
    NSLog(@"loginStyle is :---%@",loginStyle);
    if ([loginStyle isEqualToString:@"QQlogin"]) {
        NSString *openid = [user objectForKey:@"openid"];
        NSDictionary *dic = @{@"openid":openid};
        NSString *url = [NSString stringWithFormat:@"%@Login/checkQQAccount1_2",kAPI_bendi];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dic = responseObject[@"data"];
            self.loginstate.userId=dic[@"user_id"];
            self.loginstate.userName=dic[@"user_name"];
            self.loginstate.nickName=dic[@"user_nickname"];
            self.loginstate.userPhone=dic[@"userinfo_phone"];
            self.loginstate.headImage=dic[@"userinfo_facesmall"];
            self.loginstate.company=dic[@"userinfo_company"];
            self.loginstate.post=dic[@"userinfo_occupation"];
            self.loginstate.personal=dic[@"userinfo_info"];
            
            self.loginstate.isLogIn=YES;
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"QQ登录失败");
        }];
    }
    else if ([loginStyle isEqualToString:@"WXlogin"]){
        NSString *unionid = [user objectForKey:@"unionid"];
        NSDictionary *dic = @{@"unionid":unionid};
        NSString *url = [NSString stringWithFormat:@"%@Login/checkWXAccount1_2",kAPI_bendi];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:url parameters:dic
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        self.loginstate.userId=dic[@"user_id"];
        self.loginstate.userName=dic[@"user_name"];
        self.loginstate.nickName=dic[@"user_nickname"];
        self.loginstate.userPhone=dic[@"userinfo_phone"];
        self.loginstate.headImage=dic[@"userinfo_facesmall"];
        self.loginstate.company=dic[@"userinfo_company"];
        self.loginstate.post=dic[@"userinfo_occupation"];
        self.loginstate.personal=dic[@"userinfo_info"];
        
        self.loginstate.isLogIn=YES;
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"微信登录失败");
    }];
    }
    else if([loginStyle isEqualToString:@"normal"])
    {
        NSString *account = [user objectForKey:@"account"];
        NSString *password = [user objectForKey:@"password"];
        if (account != nil ) {
            AFHTTPRequestOperationManager*manager=[[AFHTTPRequestOperationManager alloc]init];
            manager.responseSerializer = [AFJSONResponseSerializer  serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/Login/loginDo/"];
            NSDictionary*paras=@{@"account":account,
                                 @"password":password};
            
            [manager POST:url parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString*code=[responseObject objectForKey:@"code"];
                if ([code isEqualToString:@"200"]) {
                    NSLog(@"登陆成功");
                    
                    NSDictionary *dic = responseObject[@"data"];
                    self.loginstate.userId=dic[@"user_id"];
                    self.loginstate.userName=dic[@"user_name"];
                    self.loginstate.nickName=dic[@"user_nickname"];
                    self.loginstate.userPhone=dic[@"userinfo_phone"];
                    self.loginstate.headImage=dic[@"userinfo_facesmall"];
                    self.loginstate.company=dic[@"userinfo_company"];
                    self.loginstate.post=dic[@"userinfo_occupation"];
                    self.loginstate.personal=dic[@"userinfo_info"];
                    
                    self.loginstate.isLogIn=YES;
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"请求失败");
            }];
        }
    }
    
}

#pragma mark - detection
- (void)judgeAPPVersion{
    
    NSString *urlStr = @"https://itunes.apple.com/lookup?id=1125295972";
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer = [AFJSONResponseSerializer  serializer];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *data = (NSDictionary *)responseObject;
        NSArray *infoContent = [data objectForKey:@"results"];
        //商店版本
        NSString *newversion = [[infoContent objectAtIndex:0] objectForKey:@"version"];
        
        //当前版本
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        
        trackViewUrl = [[infoContent objectAtIndex:0] objectForKey:@"trackViewUrl"];
        if (![newversion isEqualToString:currentVersion]) {
            //判断当前设备版本
            float iOSVersion = [[UIDevice currentDevice].systemVersion floatValue];
            if (iOSVersion < 8.0f) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前有新版本了哟" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [alert addButtonWithTitle:@"确定"];
                [alert show];
            }
            else
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前有新版本了哟" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //跳转到商店
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *titleString = [alertView buttonTitleAtIndex:buttonIndex];
    if ([titleString isEqualToString:@"确定"]) {
        //跳转到商店
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
    }
}

@end
