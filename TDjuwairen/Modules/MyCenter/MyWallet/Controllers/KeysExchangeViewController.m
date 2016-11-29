//
//  KeysExchangeViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "KeysExchangeViewController.h"
#import "ExchangeTableViewCell.h"
#import "NoOrderTableViewCell.h"
#import "ExchangeModel.h"
#import "PopupExchangeView.h"
#import "PopUsExchangeSuccessView.h"
#import "AwardViewController.h"

#import "UIdaynightModel.h"
#import "LoginState.h"

#import "NetworkManager.h"

@interface KeysExchangeViewController ()<UITableViewDelegate,UITableViewDataSource,ExchangeTableViewCellDelegate,PopupExchangeViewDelegate,PopUsExchangeSuccessViewDelegate>

@property (nonatomic, strong) UIdaynightModel *daynightModel;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *listArr;

@property (nonatomic, strong) PopupExchangeView *exchangeView;

@property (nonatomic, strong) PopUsExchangeSuccessView *successView;

@end

@implementation KeysExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightModel = [UIdaynightModel sharedInstance];
    [self setupWithNavigation];
    [self setupWithTableView];
    
    //请求奖品列表
    [self requestWithPrize];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{
    self.title = @"钥匙兑换";
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.estimatedRowHeight = 250;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    [self.tableview registerClass:[ExchangeTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
}

- (void)requestWithPrize{
    self.listArr = [NSMutableArray array];
    
    __weak KeysExchangeViewController *wself = self;
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSString *url = @"User/exchangeList";
    NSDictionary *para = @{@"user_id":US.userId};
    [manager POST:url parameters:para completion:^(id data, NSError *error) {
        if (!error) {
            NSLog(@"%@",data);
            NSArray *list = data;
            for (NSDictionary *dic in list) {
                ExchangeModel *model = [ExchangeModel getInstanceWithDic:dic];
                [self.listArr addObject:model];
            }
            [wself.tableview reloadData];
        }
        else
        {
//            NSLog(@"%@",error);
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.listArr.count > 0) {
        return self.listArr.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listArr.count > 0) {
        ExchangeModel *model = self.listArr[indexPath.row];
        ExchangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell setupWithDiction:model andIndexPath:indexPath];
        cell.prizeLab.textColor = self.daynightModel.textColor;
        cell.line.layer.borderColor = self.daynightModel.lineColor.CGColor;
        cell.backgroundColor = self.daynightModel.navigationColor;
        cell.delegate = self;
        return cell;
    }
    else
    {
        NoOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noOrderCell"];
        if (cell == nil) {
            cell = [[NoOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noOrderCell"];
        }
        cell.imgView.image = [UIImage imageNamed:@"icon_zhongjiangjilu"];
        cell.titLab.text = @"暂时没有奖品可以兑换~";
        return cell;
    }
}

#pragma mark - 点击进入兑奖页面
- (void)clickToExchangePrize:(UIButton *)sender
{
    ExchangeModel *model = self.listArr[sender.tag];
    self.exchangeView = [[PopupExchangeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) andWithModel:model];
    self.exchangeView.goAwardBtn.tag = sender.tag;
    self.exchangeView.delegate = self;
    [self.view addSubview:self.exchangeView];
}

#pragma mark - 取消兑奖弹框
- (void)closePopupExchangeView:(UIButton *)sender
{
    [self.exchangeView removeFromSuperview];
}

#pragma mark - 跳转填写信息页面
- (void)gotoImfomation:(UIButton *)sender
{
    //移除兑奖页面
    [self.exchangeView removeFromSuperview];
    
    ExchangeModel *model = self.listArr[sender.tag];
    AwardViewController *awardView = [[AwardViewController alloc] init];
    awardView.model = model;

    awardView.block = ^(bool *status,ExchangeModel *model){
        if (status) {
            self.successView = [[PopUsExchangeSuccessView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) andWithModel:model];
            self.successView.goAwardBtn.tag = sender.tag;
            self.successView.delegate = self;
            [self.view addSubview:self.successView];
        }
    };
    [self.navigationController pushViewController:awardView animated:YES];
}

#pragma mark - 取消成功弹框
- (void)clickCloseSuccessView:(UIButton *)sender
{
    [self.successView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
