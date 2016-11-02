//
//  SurveyListViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/10/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyListViewController.h"
#import "SurveyListNavView.h"
#import "PersonalCenterViewController.h"

#import "UIdaynightModel.h"
#import "LoginState.h"

#import "UIButton+WebCache.h"

@interface SurveyListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _scalef;  //实时横向位移
}
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
    [self.view addSubview:self.tableview];
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
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"哔哩哔哩";
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
