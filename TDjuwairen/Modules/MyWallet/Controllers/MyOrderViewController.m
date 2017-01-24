//
//  MyOrderViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MyOrderViewController.h"
#import "CategoryView.h"
#import "SelOrderBtnView.h"
#import "ChildOrderTableViewController.h"

#import "UIdaynightModel.h"

@interface MyOrderViewController ()<SelOrderBtnViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIdaynightModel *daynightModel;

@property (nonatomic,strong) NSArray *categoryArr;

@property (nonatomic,strong) SelOrderBtnView *selOrderView;

@property (nonatomic,strong) UIScrollView *contentScroll;

@property (nonatomic,strong) NSMutableArray *tableviewsArr;

@property (nonatomic,assign) int tag;

@end

@implementation MyOrderViewController

- (NSArray *)categoryArr{
    if (!_categoryArr) {
        _categoryArr = @[@"全部订单",@"未完成",@"已完成"];
    }
    return _categoryArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightModel = [UIdaynightModel sharedInstance];
    self.tableviewsArr = [NSMutableArray array];
    self.view.backgroundColor = self.daynightModel.navigationColor;
    
    [self setupWithNavigation];
    [self setupWithSelBtnView];
    [self setupWithContentScroll];
    [self addClickViewController];
    
    [self selectOrder:self.selOrderView.selectBtn];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{
    self.title = @"我的订单";
}

- (void)setupWithSelBtnView{
    self.selOrderView = [[SelOrderBtnView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) withArr:self.categoryArr];
    self.selOrderView.delegate = self;
    self.selOrderView.line1.layer.borderColor = self.daynightModel.lineColor.CGColor;
    self.selOrderView.line2.layer.borderColor = self.daynightModel.lineColor.CGColor;
    self.selOrderView.backgroundColor = self.daynightModel.navigationColor;
    [self.view addSubview:self.selOrderView];
}

#pragma mark - 设置内容滑动条
- (void)setupWithContentScroll{
    self.contentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-108)];
    self.contentScroll.delegate = self;
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = NO;
    self.contentScroll.pagingEnabled = YES;
    self.contentScroll.backgroundColor = self.daynightModel.navigationColor;
    
    [self.view addSubview:self.contentScroll];
    self.contentScroll.contentSize = CGSizeMake(kScreenWidth*self.categoryArr.count, kScreenHeight-108);
}

- (void)addClickViewController{
    self.tableviewsArr = [NSMutableArray array];
    for (int i = 0; i<self.categoryArr.count; i++) {
        ChildOrderTableViewController *vc  = [[ChildOrderTableViewController alloc] init];
        
        vc.view.backgroundColor = self.daynightModel.navigationColor;
        
        [self.tableviewsArr addObject:vc];
        [self addChildViewController:vc];
    }
}

#pragma mark - 点击导航条
- (void)selectOrder:(UIButton *)sender
{
    self.selOrderView.selectBtn.selected = NO;
    sender.selected = YES;
    self.selOrderView.selectBtn = sender;
    
    self.selOrderView.selectLab.frame = CGRectMake(sender.frame.origin.x, 38, 70, 2);
    
    NSInteger i = sender.tag;
    CGFloat x = i*kScreenWidth;
    self.tag = (int)i;
    self.contentScroll.contentOffset = CGPointMake(x, 0);
    ChildOrderTableViewController *vc = self.tableviewsArr[self.tag];
    [vc requestWithOrderListAndTag:self.tag];
    
    [self setUpOneChildController:self.tag];
}

#pragma mark - scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger i = self.contentScroll.contentOffset.x / kScreenWidth;
    
    self.selOrderView.selectBtn.selected = NO;
    UIButton *btn = self.selOrderView.btnsArr[i];
    btn.selected = YES;
    self.selOrderView.selectBtn = btn;
    self.selOrderView.selectLab.frame = CGRectMake(70*i, 38, 70, 2);
    
    self.tag = (int)i;
    ChildOrderTableViewController *vc = self.tableviewsArr[self.tag];
    [vc requestWithOrderListAndTag:self.tag];
    [self setUpOneChildController:self.tag];
}

- (void)setUpOneChildController:(NSInteger)index {
    
    CGFloat x  = index * kScreenWidth;
    UIViewController *vc  =  self.childViewControllers[index];
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, kScreenWidth, kScreenHeight-108);
    
    [self.contentScroll addSubview:vc.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
