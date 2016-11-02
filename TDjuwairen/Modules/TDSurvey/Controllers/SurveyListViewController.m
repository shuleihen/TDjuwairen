//
//  SurveyListViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/10/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyListViewController.h"
#import "SurveyListNavView.h"
#import "SurveyListTableViewCell.h"
#import "PersonalCenterViewController.h"

#import "UIdaynightModel.h"
#import "LoginState.h"

#import "SDCycleScrollView.h"
#import "UIButton+WebCache.h"
#import "NetworkManager.h"

@interface SurveyListViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{
    CGFloat _scalef;  //实时横向位移
}

@property (nonatomic,strong) NSMutableArray *scrollImageArray;  //轮播图片数据
@property (nonatomic,strong) NSMutableArray *scrollTitleArray;  //轮播标题数据
@property (nonatomic,strong) NSMutableArray *scrollIDArray;   //轮播链接数据

@property (nonatomic,assign) CGFloat speedf;

@property (nonatomic,strong) SurveyListNavView *naviView;

@property (nonatomic,strong) PersonalCenterViewController *personal;

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) UIdaynightModel *daynightmodel;

@end

@implementation SurveyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.speedf = 0.5;
    
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
    
    [self setupWithNavigation];
    [self setupWithTableView];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.naviView.backgroundColor = self.daynightmodel.navigationColor;
    [self.naviView.searchBtn setBackgroundColor:self.daynightmodel.inputColor];
    self.naviView.searchBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;  //线色
    self.tabBarController.tabBar.barTintColor = self.daynightmodel.navigationColor;
    
    [self.naviView.headImgBtn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"HeadUnLogin"]];
}

- (void)setupWithNavigation{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.naviView = [[SurveyListNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    [self.naviView.headImgBtn addTarget:self action:@selector(clickHeadImg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.naviView];
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-48) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = self.daynightmodel.backColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.estimatedRowHeight = 180;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    [self.tableview registerClass:[SurveyListTableViewCell class] forCellReuseIdentifier:@"listCell"];
    [self.view addSubview:self.tableview];
    
    //设置tableheadview无限轮播
    [self setupWithTableHeaderView];
}

#pragma mark - 设置tableHeaderView无限轮播
- (void)setupWithTableHeaderView{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/5*2) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;//page样式
    cycleScrollView.titlesGroup = self.scrollTitleArray;
    cycleScrollView.imageURLStringsGroup = self.scrollImageArray;
    self.tableview.tableHeaderView = cycleScrollView;
    
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_GetBanner parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            self.scrollImageArray = [NSMutableArray array];
            self.scrollTitleArray = [NSMutableArray array];
            self.scrollIDArray = [NSMutableArray array];
            NSArray *dataArr = data;
            for (NSDictionary *d in dataArr) {
                [self.scrollImageArray addObject:d[@"ad_imgurl"]];
                [self.scrollTitleArray addObject:d[@"ad_title"]];
                [self.scrollIDArray addObject:d[@"ad_link"]];
            }
            
            [self.tableview reloadData];//页面刷新
            cycleScrollView.titlesGroup = self.scrollTitleArray;//设置轮播图片的标题
            cycleScrollView.imageURLStringsGroup = self.scrollImageArray;//设置轮播图片
        } else {
            
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SurveyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    cell.backgroundColor = self.daynightmodel.backColor;
    cell.bgView.backgroundColor = self.daynightmodel.navigationColor;
    return cell;
}

#pragma mark - 点击头像
- (void)clickHeadImg:(UIButton *)sender{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //方式
    transition.subtype = kCATransitionFromLeft; //方向
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    PersonalCenterViewController *personal = [[PersonalCenterViewController alloc] init];
    personal.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personal animated:YES];
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
