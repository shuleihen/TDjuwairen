//
//  UserInfoViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "UserInfoViewController.h"
#import "CategoryView.h"
#import "UserInfoHeadView.h"
#import "ChildBlogTableViewController.h"

#import "UIdaynightModel.h"
#import "LoginState.h"
#import "NetworkManager.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,CategoryDeletate>
{
    int num;
}
@property (nonatomic,strong) UIdaynightModel *daynightmodel;

@property (nonatomic,strong) UIView *naviBackView;   //用作navigation背景
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIButton *isAttentionBtn;

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *categoryArr;
@property (nonatomic,strong) NSMutableArray *tableviewsArr;
@property (nonatomic,strong) NSMutableArray *ListenArr;
@property (nonatomic,strong) UIScrollView *contentScrollview;

@property (nonatomic,strong) UserInfoHeadView *headview;
@property (nonatomic,strong) CategoryView *cateview;

@property (nonatomic,strong) NSDictionary *userState;

@end

@implementation UserInfoViewController
- (NSArray *)categoryArr
{
    if (!_categoryArr) {
        _categoryArr = @[@"调研",@"观点",@"评论"];
    }
    return _categoryArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.tableviewsArr = [NSMutableArray array];
    self.ListenArr = [NSMutableArray array];
    self.userState = [NSDictionary dictionary];
    
    [self setupWithNavigation];
    [self setupWithTableView];
    [self addChildViewController];
    
    [self requestDataWithUser];

    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (NSString *string in self.ListenArr) {
        UITableViewController *vc  =  self.childViewControllers[[string intValue]];
        [vc.tableView removeObserver:self forKeyPath:@"contentSize"];
    }
    
    
}

- (void)setupWithNavigation{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.headview = [[UserInfoHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
    [self.headview.headImg sd_setImageWithURL:[NSURL URLWithString:self.facesmall]];
    [self.headview.backImg sd_setImageWithURL:[NSURL URLWithString:self.facesmall]];
    self.headview.nickname.text = self.nickname;
    self.tableview.tableHeaderView = self.headview;
    
    //
    self.naviBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 30, 30)];
    [self.backBtn setImage:[UIImage imageNamed:@"nav_backwhite"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    self.isAttentionBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-15-80, 28, 80, 30)];
    self.isAttentionBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.isAttentionBtn setTitle:@" + 关注" forState:UIControlStateNormal];
    [self.isAttentionBtn setTitle:@"取消关注" forState:UIControlStateSelected];
    [self.isAttentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateSelected];
    [self.isAttentionBtn addTarget:self action:@selector(AttentionUser:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.naviBackView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.isAttentionBtn];
}

- (void)addChildViewController{
    
    self.tableviewsArr = [NSMutableArray array];
    for (int i = 0; i<self.categoryArr.count; i++) {
        ChildBlogTableViewController *childblog  = [[ChildBlogTableViewController alloc] init];
        childblog.title  =  self.categoryArr[i];
        childblog.view.backgroundColor = self.daynightmodel.navigationColor;
        
        [self.tableviewsArr addObject:childblog];
        [self addChildViewController:childblog];
    }
}

#pragma mark - 请求用户信息
- (void)requestDataWithUser{
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:kAPI_bendi];
    NSString *urlString = [NSString stringWithFormat:@"index.php/Blog/index"];
    NSDictionary *dic = @{
                          @"My_user_id":US.userId,
                          @"user_id":self.user_id,
                          };
    [manager POST:urlString parameters:dic completion:^(id data, NSError *error) {
        if (!error) {
            self.userState = data;
            NSString *user_isatten = [NSString stringWithFormat:@"%@",self.userState[@"user_isatten"]];
            if ([user_isatten isEqualToString:@"1"]) {
                self.isAttentionBtn.selected = YES;
            }
            else
            {
                self.isAttentionBtn.selected = NO;
            }
        }
        else
        {
            NSLog(@"%@",error);
        }
     }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (!self.contentScrollview) {
        self.contentScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-190-40)];
        self.contentScrollview.delegate = self;
        self.contentScrollview.showsHorizontalScrollIndicator = NO;
        self.contentScrollview.showsVerticalScrollIndicator = NO;
        self.contentScrollview.pagingEnabled = YES;
        self.contentScrollview.backgroundColor = self.daynightmodel.navigationColor;
        [cell.contentView addSubview:self.contentScrollview];
        self.contentScrollview.contentSize = CGSizeMake(kScreenWidth*self.categoryArr.count, 0);
        [self ClickBtn:self.cateview.selectBtn];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.cateview) {
        self.cateview = [[CategoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) andTitleArr:self.categoryArr];
        self.cateview.delegate = self;
        self.cateview.backgroundColor = self.daynightmodel.navigationColor;
        self.cateview.scrollview.backgroundColor = self.daynightmodel.navigationColor;
        self.cateview.line1.layer.backgroundColor = self.daynightmodel.lineColor.CGColor;
        self.cateview.line2.layer.backgroundColor = self.daynightmodel.lineColor.CGColor;
    }
    return self.cateview;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.contentScrollview.frame.size.height;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableview.contentOffset.y<0) {
        [self.naviBackView setHidden:YES];
    }
    else if (self.tableview.contentOffset.y < 40) {
        [self.backBtn setImage:[UIImage imageNamed:@"nav_backwhite"] forState:UIControlStateNormal];
        [self.isAttentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateSelected];
        self.naviBackView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:self.tableview.contentOffset.y / 120];
    }
    else
    {
        [self.naviBackView setHidden:NO];
        [self.backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [self.isAttentionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal & UIControlStateSelected];
        self.naviBackView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:self.tableview.contentOffset.y / 120];
    }
    
    CGFloat header = 190-64;//这个header其实是section1 的header到顶部的距离
    if (scrollView.contentOffset.y<=header && scrollView.contentOffset.y>=0) {
        //当视图滑动的距离小于header时
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else if(scrollView.contentOffset.y>header)
    {
        scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }
}

#pragma mark - select
- (void)ClickBtn:(UIButton *)sender
{
    self.cateview.selectBtn.selected = NO;
    sender.selected = YES;
    self.cateview.selectBtn = sender;
    
    self.cateview.selectLab.frame = CGRectMake(sender.frame.origin.x, 38, 70, 2);
    
    NSInteger i = sender.tag;
    CGFloat x = i*kScreenWidth;
    num = (int)i;
    self.contentScrollview.contentOffset = CGPointMake(x, 0);
    ChildBlogTableViewController *childBlog = self.tableviewsArr[num];
    [childBlog requestShowList:num WithID:self.user_id];
    
    [self setUpOneChildController:i];
    
    [childBlog.tableView setFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, childBlog.tableView.contentSize.height)];
    self.contentScrollview.contentSize = CGSizeMake(kScreenWidth*self.categoryArr.count, childBlog.tableView.contentSize.height);
    [self.contentScrollview setFrame:CGRectMake(0, 0, kScreenWidth, childBlog.tableView.contentSize.height)];
    [self.tableview reloadData];
}

- (void)setUpOneChildController:(NSInteger)index {
    
    CGFloat x  = index * kScreenWidth;
    UITableViewController *vc  =  self.childViewControllers[index];
    if (vc.view.superview) {
        return;
    }
    [self.ListenArr addObject:[NSString stringWithFormat:@"%ld",(long)index]];
    [vc.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    vc.tableView.frame = CGRectMake(x, 0, kScreenWidth, kScreenHeight-190-40);//50:TabBar高度
    [self.contentScrollview addSubview:vc.view];
    
}

#pragma mark - scrollview 结束滚动时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger i = self.contentScrollview.contentOffset.x / kScreenWidth;
    
    self.cateview.selectBtn.selected = NO;
    UIButton *btn = self.cateview.btnsArr[i];
    btn.selected = YES;
    self.cateview.selectBtn = btn;
    self.cateview.selectLab.frame = CGRectMake(70*i, 38, 70, 2);
    
    num = (int)i;
    ChildBlogTableViewController *childBlog = self.tableviewsArr[num];
    //判断是横向滚动还是竖向滚动
    [childBlog requestShowList:num WithID:self.user_id];
    
    [self setUpOneChildController:i];
    
    [childBlog.tableView setFrame:CGRectMake(num*kScreenWidth, 0, kScreenWidth, childBlog.tableView.contentSize.height)];
    self.contentScrollview.contentSize = CGSizeMake(kScreenWidth*self.categoryArr.count, childBlog.tableView.contentSize.height);
    [self.contentScrollview setFrame:CGRectMake(0, 0, kScreenWidth, childBlog.tableView.contentSize.height)];
    [self.tableview reloadData];
}

- (void)goBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 关注按钮
- (void)AttentionUser:(UIButton *)sender{
    if (sender.selected == YES) {
        sender.selected = NO;
        [self cancelAttention];  //cancelAttention
    }
    else
    {
        sender.selected = YES;
        [self addAttention]; //addAttention
    }
}

#pragma mark - addAttention
- (void)addAttention{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"关注中";
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:kAPI_bendi];
    NSString *urlString = [NSString stringWithFormat:@"index.php/Blog/addAttention"];
    NSDictionary *dic = @{
                          @"My_user_id":US.userId,
                          @"user_id":self.user_id,
                          };
    [manager POST:urlString parameters:dic completion:^(id data, NSError *error) {
        if (!error) {
            hud.labelText = @"已关注";
            [hud hide:YES afterDelay:0.1];
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
}

#pragma mark - cancelAttention
- (void)cancelAttention{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"取消关注";
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:kAPI_bendi];
    NSString *urlString = [NSString stringWithFormat:@"index.php/Blog/cancelAttention"];
    NSDictionary *dic = @{
                          @"My_user_id":US.userId,
                          @"user_id":self.user_id,
                          };
    [manager POST:urlString parameters:dic completion:^(id data, NSError *error) {
        if (!error) {
            hud.labelText = @"已取消";
            [hud hide:YES afterDelay:0.1];
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
}

#pragma mark - tableview contentSize的监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    ChildBlogTableViewController *childBlog = self.tableviewsArr[num];
    [childBlog.tableView setFrame:CGRectMake(num*kScreenWidth, 0, kScreenWidth, childBlog.tableView.contentSize.height)];
    self.contentScrollview.contentSize = CGSizeMake(kScreenWidth*self.categoryArr.count, childBlog.tableView.contentSize.height);
    [self.contentScrollview setFrame:CGRectMake(0, 0, kScreenWidth, childBlog.tableView.contentSize.height)];
    [self.tableview reloadData];
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
