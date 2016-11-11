//
//  SurDetailViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurDetailViewController.h"
#import "SurDataView.h"
#import "SurDetailSelBtnView.h"
#import "ChildDetailTableViewController.h"

#import "UIdaynightModel.h"
#import "Masonry.h"

@interface SurDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SurDetailSelBtnViewDelegate,ChildDetailDelegate>
{
    CGSize contentSize;
}
@property (nonatomic,assign) int tag;

@property (nonatomic,strong) UIdaynightModel *daynightModel;

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) SurDataView *dataView;

@property (nonatomic,strong) SurDetailSelBtnView *selBtnView;

@property (nonatomic,strong) NSMutableArray *tableviewsArr;

@property (nonatomic,strong) UIScrollView *contentScrollview;

@property (nonatomic,strong) UIButton *comBtn;

@end

@implementation SurDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightModel = [UIdaynightModel sharedInstance];
    contentSize.height = kScreenHeight-64-60;
    self.tag = 0;
    
    [self setupWithNavigation];
    [self setupWithTableView];
    [self setupWithDateView];
    [self addChildViewController];
    
    [self setupWithCommentBtn];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = self.company_name;
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.estimatedRowHeight = kScreenHeight-64-60;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    self.tableview.backgroundColor = self.daynightModel.navigationColor;
    self.tableview.contentSize = CGSizeMake(kScreenWidth, kScreenHeight*5);
    [self.view addSubview:self.tableview];
}

- (void)setupWithDateView{
    self.dataView = [[SurDataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140) WithStockID:@"sz000001"];
    self.dataView.backgroundColor = self.daynightModel.navigationColor;
    self.dataView.yestodEndPri.textColor = self.daynightModel.titleColor;
    self.dataView.todayStartPri.textColor = self.daynightModel.titleColor;
    self.dataView.todayMax.textColor = self.daynightModel.titleColor;
    self.dataView.todayMin.textColor = self.daynightModel.titleColor;
    self.dataView.traNumber.textColor = self.daynightModel.titleColor;
    self.dataView.traAmount.textColor = self.daynightModel.titleColor;
    self.tableview.tableHeaderView = self.dataView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.selBtnView = [[SurDetailSelBtnView alloc] initWithFrame:CGRectMake(0, 140, kScreenWidth, 60) WithStockCode:self.company_code];
    
    UIButton *btn = self.selBtnView.btnsArr[self.tag];
    self.selBtnView.selBtn.selected = NO;
    btn.selected = YES;
    self.selBtnView.selBtn = btn;
    
    self.selBtnView.delegate = self;
    self.selBtnView.backgroundColor = self.daynightModel.navigationColor;
    return self.selBtnView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (!self.contentScrollview) {
        self.contentScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-60)];
        self.contentScrollview.delegate = self;
        self.contentScrollview.showsHorizontalScrollIndicator = NO;
        self.contentScrollview.showsVerticalScrollIndicator = NO;
        self.contentScrollview.pagingEnabled = YES;
        self.contentScrollview.backgroundColor = self.daynightModel.navigationColor;
        [cell.contentView addSubview:self.contentScrollview];
        
//        [self.contentScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(cell.contentView).with.offset(0);
//            make.left.equalTo(cell.contentView).with.offset(0);
//            make.bottom.equalTo(cell.contentView).with.offset(0);
//            make.width.mas_equalTo(kScreenWidth);
//            make.height.mas_equalTo(kScreenHeight-64-60);
//        }];
        
        self.contentScrollview.contentSize = CGSizeMake(kScreenWidth*6, 0);
        [self selectWithDetail:self.selBtnView.selBtn];
        self.tag = 0;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeight-64-60;
}

- (void)addChildViewController{
    self.tableviewsArr = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        ChildDetailTableViewController *childView = [[ChildDetailTableViewController alloc] init];
        childView.delegate = self;
        [self.tableviewsArr addObject:childView];
        [self addChildViewController:childView];
    }
}

#pragma mark - SurDetailSelBtnView Delegate   点击选择
- (void)selectWithDetail:(UIButton *)sender
{
    self.selBtnView.selBtn.selected = NO;
    sender.selected = YES;
    self.selBtnView.selBtn = sender;
    
    NSInteger i = sender.tag;
    self.tag = (int)i;
    if (i == 2) {
        self.comBtn.alpha = 1.0;
    }
    else
    {
        self.comBtn.alpha = 0.0;
    }
    CGFloat x = i * kScreenWidth;
    self.contentScrollview.contentOffset = CGPointMake(x, 0);
    ChildDetailTableViewController *childView = self.tableviewsArr[i];
    [self setUpOneChildController:i];
    [childView requestWithSelBtn:(int)i WithSurveyID:self.company_code];
}

- (void)setUpOneChildController:(NSInteger)index {
    CGFloat x  = index * kScreenWidth;
    ChildDetailTableViewController *vc  =  self.childViewControllers[index];
    if (vc.view.superview) {
        return;
    }
    vc.tableView.frame = CGRectMake(x, 0, kScreenWidth, kScreenHeight-64-60);
    [self.contentScrollview addSubview:vc.view];
}

#pragma mark - 设置隐藏评论按钮
- (void)setupWithCommentBtn{
    self.comBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight-64-50, kScreenWidth, 50)];
    [self.comBtn setBackgroundColor:self.daynightModel.navigationColor];
    [self.comBtn setTitle:@" 评论" forState:UIControlStateNormal];
    [self.comBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.comBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -15)];
    
    UIImageView *comImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.comBtn.titleLabel.frame.origin.x - 40, (50-15)/2, 20, 20)];
    comImg.image = [UIImage imageNamed:@"comment_blue"];
    [self.comBtn addSubview:comImg];
    self.comBtn.alpha = 0.0;
    [self.view addSubview:self.comBtn];
}

#pragma mark - 滑动操作
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSString *rollway = [NSString stringWithFormat:@"%@",[scrollView class]];
    NSLog(@"%@",rollway);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSString *rollway = [NSString stringWithFormat:@"%@",[scrollView class]];
    if ([rollway isEqualToString:@"UIScrollView"]) {
        NSInteger i = self.contentScrollview.contentOffset.x / kScreenWidth;
        self.tag = (int)i;
        if (i == 2) {
            self.comBtn.alpha = 1.0;
        }
        else
        {
            self.comBtn.alpha = 0.0;
        }
        UIButton *btn = self.selBtnView.btnsArr[i];
        self.selBtnView.selBtn.selected = NO;
        btn.selected = YES;
        self.selBtnView.selBtn = btn;
        
        ChildDetailTableViewController *childView = self.tableviewsArr[i];
        [self setUpOneChildController:i];
        [childView requestWithSelBtn:(int)i WithSurveyID:self.company_code];
    }
}

- (void)childScrollViewDidScroll:(UIScrollView *)scrollView
{
    NSString *rollway = [NSString stringWithFormat:@"%@",[scrollView class]];
    NSLog(@"%@",rollway);
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < 140) {
        self.tableview.contentOffset = scrollView.contentOffset;
    }
    else
    {
        self.tableview.contentOffset = CGPointMake(0, 140);
    }
}

#pragma mari - did finish load
//- (void)didFinishLoad
//{
//
//    ChildDetailTableViewController *childView = self.tableviewsArr[self.tag];
////
//    CGFloat webHeight = childView.webview.frame.size.height;
//    
//    childView.tableView.frame = CGRectMake(kScreenWidth*self.tag, 0, kScreenWidth, webHeight);
////    [self.contentScrollview mas_updateConstraints:^(MASConstraintMaker *make) {
////        make.height.mas_equalTo(webHeight);
////    }];
//    
//    contentSize = CGSizeMake(kScreenWidth,webHeight);
//
//    [self.tableview reloadData];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
