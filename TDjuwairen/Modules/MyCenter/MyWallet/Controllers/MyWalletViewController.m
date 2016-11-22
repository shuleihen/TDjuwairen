//
//  MyWalletViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MyWalletViewController.h"
#import "KeysNumberTableViewCell.h"
#import "RechargeView.h"
#import "SelWXOrAlipayView.h"
#import "MyOrderViewController.h"

#import "UIdaynightModel.h"
#import "LoginState.h"

#import "AFNetworking.h"
#import "NetworkDefine.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource,KeysNumberTableViewCellDelegate,RechargeViewDelegate,SelWXOrAlipayViewDelegate>

@property (nonatomic,strong) UIdaynightModel *daynightModel;

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) NSArray *titleArr;

@property (nonatomic,strong) RechargeView *rechargeView;      //充值页面

@property (nonatomic,strong) SelWXOrAlipayView *payView;      //选择支付页面

@property (nonatomic,strong) NSString *keysNum;

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightModel = [UIdaynightModel sharedInstance];
    self.titleArr = [NSArray arrayWithObjects:@"我的订单",@"钥匙使用记录",@"钥匙兑换", nil];
    
    
    [self setupWithNavigation];
    [self setupWithTableView];
    
    [self requestWithKeysNum];
    // Do any additional setup after loading the view.
}

- (void)requestWithKeysNum{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    NSString *url = [NSString stringWithFormat:@"%@Survey/getUserKeyNum",kAPI_songsong];
    NSDictionary *para = @{@"user_id":US.userId};
    [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *data = responseObject[@"data"];
        self.keysNum = [NSString stringWithFormat:@"%@",data[@"keyNum"]];
        [self.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)setupWithNavigation{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"我的钱包";
    
    //设置navigation背景色
    [self.navigationController.navigationBar setBackgroundColor:self.daynightModel.navigationColor];
    [self.navigationController.navigationBar setBarTintColor:self.daynightModel.navigationColor];
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[KeysNumberTableViewCell class] forCellReuseIdentifier:@"keysCell"];
    self.tableview.backgroundColor = self.daynightModel.backColor;
    [self.view addSubview:self.tableview];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return self.titleArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        KeysNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keysCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.numLab.text = self.keysNum;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.titleArr[indexPath.row];
        
        cell.textLabel.textColor = self.daynightModel.titleColor;
        cell.backgroundColor = self.daynightModel.navigationColor;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 140;
    }
    else
    {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //进入订单页
            MyOrderViewController *myorder = [[MyOrderViewController alloc] init];
            [self.navigationController pushViewController:myorder animated:YES];
        }
        else if(indexPath.row == 1){
            //进入使用记录页
        }
        else
        {
            //进入钥匙兑换页
        }
    }
}

#pragma mark - 点击弹出充值页面
- (void)clickTopUp:(UIButton *)sender
{
    self.rechargeView = [[RechargeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    self.rechargeView.delegate = self;
    [self.view addSubview:self.rechargeView];
}

#pragma mark - 关闭页面
- (void)closeRechargeView:(UIButton *)sender
{
    [self.rechargeView removeFromSuperview];
}

- (void)closeSelWXOrAlipayView:(UIButton *)sender
{
    [self.payView removeFromSuperview];
}
#pragma mark - 选择数量
- (void)clickRecharge:(UIButton *)sender
{
    if (sender.tag == 0) {
        self.keysNum = @"1";
    }
    else if (sender.tag == 1){
        self.keysNum = @"5";
    }
    else if (sender.tag == 2){
        self.keysNum = @"10";
    }
    else
    {
        self.keysNum = @"VIP";
    }
    //进入选择付款页面
    [self.rechargeView removeFromSuperview];
    self.payView = [[SelWXOrAlipayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    self.payView.delegate = self;
    [self.view addSubview:self.payView];
}

#pragma mark - 支付宝或者微信
- (void)didSelectWXOrZhifubao:(NSIndexPath *)indePath
{
    if (indePath.row == 0) { //支付宝支付
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        // 设置请求接口回来的时候支持什么类型的数据
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        NSDictionary *dic;
        if (![self.keysNum isEqualToString:@"VIP"]) {
            dic = @{@"type":@"1",
                    @"number":self.keysNum,
                    @"version":@"1.0",
                    @"user_id":US.userId};
        }
        else
        {
            dic = @{@"type":@"2",   //type = 2 表示充值VIP
                    @"number":@"1",
                    @"version":@"1.0",
                    @"user_id":US.userId};
        }
        
        NSString *url = [NSString stringWithFormat:@"%@Survey/alipayKey",kAPI_songsong];
        
        [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            nil;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = responseObject;
            NSString *orderString = dic[@"data"];
            NSString *appScheme = @"TDjuwairen";
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                //支付成功。进入成功页面
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
    else    //微信支付
    {
        NSString *urlString   = [NSString stringWithFormat:@"%@Survey/wxpayKey",kAPI_songsong];
        NSDictionary *dic;
        if (![self.keysNum isEqualToString:@"VIP"]) {
            dic = @{@"type":@"1",
                    @"number":self.keysNum,
                    @"user_id":US.userId,
                    @"device":@"1"};
        }
        else
        {
            dic = @{@"type":@"2",
                    @"number":@"1",
                    @"user_id":US.userId,
                    @"device":@"1"};
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        [manager POST:urlString parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            nil;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = responseObject;
            NSString *str = dic[@"data"];
            NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *order = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:&err];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID = [order objectForKey:@"appid"];
            req.partnerId           = [order objectForKey:@"mch_id"];
            req.prepayId            = [order objectForKey:@"prepay_id"];
            req.nonceStr            = [order objectForKey:@"nonce_str"];
            req.timeStamp           = [[order objectForKey:@"timestamp"] intValue];
            req.package             = @"Sign=WXPay";
            req.sign                = [order objectForKey:@"sign"];
            [WXApi sendReq:req];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
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
