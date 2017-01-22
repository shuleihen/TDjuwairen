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

@interface ViewPointViewController ()<UIScrollViewDelegate,CategoryDeletate,UITableViewDelegate,UITableViewDataSource>
{
    int num;
    CGSize titlesize;
    BOOL isFirstRec;
    BOOL isFirstNew;
    BOOL isFirstSpe;
}
@property (nonatomic,strong) CategoryView *cateview;

@property (nonatomic,strong) UIScrollView *contentScroll;

@property (nonatomic,strong) NSArray *categoryArr;
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) NSMutableArray *tableviewsArr;

@property (nonatomic,assign) int page;
@property (nonatomic,strong) NSMutableArray *viewRecArr;
@property (nonatomic,strong) NSMutableArray *viewNewArr;
@property (nonatomic,strong) NSMutableArray *viewSpeArr;

//进入页面时的加载
@property (nonatomic,strong) UIImageView *loadingImageView;
@property (nonatomic,strong) UIActivityIndicatorView *loading;
@property (nonatomic,strong) UILabel *loadingLabel;


@end

@implementation ViewPointViewController

- (NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSArray *)categoryArr
{
    if (!_categoryArr) {
        //现在只保留一个最新。。需求如此我也表示无奈- -
//        _categoryArr = @[@"推荐",@"最新",@"专题"];
        _categoryArr = @[@"最新"];
    }
    return _categoryArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    num = 0;
    isFirstRec = YES;
    isFirstNew = YES;
    isFirstSpe = YES;
    self.tableviewsArr = [NSMutableArray array];
    self.viewRecArr = [NSMutableArray array];
    self.viewNewArr = [NSMutableArray array];
    self.viewSpeArr = [NSMutableArray array];

    
    [self setupWithNavigation];
//    [self setupWithCategoryScroll];     //设置选择滚动条
    [self setupWithContentScroll];      //设置内容滚动
    [self requestDataWithNumber:num];
    
    [self addRefreshView];           //设置刷新
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 进入时加载页面
- (void)setupWithLoading{
    //加载页面
    self.loadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    self.loadingImageView.image = [UIImage imageNamed:@"LoadingImage"];
    
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

- (void)addRefreshView{
    for (UITableView *table in self.tableviewsArr) {
        table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshActions)];
        table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
    }
}

- (void)refreshActions{
    self.page = 1;
    [self requestDataWithNumber:num];
}

- (void)loadMoreActions{
    [self requestDataWithNumber:num];
}

- (void)requestDataWithNumber:(int)n{

    if (n == 0 && isFirstRec == YES) {
        [self setupWithLoading];   //设置加载页面
        isFirstRec = NO;
    }
    if (n == 1 && isFirstNew == YES) {
        [self setupWithLoading];   //设置加载页面
        isFirstNew = NO;
    }
    if (n == 2 && isFirstSpe == YES) {
        [self setupWithLoading];   //设置加载页面
        isFirstSpe = NO;
    }
    
    __weak ViewPointViewController *wself = self;
    NSString *urlPath;
//    if (n == 0) {
//        urlPath = [NSString stringWithFormat:@"index.php/View/recLists1_2/page/%d",self.page];
//    }
//    else if (n == 1){
        urlPath = [NSString stringWithFormat:@"%@index.php/View/recLists1_2/page/%d",API_HOST,self.page];
//    }
//    else
//    {
//        urlPath = [NSString stringWithFormat:@"%@Subject/newLists1_2/page/%d",kAPI_bendi,self.page];//接口暂无
//    }
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
                
                if (n == 2) {
                    for (NSDictionary *d in dataArray) {
                        SpecialModel *model = [SpecialModel getInstanceWithDictionary:d];
                        [list addObject:model];
                        wself.viewNewArr = [NSMutableArray arrayWithArray:[list sortedArrayUsingSelector:@selector(compare:)]];
                    }
                }
                else
                {
                    for (NSDictionary *d in dataArray) {
                        ViewPointListModel *model = [ViewPointListModel getInstanceWithDictionary:d];
                        [list addObject:model];
                    }
                    wself.viewNewArr = [NSMutableArray arrayWithArray:[list sortedArrayUsingSelector:@selector(compare:)]];
                }
            }
            UITableView *tableview = wself.tableviewsArr[num];
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
            [wself stopLoading];
            wself.page++;
            [tableview reloadData];
        } else {
            UITableView *tableview = wself.tableviewsArr[num];
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
            [wself stopLoading];
        }
    }];
    
}

- (void)setupWithNavigation{
    self.title = @"观点";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

#pragma mark - 设置分类滑动条
- (void)setupWithCategoryScroll{
    self.cateview = [[CategoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 40) andTitleArr:self.categoryArr];
    self.cateview.delegate = self;
    [self.view addSubview:self.cateview];
}

#pragma mark - 设置内容滑动条
- (void)setupWithContentScroll{
    self.contentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44)];
    self.contentScroll.delegate = self;
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = NO;
    self.contentScroll.pagingEnabled = YES;
    [self.view addSubview:self.contentScroll];
    

    for (int i = 0; i<self.categoryArr.count; i++) {
        UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight-64-44) style:UITableViewStylePlain];
        tableview.backgroundColor = TDViewBackgrouondColor;
        tableview.separatorColor = TDSeparatorColor;
        tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
        
        [self.tableviewsArr addObject:tableview];
        [self.contentScroll addSubview:tableview];
    }
    self.contentScroll.contentSize = CGSizeMake(kScreenWidth*self.categoryArr.count, kScreenHeight-104-50);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

//    if (num == 0) {
        return self.viewNewArr.count;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = self.viewNewArr;
    if (tableView == self.tableviewsArr[0] || tableView == self.tableviewsArr[1]) {
        NSString *identifier = @"cell";
        ViewPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ViewPointTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        ViewPointListModel *model = arr[indexPath.row];
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
//        [cell.lineLabel setFrame:CGRectMake(0, 15+25+10+titlesize.height+14, kScreenWidth, 1)];
        
        
//        cell.nicknameLabel.textColor = self.daynightmodel.titleColor;
//        cell.titleLabel.textColor = self.daynightmodel.textColor;
//        cell.backgroundColor = self.daynightmodel.navigationColor;
//        cell.lineLabel.layer.borderColor = self.daynightmodel.lineColor.CGColor;
        return cell;
    }
    else
    {
        NSString *identifier = @"ce";
        ViewSpecialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ViewSpecialTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        SpecialModel *model = arr[indexPath.row];
        cell.titleLabel.text = model.subject_title;
        cell.pageLabel.text = model.subject_tag;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableviewsArr[0] || tableView == self.tableviewsArr[1]) {
        return 15+25+10+titlesize.height+15;
    }
    else
    {
        return kScreenWidth/2+40+10;
    }
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* 取消选中状态 */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.tableviewsArr[0] || tableView == self.tableviewsArr[1]) {
        //跳转到观点详情页
        DetailPageViewController *detail = [[DetailPageViewController alloc]init];
        detail.pageMode = @"view";
        ViewPointListModel *model = self.viewNewArr[indexPath.row];
        detail.view_id = model.view_id;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
}
#pragma mark - 结束滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int x = self.contentScroll.contentOffset.x/kScreenWidth;
    num = x;
    self.cateview.selectBtn.selected = NO;
    UIButton *btn = self.cateview.btnsArr[x];
    btn.selected = YES;
    self.cateview.selectBtn = btn;
    
    self.cateview.selectLab.frame = CGRectMake(70*x, 38, 70, 2);
    
}
#pragma mark - 跳转发布
- (void)GoPublish:(UIButton *)sender{
    if (US.isLogIn == NO) {
        //跳转到登录页面
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.navigationController pushViewController:login animated:YES];
    }
    else
    {
        //跳转到发布页面
        PublishViewViewController *publishview = [[PublishViewViewController alloc] init];
        publishview.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.navigationController pushViewController:publishview animated:YES];
    }
    
}

- (void)GoSearch:(UIButton *)sender{
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
    [self.navigationController pushViewController:searchView animated:YES];
}

//代理点击方法
- (void)ClickBtn:(UIButton *)sender
{
    self.cateview.selectBtn.selected = NO;
    sender.selected = YES;
    self.cateview.selectBtn = sender;
    
    self.cateview.selectLab.frame = CGRectMake(sender.frame.origin.x, 38, 70, 2);
    
    NSInteger i = sender.tag;
    CGFloat x = i*kScreenWidth;
    num = (int)i;
    self.contentScroll.contentOffset = CGPointMake(x, 0);
    [self requestDataWithNumber:num];
}



@end
