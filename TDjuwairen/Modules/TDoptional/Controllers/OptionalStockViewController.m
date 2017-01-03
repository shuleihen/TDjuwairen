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
#import "SurveyModel.h"
#import "SurDetailViewController.h"
#import "StockManager.h"
#import "LoginViewController.h"
#import "LoginState.h"
#import "Masonry.h"
#import "NetworkManager.h"
#import "SurveyDetailViewController.h"

@interface OptionalStockViewController ()<UITableViewDelegate,UITableViewDataSource,StockManagerDelegate>

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) OptionalHeadView *headView;

@property (nonatomic,strong) NSMutableArray *optionArr;

@property (nonatomic, strong) NSDictionary *stockDict;

@property (nonatomic,strong) NSMutableArray *stockArr;

@property (nonatomic,strong) StockManager *stockManager;

@end

@implementation OptionalStockViewController

- (StockManager *)stockManager {
    if (!_stockManager) {
        _stockManager = [[StockManager alloc] init];
        _stockManager.delegate = self;
    }
    
    return _stockManager;
}

- (OptionalHeadView *)headView
{
    if (!_headView) {
        _headView = [[OptionalHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        _headView.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
    }
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    [self setupWithNavigation];
    [self setupWithTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.stockManager start];
    [self requestWithList];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.stockManager stop];
}

- (void)setupWithNavigation{
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
    self.tableview.backgroundView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.tableview.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.tableview.estimatedRowHeight = 250;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableview registerClass:[OptionalStockTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerClass:[NoOrderTableViewCell class] forCellReuseIdentifier:@"nocell"];
    [self.view addSubview:self.tableview];
}

- (void)requestWithList{
    __weak OptionalStockViewController *wself = self;
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSString *url ;
    if (US.isLogIn) {
        url = [NSString stringWithFormat:@"Collection/myStockList?user_id=%@",US.userId];
    }
    else
    {
        url = [NSString stringWithFormat:@"Collection/myStockList?user_id="];
    }
    [manager GET:url parameters:nil completion:^(id data, NSError *error) {
        if (!error) {
            //
            NSArray *arr = data;
            self.stockArr = [NSMutableArray array];
            self.optionArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                SurveyModel *model = [SurveyModel getInstanceWithDictionary:dic];
                [wself.optionArr addObject:model];
                NSString *code = [model.companyCode substringWithRange:NSMakeRange(0, 1)];
                NSString *companyCode = nil;
                if ([code isEqualToString:@"6"]) {
                    companyCode = [NSString stringWithFormat:@"sh%@",model.companyCode];
                }
                else
                {
                    companyCode = [NSString stringWithFormat:@"sz%@",model.companyCode];
                }
                [wself.stockArr addObject:companyCode];
            }
            [wself.stockManager addStocks:wself.stockArr];
            [wself.tableview reloadData];
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
}

#pragma mark - StockManagerDelegate
- (void)reloadWithStocks:(NSDictionary *)stocks
{
    self.stockDict = stocks;
    [self.tableview reloadData];
}

#pragma mark - UITableView
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
        if (self.optionArr.count > 0) {
            return self.optionArr.count;
        }
        else
        {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.optionArr.count > 0 ) {
        SurveyModel *model = self.optionArr[indexPath.row];
        OptionalStockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.nameLab.text = [model.companyName substringWithRange:NSMakeRange(0, model.companyName.length-8)];
        cell.codeLab.text = model.companyCode;
        
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
    
    if (self.optionArr.count > 0) {
        OptionalStockTableViewCell *scell = (OptionalStockTableViewCell *)cell;
        SurveyModel *model = self.optionArr[indexPath.row];
        NSString *code = [model.companyCode substringWithRange:NSMakeRange(0, 1)];
        NSString *companyCode = nil;
        if ([code isEqualToString:@"6"]) {
            companyCode = [NSString stringWithFormat:@"sh%@",model.companyCode];
        }
        else
        {
            companyCode = [NSString stringWithFormat:@"sz%@",model.companyCode];
        }
        StockInfo *stock = [self.stockDict objectForKey:companyCode];
        [scell setupWithStock:stock];
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
        return 0;
    }
    else
    {
        return 45;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SurveyModel *model = self.optionArr[indexPath.row];
    NSString *code = [model.companyCode substringWithRange:NSMakeRange(0, 1)];
    NSString *companyCode ;
    if ([code isEqualToString:@"6"]) {
        companyCode = [NSString stringWithFormat:@"sh%@",model.companyCode];
    }
    else
    {
        companyCode = [NSString stringWithFormat:@"sz%@",model.companyCode];
    }
//    SurDetailViewController *vc = [[SurDetailViewController alloc] init];
//    vc.company_name = model.companyName;
//    vc.company_code = companyCode;
//    vc.survey_cover = model.surveyCover;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
    SurveyDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
//    vc.stockInfo = stock;
    vc.stockId = companyCode;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
    if (US.isLogIn) {
        SearchViewController *searchView = [[SearchViewController alloc] init];
        searchView.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.navigationController pushViewController:searchView animated:YES];
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
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
