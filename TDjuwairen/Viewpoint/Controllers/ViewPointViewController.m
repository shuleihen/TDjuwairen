//
//  ViewPointViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/25.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ViewPointViewController.h"
#import "CategoryView.h"
#import "NetworkManager.h"
#import "ViewPointListModel.h"
#import "SpecialModel.h"
#import "ViewPointTableViewCell.h"
#import "ViewSpecialTableViewCell.h"
#import "DescContentViewController.h"

#import "NSString+Ext.h"
#import "UIImageView+WebCache.h"
#import "NetworkManager.h"
#import "MJRefresh.h"

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
@property (nonatomic,strong) NSArray *dataArr;

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
        _categoryArr = @[@"推荐",@"最新",@"专题"];
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
    self.dataArr = @[self.viewRecArr,self.viewNewArr,self.viewSpeArr];
    [self setupWithNavigation];
    [self setupWithCategoryScroll];     //设置选择滚动条
    [self setupWithContentScroll];      //设置内容滚动
    [self requestDataWithNumber:num];
    
    [self addRefreshView];           //设置刷新
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 进入时加载页面
- (void)setupWithLoading{
    //加载页面
    self.loadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight-64)];
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

- (void)addRefreshView{
    for (UITableView *table in self.tableviewsArr) {
        table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
        table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    }
}

- (void)refreshAction {
    //数据表页数为1
    self.page = 1;
    [self requestDataWithNumber:num];
}

- (void)loadMoreAction {
    self.page++;
    //继续请求
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
    if (n == 0) {
        urlPath = [NSString stringWithFormat:@"index.php/View/recLists1_2/page/%d",self.page];
    }
    else if (n == 1){
        urlPath = [NSString stringWithFormat:@"index.php/View/newLists1_2/page/%d",self.page];
    }
    else
    {
        urlPath = [NSString stringWithFormat:@"http://192.168.1.100/tuanda_web/Appapi/index.php/Subject/newLists1_2/page/%d",self.page];//接口暂无
    }
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:urlPath parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            NSArray *dataArray = data;
            if (dataArray.count > 0) {
                NSMutableArray *list = nil;

                if (wself.page == 1) {
                    list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                } else {
                    list = [NSMutableArray arrayWithArray:wself.dataArr[num]];
                }
                NSMutableArray *arr = wself.dataArr[num];
                
                if (n == 2) {
                    for (NSDictionary *d in dataArray) {
                        SpecialModel *model = [SpecialModel getInstanceWithDictionary:d];
                        [list addObject:model];
                        [arr addObject:model];
                    }
                }
                else
                {
                    for (NSDictionary *d in dataArray) {
                        ViewPointListModel *model = [ViewPointListModel getInstanceWithDictionary:d];
                        [list addObject:model];
                        [arr addObject:model];
                    }
                }
            }
            UITableView *tableview = wself.tableviewsArr[num];
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
            [wself stopLoading];
            [tableview reloadData];
        } else {
            NSLog(@"请求失败");
            UITableView *tableview = wself.tableviewsArr[num];
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
            [wself stopLoading];
        }
    }];
    
}

- (void)setupWithNavigation{
    self.edgesForExtendedLayout = UIRectEdgeNone;    //iOS7及以后的版本支持，self.view.frame.origin.y会下移64像素至navigationBar下方
    //设置navigation背景色
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"观点";
    // 设置标题颜色，和大小,如果标题是使用titleView方式定义不行
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];

    UIButton*publish = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [publish setImage:[UIImage imageNamed:@"nav_publish@3x.png"] forState:UIControlStateNormal];
    [publish addTarget:self action:@selector(GoPublish:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:publish];
    
    UIButton*search = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [search setImage:[UIImage imageNamed:@"nav_search@3x.png"] forState:UIControlStateNormal];
    [search addTarget:self action:@selector(GoSearch:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:search];
    
    self.navigationItem.rightBarButtonItems = @[rightItem1,rightItem2];
    
    //设置返回button
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    
    [backItem setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage* image = [UIImage imageNamed:@"back"];
    [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 60, 0, 10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
}

#pragma mark - 设置分类滑动条
- (void)setupWithCategoryScroll{
    self.cateview = [[CategoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 40) andTitleArr:self.categoryArr];
    self.cateview.delegate = self;
    [self.view addSubview:self.cateview];
    
}

#pragma mark - 设置内容滑动条
- (void)setupWithContentScroll{
    self.contentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 41, kScreenWidth, kScreenHeight-64-64)];
    self.contentScroll.delegate = self;
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = NO;
    self.contentScroll.pagingEnabled = YES;
    [self.view addSubview:self.contentScroll];
    

    for (int i = 0; i<self.categoryArr.count; i++) {
        UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight-64-64) style:UITableViewStylePlain];
        tableview.delegate = self;
        tableview.dataSource = self;

        [self.tableviewsArr addObject:tableview];
        [self.contentScroll addSubview:tableview];
    }
    self.contentScroll.contentSize = CGSizeMake(kScreenWidth*self.categoryArr.count, kScreenHeight-64-64);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arr = self.dataArr[num];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSMutableArray *arr = self.dataArr[num];
    if (tableView == self.tableviewsArr[0] || tableView == self.tableviewsArr[1]) {
        NSString *identifier = @"cell";
        ViewPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ViewPointTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        ViewPointListModel *model = arr[indexPath.row];
//        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:model.user_facemin]];
        NSString *isoriginal;
        if ([model.view_isoriginal isEqualToString:@"0"]) {
            isoriginal = @"转载";
        }else
        {
            isoriginal = @"原创";
        }
        cell.nicknameLabel.text = [NSString stringWithFormat:@"%@  %@  %@",model.user_nickname,model.view_wtime,isoriginal];

        UIFont *font = [UIFont systemFontOfSize:16];
        cell.titleLabel.font = font;
        cell.titleLabel.numberOfLines = 0;
        titlesize = CGSizeMake(kScreenWidth-30, 500.0);
        titlesize = [model.view_title calculateSize:titlesize font:font];
        cell.titleLabel.text = model.view_title;
        [cell.titleLabel setFrame:CGRectMake(15, 15+25+10, kScreenWidth-30, titlesize.height)];
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
        DescContentViewController *dc = [self.storyboard instantiateViewControllerWithIdentifier:@"viewDesc"];
        [self.navigationController pushViewController:dc animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int x = self.contentScroll.contentOffset.x/kScreenWidth;
    num = x;
    self.cateview.selectBtn.selected = NO;
    UIButton *btn = self.cateview.btnsArr[x];
    btn.selected = YES;
    self.cateview.selectBtn = btn;
    
    self.cateview.selectLab.frame = CGRectMake(70*x, 38, 70, 2);
    [self requestDataWithNumber:num];
    
}

- (void)GoPublish:(UIButton *)sender{
    
}

- (void)GoSearch:(UIButton *)sender{
    
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
