//
//  PushSettingViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/9/13.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PushSettingViewController.h"
#import "LoginStateManager.h"
#import "LoginHandler.h"
#import "RemoteSettingController.h"


@interface PushSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArr;
@end

@implementation PushSettingViewController

- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@[@"响铃",@"震动"],@[@"通知提醒设置"]];
    }
    return _titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TDViewBackgrouondColor;
    
    [self setupWithNavigation];
    [self setupWithTableView];
}

- (void)setupWithNavigation{
    self.title = @"消息通知";
}

- (void)setupWithTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        NSString *identifier = @"PushSettingsCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            
            UISwitch *myswitch = [[UISwitch alloc]initWithFrame:CGRectZero];
            myswitch.tag = indexPath.row;
            [myswitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            
            BOOL isClosePush = NO;
            if (indexPath.row == 0) {
                // 响铃
                isClosePush = [[NSUserDefaults standardUserDefaults] boolForKey:kRemoteBell];
            }else {
                // 震动
                isClosePush = [[NSUserDefaults standardUserDefaults] boolForKey:kRemoteShake];
            }
            myswitch.on = !isClosePush;
            
            cell.accessoryView = myswitch;
        }
        
        cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
        
        return cell;
    } else {
        NSString *identifier = @"PushSettingsCell1ID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        }
        
        cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        RemoteSettingController *vc = [[RemoteSettingController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerV.backgroundColor = [UIColor clearColor];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth-32, 20)];
    nameLabel.textColor = TDLightGrayColor;
    nameLabel.font = [UIFont systemFontOfSize:13.0f];
    [headerV addSubview:nameLabel];
    
    if (section == 0) {
        nameLabel.text = @"应用内提醒";
    }else {
        nameLabel.text = @"当你使用局外人时，新通知的提醒是否需要响铃或震动";
    }
    
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}


- (void)switchAction:(UISwitch *)myswitch{
    if (myswitch.on == NO) {
        if (myswitch.tag == 0) {
            [LoginHandler closeRemoteBell];
        }else {
            [LoginHandler closeRemoteShake];
            
        }
        
        //        [LoginHandler closeRemotePush];
    } else {
        
        if (myswitch.tag == 0) {
            [LoginHandler openRemoteBell];
        }else {
            [LoginHandler openRemoteShake];
            
        }
        //        [LoginHandler openRemotePush];
    }
}

@end
