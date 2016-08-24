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

#import "UIdaynightModel.h"

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,CategoryDeletate>

@property (nonatomic,strong) UIdaynightModel *daynightmodel;

@property (nonatomic,strong) UIView *naviBackView;   //用作navigation背景

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *categoryArr;

@property (nonatomic,strong) UIView *headerContentView;
@property (nonatomic,strong) UserInfoHeadView *headview;
@property (nonatomic,strong) CategoryView *cateview;

@property (nonatomic,assign) CGFloat headerHeight;
@property (nonatomic,assign) CGFloat scale;//放大比例
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
    
    [self setupWithNavigation];
    [self setupWithTableView];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{
    [self.navigationController setNavigationBarHidden:YES animated:nil];
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.headerContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
    self.headview = [[UserInfoHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
    [self.headerContentView addSubview:self.headview];
    
    self.tableview.tableHeaderView = self.headerContentView;
    
    //
    self.naviBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.naviBackView];
    [self.view addSubview:backBtn];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"天马流星拳";
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.cateview = [[CategoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) andTitleArr:self.categoryArr];
    self.cateview.delegate = self;
    self.cateview.backgroundColor = self.daynightmodel.navigationColor;
    self.cateview.scrollview.backgroundColor = self.daynightmodel.navigationColor;
    self.cateview.line1.layer.backgroundColor = self.daynightmodel.lineColor.CGColor;
    self.cateview.line2.layer.backgroundColor = self.daynightmodel.lineColor.CGColor;
    return self.cateview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableview.contentOffset.y<0) {
        [self.naviBackView setHidden:YES];
//        //放大比例
//        CGFloat offset_Y = scrollView.contentOffset.y;
//        self.headerHeight = 190;
//        CGFloat add_topHeight = -(offset_Y+20);
//        self.scale = (self.headerHeight+add_topHeight)/self.headerHeight;
//        //改变 frame
//        CGRect contentView_frame = CGRectMake(0, -add_topHeight, kScreenWidth, self.headerHeight+add_topHeight);
//        self.headerContentView.frame = contentView_frame;
//        CGRect imageView_frame = CGRectMake(
//                                            -(kScreenWidth*self.scale-kScreenWidth)/2.0f,
//                                            -add_topHeight,
//                                            kScreenWidth*self.scale,
//                                            self.headerHeight+add_topHeight);
//        self.headview.frame = imageView_frame;
    }
    else
    {
        [self.naviBackView setHidden:NO];
        self.naviBackView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:self.tableview.contentOffset.y / 190];
    }
}

- (void)ClickBtn:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
}

- (void)goBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
