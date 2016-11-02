//
//  MyWalletViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MyWalletViewController.h"
#import "KeysNumberTableViewCell.h"

#import "UIdaynightModel.h"

@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource,KeysNumberTableViewCellDelegate>

@property (nonatomic,strong) UIdaynightModel *daynightModel;

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) NSArray *titleArr;

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightModel = [UIdaynightModel sharedInstance];
    self.titleArr = [NSArray arrayWithObjects:@"支付记录",@"我的收入",@"解锁记录",@"使用记录",@"钥匙兑换", nil];
    
    [self setupWithNavigation];
    [self setupWithTableView];
    // Do any additional setup after loading the view.
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
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        KeysNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keysCell" forIndexPath:indexPath];
        cell.delegate = self;
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

- (void)clickTopUp:(UIButton *)sender
{
    NSLog(@"充值");
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
