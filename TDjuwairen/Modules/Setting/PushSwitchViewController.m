//
//  PushSwitchViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/9/13.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PushSwitchViewController.h"
#import "LoginState.h"
#import "LoginHandler.h"
#import "RemoteSettingController.h"


@interface PushSwitchViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *titleArr;
@end

@implementation PushSwitchViewController

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
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.tableFooterView = [UIView new];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
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
        NSString *identifier = @"PushSettingCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            UISwitch *myswitch = [[UISwitch alloc]initWithFrame:CGRectZero];
            myswitch.tag = indexPath.row;
            [myswitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            BOOL isClosePush = NO;
            if (indexPath.row == 0) {
                /// 响铃
                isClosePush = [[NSUserDefaults standardUserDefaults] boolForKey:kRemoteBell];
            }else {
                
                /// 震动
                isClosePush = [[NSUserDefaults standardUserDefaults] boolForKey:kRemoteShake];
            }
            //            BOOL isClosePush = [[NSUserDefaults standardUserDefaults] boolForKey:@"isClosePush"];
            myswitch.on = !isClosePush;
            
            cell.accessoryView = myswitch;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
        
        return cell;
    }else {
        NSString *identifier = @"PushSettingCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
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
        
        nameLabel.text = @"当你使用局外人时，信通知的提醒是否需要响铃或震动";
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
