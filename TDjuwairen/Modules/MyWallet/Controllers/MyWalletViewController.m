//
//  MyWalletViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MyWalletViewController.h"
#import "KeysNumberTableViewCell.h"
#import "MyOrderViewController.h"
#import "KeysRecordViewController.h"
#import "KeysExchangeViewController.h"
#import "LoginState.h"
#import "NetworkManager.h"
#import "RechargeViewController.h"
#import "STPopupController.h"

@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource,KeysNumberTableViewCellDelegate>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSString *keysNum;

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的钱包";
    
    self.titleArr = [NSArray arrayWithObjects:@"我的订单",@"钥匙使用记录",@"钥匙兑换", nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestWithKeysNum) name:@"refreshKeys" object:nil];
    
    [self setupWithTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestWithKeysNum];
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = TDViewBackgrouondColor;
    self.tableview.separatorColor = TDSeparatorColor;
    [self.view addSubview:self.tableview];
    
}

- (void)requestWithKeysNum{
    __weak MyWalletViewController *wself = self;
    
    NSDictionary *para = @{@"user_id":US.userId};
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    [ma POST:API_QueryKeyNumber parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSInteger keyNumber = [data[@"keyNum"] integerValue];
            wself.keysNum = [NSString stringWithFormat:@"%ld",(long)keyNumber];
            [wself.tableview reloadData];
        }
        else
        {
            wself.keysNum = @"0";
            [wself.tableview reloadData];
        }
    }];
}

- (void)chargePressed:(UIButton *)sender
{
    __weak MyWalletViewController *wself = self;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    [ma POST:API_PayIsShow parameters:nil completion:^(id data, NSError *error){
        if (!error && [data[@"is_show"] boolValue]) {
            RechargeViewController *vc = [[UIStoryboard storyboardWithName:@"Recharge" bundle:nil] instantiateViewControllerWithIdentifier:@"RechargeViewController"];
            
            STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
            popupController.containerView.layer.cornerRadius = 4;
            [popupController presentInViewController:wself];

        }
        else
        {
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:nil message:@"请到电脑端充值" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            [wself presentViewController:alert animated:YES completion:nil];
        }
    }];
}

#pragma mark - UITableView
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
        NSString *identifier = @"MyWalletKeysCellID";
        KeysNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[KeysNumberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.delegate = self;
        cell.numLab.text = self.keysNum;
        
        return cell;
    }
    else
    {
        NSString *identifier = @"MyWalletCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.textLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.titleArr[indexPath.row];
        
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
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //进入订单页
            MyOrderViewController *myOrder = [[MyOrderViewController alloc] init];
            [self.navigationController pushViewController:myOrder animated:YES];
        }
        else if(indexPath.row == 1){
            //进入使用记录页
            KeysRecordViewController *keysRecord = [[KeysRecordViewController alloc] init];
            [self.navigationController pushViewController:keysRecord animated:YES];
        }
        else
        {
            //进入钥匙兑换页
            KeysExchangeViewController *keysExchange = [[KeysExchangeViewController alloc] init];
            [self.navigationController pushViewController:keysExchange animated:YES];
        }
    }
}



@end
