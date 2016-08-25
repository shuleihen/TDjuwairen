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

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,CategoryDeletate>
{
    int num;
}
@property (nonatomic,strong) UIdaynightModel *daynightmodel;

@property (nonatomic,strong) UIView *naviBackView;   //用作navigation背景
@property (nonatomic,strong) UIButton *isAttention;

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *categoryArr;
@property (nonatomic,strong) NSMutableArray *tableviewsArr;
@property (nonatomic,strong) UIScrollView *contentScrollview;

@property (nonatomic,strong) UserInfoHeadView *headview;
@property (nonatomic,strong) CategoryView *cateview;

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
    
    [self setupWithNavigation];
    [self setupWithTableView];
    [self addChildViewController];
    
    [self ClickBtn:self.cateview.selectBtn];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{
    [self.navigationController setNavigationBarHidden:YES animated:nil];
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.headview = [[UserInfoHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
    self.tableview.tableHeaderView = self.headview;
    
    //
    self.naviBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    self.isAttention = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-15-80, 28, 80, 30)];
    [self.isAttention setTitle:@"关注" forState:UIControlStateNormal];
    
    
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.naviBackView];
    [self.view addSubview:backBtn];
    [self.view addSubview:self.isAttention];
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
    else
    {
        [self.naviBackView setHidden:NO];
        self.naviBackView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:self.tableview.contentOffset.y / 190];
    }
}

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
//    [childBlog requestShowList:num];
    
    [self setUpOneChildController:i];
    
    [childBlog.tableView setFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, childBlog.tableView.contentSize.height)];
    self.contentScrollview.contentSize = CGSizeMake(kScreenWidth*self.categoryArr.count, childBlog.tableView.contentSize.height);
    [self.contentScrollview setFrame:CGRectMake(0, 0, kScreenWidth, childBlog.tableView.contentSize.height)];
    [childBlog.tableView reloadData];
    [self.tableview reloadData];
}

- (void)setUpOneChildController:(NSInteger)index {
    
    CGFloat x  = index * kScreenWidth;
    UITableViewController *vc  =  self.childViewControllers[index];
    if (vc.view.superview) {
        return;
    }
    vc.tableView.frame = CGRectMake(x, 0, kScreenWidth, kScreenHeight-190-40);//50:TabBar高度
    
    [self.contentScrollview addSubview:vc.view];
    
}

#pragma mark - scrollview delegate
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
//    [childblog requestShowList:num];
    [self setUpOneChildController:i];
    
    [childBlog.tableView setFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, childBlog.tableView.contentSize.height)];
    self.contentScrollview.contentSize = CGSizeMake(kScreenWidth*self.categoryArr.count, childBlog.tableView.contentSize.height);
    [self.contentScrollview setFrame:CGRectMake(0, 0, kScreenWidth, childBlog.tableView.contentSize.height)];
    [childBlog.tableView reloadData];
    [self.tableview reloadData];
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
