//
//  ViewManagerViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/11.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ViewManagerViewController.h"
#import "UIdaynightModel.h"
#import "CategoryView.h"
#import "ChildTableViewController.h"

@interface ViewManagerViewController () <CategoryDeletate,ChildTableViewControllerDelegate,UIScrollViewDelegate>
{
    int num;
}
@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) NSArray *categoryArr;
@property (nonatomic,strong) CategoryView *cateview;

@property (nonatomic,strong) UIScrollView *contentScroll;
@property (nonatomic,strong) NSMutableArray *tableviewsArr;

@property (nonatomic,assign) int page;
@end

@implementation ViewManagerViewController

- (NSArray *)categoryArr
{
    if (!_categoryArr) {
        _categoryArr = @[@"已发布",@"草稿"];
    }
    return _categoryArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.tableviewsArr = [NSMutableArray array];
    
    [self setupWithNavigation];
    [self setupWithCategoryScroll];     //设置选择滚动条
    [self setupWithContentScroll];
    [self addChildViewController];    /** 添加子控制器视图  */
    
    [self ClickBtn:self.cateview.selectBtn];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{
    self.title = @"观点管理";
    //设置navigation背景色
    [self.navigationController.navigationBar setBackgroundColor:self.daynightmodel.navigationColor];
    [self.navigationController.navigationBar setBarTintColor:self.daynightmodel.navigationColor];
}

#pragma mark - 设置分类滑动条
- (void)setupWithCategoryScroll{
    self.cateview = [[CategoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 40) andTitleArr:self.categoryArr];
    self.cateview.delegate = self;
    
    [self.view addSubview:self.cateview];
    
}

#pragma mark - 设置内容滑动条
- (void)setupWithContentScroll{
    self.contentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 41, kScreenWidth, kScreenHeight-104-50)];
    self.contentScroll.delegate = self;
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = NO;
    self.contentScroll.pagingEnabled = YES;
    
    
    [self.view addSubview:self.contentScroll];
    self.contentScroll.contentSize = CGSizeMake(kScreenWidth*self.categoryArr.count, kScreenHeight-104-50);
}

- (void)addChildViewController{
    
    self.tableviewsArr = [NSMutableArray array];
    for (int i = 0; i<self.categoryArr.count; i++) {
        ChildTableViewController *vc  = [[ChildTableViewController alloc] init];
        vc.delegate = self;
        vc.title  =  self.categoryArr[i];
        vc.view.backgroundColor = [UIColor whiteColor];
        
        [self.tableviewsArr addObject:vc];
        [self addChildViewController:vc];
    }
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
    ChildTableViewController *vc = self.tableviewsArr[num];
    [vc requestShowList:num];
    
    [self setUpOneChildController:i];
}

- (void)setUpOneChildController:(NSInteger)index {
    
    CGFloat x  = index * kScreenWidth;
    UIViewController *vc  =  self.childViewControllers[index];
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, kScreenWidth, kScreenHeight-104-50);//50:TabBar高度
    
    [self.contentScroll addSubview:vc.view];
    
}

#pragma mark - scrollview delegate 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger i = self.contentScroll.contentOffset.x / kScreenWidth;
    
    self.cateview.selectBtn.selected = NO;
    UIButton *btn = self.cateview.btnsArr[i];
    btn.selected = YES;
    self.cateview.selectBtn = btn;
    self.cateview.selectLab.frame = CGRectMake(70*i, 38, 70, 2);

    num = (int)i;
    ChildTableViewController *vc = self.tableviewsArr[num];
    [vc requestShowList:num];
    [self setUpOneChildController:i];
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
