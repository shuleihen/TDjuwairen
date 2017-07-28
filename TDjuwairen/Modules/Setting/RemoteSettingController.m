//
//  RemoteSettingController.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/27.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "RemoteSettingController.h"
#import "LoginStateManager.h"
#import "LoginHandler.h"

@interface RemoteSettingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *titleArr;
@property (strong, nonatomic) NSArray *headerArr;
@property (strong, nonatomic) NSArray *localRemoteArr;
@end

@implementation RemoteSettingController

- (NSArray *)headerArr {
    
    if (!_headerArr) {
        _headerArr = @[@"",@"股票",@"评分",@"直播",@"关注的人",@"粉丝"];
    }
    return _headerArr;
}

- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@[@"接受通知提醒"],@[@"自选股的调研、公告和热点更新通知",@"关注板块调研更新通知",@"调研报告的提问被回答通知"],@[@"平分模块的评论、回复通知"],@[@"评论、回复通知",@"点赞的通知",@"转发的通知"],@[@"关注的人动态更新通知"],@[@"新粉丝通知"]];
    }
    return _titleArr;
}


- (NSArray *)localRemoteArr {
    
    if (!_localRemoteArr) {
        _localRemoteArr = @[@[],@[kRemotePersionStock,kRemoteAttentPlateSurvey,kRemoteSurveyAnswer],@[kRemoteScoreModule],@[kRemoteAliveCommon,kRemoteAliveDianZan,kRemoteAliveForwarding],@[kRemoteAttentionPersionTrends],@[kRemoteNewFans]];
    }
    return _localRemoteArr;
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
    
    NSString *identifier = @"";
    
    if (indexPath.section == 0) {
        identifier = @"PushSettingButtonCell";
    }else {
        
        identifier = @"PushSettingSwitchCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        if (indexPath.section == 0) {
            UIButton *pushStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            pushStatusBtn.frame = CGRectMake(kScreenWidth-67, 5, 55, 24);
            pushStatusBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            [pushStatusBtn setTitleColor:TDDetailTextColor forState:UIControlStateNormal];
            [pushStatusBtn setTitle:@"已开启" forState:UIControlStateNormal];
            cell.accessoryView = pushStatusBtn;
        }else {
            
            UISwitch *myswitch = [[UISwitch alloc]initWithFrame:CGRectZero];
            myswitch.tag = indexPath.section*100+indexPath.row;
            [myswitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            BOOL isClosePush = [[NSUserDefaults standardUserDefaults] boolForKey:self.localRemoteArr[indexPath.section][indexPath.row]];
            myswitch.on = !isClosePush;
            cell.accessoryView = myswitch;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerV.backgroundColor = [UIColor clearColor];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth-32, 20)];
    nameLabel.textColor = TDLightGrayColor;
    nameLabel.font = [UIFont systemFontOfSize:13.0f];
    [headerV addSubview:nameLabel];
    if (section == 0) {
        return nil;
    }else {
        
        nameLabel.text = self.headerArr[section];
    }
    return headerV;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    footerV.backgroundColor = [UIColor clearColor];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth-32, 60)];
    nameLabel.textColor = TDLightGrayColor;
    nameLabel.font = [UIFont systemFontOfSize:13.0f];
    nameLabel.numberOfLines = 0;
    [footerV addSubview:nameLabel];
    if (section != 0) {
        return nil;
    }else {
        
        nameLabel.text = @"如果要开启或者关闭局外人的推送通知，请在iPhone的［设置］－［通知］功能中，找到局外人进行设置";
    }
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section==0?CGFLOAT_MIN:40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section==0?80:CGFLOAT_MIN;
}


- (void)switchAction:(UISwitch *)myswitch{
    NSInteger section = myswitch.tag/100;
    NSInteger row = myswitch.tag%100;
    
    if (myswitch.on == NO) {
        
        if (section == 1 && row == 0) {
            [LoginHandler closeRemotePersionStock];
        }else if (section == 1 && row == 1) {
            [LoginHandler closeRemoteAttentPlateSurvey];
        }else if (section == 1 && row == 2) {
            [LoginHandler closeRemoteSurveyReportAnswer];
        }else if (section == 2 && row == 0) {
            [LoginHandler closeRemoteScoreModule];
        }else if (section == 3 && row == 0) {
            [LoginHandler closeRemoteAliveCommon];
        }else if (section == 3 && row == 1) {
            [LoginHandler closeRemoteAliveDianZan];
        }else if (section == 3 && row == 2) {
            [LoginHandler closeRemoteAliveForwarding];
        }else if (section == 4 && row == 0) {
            [LoginHandler closeRemoteAttentionPersionTrends];
        }else {
            [LoginHandler closeRemoteNewFans];
        }
    } else {
        if (section == 1 && row == 0) {
            [LoginHandler openRemotePersionStock];
        }else if (section == 1 && row == 1) {
            [LoginHandler openRemoteAttentPlateSurvey];
        }else if (section == 1 && row == 2) {
            [LoginHandler openRemoteSurveyReportAnswer];
        }else if (section == 2 && row == 0) {
            [LoginHandler openRemoteScoreModule];
        }else if (section == 3 && row == 0) {
            [LoginHandler openRemoteAliveCommon];
        }else if (section == 3 && row == 1) {
            [LoginHandler openRemoteAliveDianZan];
            
        }else if (section == 3 && row == 2) {
            [LoginHandler openRemoteAliveForwarding];
            
        }else if (section == 4 && row == 0) {
            [LoginHandler openRemoteAttentionPersionTrends];
        }else {
            [LoginHandler openRemoteNewFans];
        }
    }
}


@end
