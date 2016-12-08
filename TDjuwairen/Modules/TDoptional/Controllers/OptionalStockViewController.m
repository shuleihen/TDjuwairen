//
//  OptionalStockViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/12/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "OptionalStockViewController.h"
#import "SearchViewController.h"
#import "OptionalHeadView.h"
#import "OptionalStockTableViewCell.h"
#import "NoOrderTableViewCell.h"
#import "OptionalManageViewController.h"

#import "UIdaynightModel.h"

#import "Masonry.h"

@interface OptionalStockViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIdaynightModel *daynightModel;

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) OptionalHeadView *headView;

@property (nonatomic,strong) NSMutableArray *stockArr;

@end

@implementation OptionalStockViewController

- (OptionalHeadView *)headView
{
    if (!_headView) {
        _headView = [[OptionalHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    }
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightModel = [UIdaynightModel sharedInstance];
    
    [self setupWithNavigation];
    [self setupWithTableView];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{
    self.title = @"自选股";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStyleDone target:self action:@selector(clickManager:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton*search = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [search setImage:[UIImage imageNamed:@"nav_search.png"] forState:UIControlStateNormal];
    [search addTarget:self action:@selector(GoSearch:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:search];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableview.estimatedRowHeight = 250;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    [self.tableview registerClass:[OptionalStockTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerClass:[NoOrderTableViewCell class] forCellReuseIdentifier:@"nocell"];
    [self.view addSubview:self.tableview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else
    {
        if (self.stockArr.count > 0) {
            return 10;
        }
        else
        {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.stockArr.count > 0 ) {
        OptionalStockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.nameLab.textColor = self.daynightModel.textColor;
        cell.codeLab.textColor = self.daynightModel.secTextColor;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        NoOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noOrderCell"];
        if (cell == nil) {
            cell = [[NoOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noOrderCell"];
            UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAddStock)];
            cell.imgView.userInteractionEnabled = YES;

            [cell.imgView addGestureRecognizer:tapGesturRecognizer];
        }
        cell.imgView.image = [UIImage imageNamed:@"btn_tianjia_nor"];
        cell.titLab.text = @"暂无股票，点击添加";
        
        CGFloat imgX = (kScreenHeight-64-55-50)/6;
        [cell.titLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell).with.offset(-(kScreenHeight-64-imgX-90-25-40));
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    else
    {
        return self.headView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    else
    {
        return 45;
    }
}

#pragma mark - navigation
- (void)clickManager:(UIButton *)sender{
    OptionalManageViewController *manage = [[OptionalManageViewController alloc] init];
    manage.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:manage animated:YES];
}

- (void)GoSearch:(UIButton *)sender{
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
    [self.navigationController pushViewController:searchView animated:YES];
}

- (void)clickAddStock{
    NSLog(@"嘿嘿嘿");
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
