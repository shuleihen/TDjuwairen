//
//  AliveEditMasterViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveEditMasterViewController.h"
#import "AliveRoomMasterModel.h"
#import "NetworkManager.h"
#import "UIImageView+WebCache.h"
#import "LoginState.h"
#import "NotificationDef.h"
#import "AliveCitySettingViewController.h"
#import "AliveIntroSettingViewController.h"
#import "AliveSexSettingViewController.h"

@interface AliveEditMasterViewController ()
@property (nonatomic, strong) IBOutlet UIImageView *avatar;
@property (nonatomic, strong) AliveRoomMasterModel *masterModel;
@end

@implementation AliveEditMasterViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.avatar.layer.cornerRadius = 30.0f;
    self.avatar.clipsToBounds = YES;
    
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    
    [self queryMasterInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSexNotifi:) name:kUpdateAliveSexNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCityNotifi:) name:kUpdateAliveCityNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIntroNotifi:) name:kUpdateAliveIntroNotification object:nil];
}

- (void)queryMasterInfo {

    NSDictionary *dict = @{@"master_id": self.masterId?:@""};
    __weak AliveEditMasterViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_AliveGetRoomInfo parameters:dict completion:^(id data, NSError *error) {
        if (!error) {
            wself.masterModel = [[AliveRoomMasterModel alloc] initWithDictionary:data];
            [wself setupMasterInfo];
        } else {
            
        }
    }];

}

- (void)setupMasterInfo {
    
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:self.masterModel.avatar] placeholderImage:TDDefaultUserAvatar];
    [self.tableView reloadData];
}


#pragma mark - Notifi
- (void)updateSexNotifi:(NSNotification *)notifi {
    NSString *sex = notifi.object;
    if (!sex.length) {
        return;
    }
    
    NSDictionary *dict = @{@"sex": sex?:@""};
    __weak AliveEditMasterViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_AliveUpdateUserSex parameters:dict completion:^(id data, NSError *error) {
        if (!error) {
            
            if ([sex isEqualToString:@"male"]) {
                wself.masterModel.sex = @"男";
            } else if ([sex isEqualToString:@"female"]) {
                wself.masterModel.sex = @"女";
            }
            
            [wself.tableView reloadData];
            
        } else {
            
        }
    }];
}

- (void)updateCityNotifi:(NSNotification *)notifi {
    
    [self.navigationController popToViewController:self animated:YES];
    
    NSString *city = notifi.object;
    if (!city.length) {
        return;
    }
    
    NSDictionary *dict = @{@"address": city?:@""};
    __weak AliveEditMasterViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_AliveUpdateUserCity parameters:dict completion:^(id data, NSError *error) {
        if (!error) {
            
            wself.masterModel.city = city;
            [wself.tableView reloadData];
            
        } else {
            
        }
    }];
}

- (void)updateIntroNotifi:(NSNotification *)notifi {
    NSString *intro = notifi.object;
    self.masterModel.roomInfo = intro;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 1) &&
        (indexPath.row == 0)) {
        // 昵称
        cell.detailTextLabel.text = self.masterModel.masterNickName;
    } else if ((indexPath.section == 1) &&
               (indexPath.row == 1)) {
        // 性别
        cell.detailTextLabel.text = self.masterModel.sex.length?self.masterModel.sex:@"未选择";
    } else if ((indexPath.section == 1) &&
               (indexPath.row == 2)) {
        // 所在城市
        cell.detailTextLabel.text = self.masterModel.city.length?self.masterModel.city:@"省 市";
    }else if ((indexPath.section == 2) &&
              (indexPath.row == 0)) {
        // 直播间介绍
        cell.detailTextLabel.text = self.masterModel.roomInfo.length?self.masterModel.roomInfo:@"很懒哦，一句介绍都木有";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ((indexPath.section == 1) &&
        (indexPath.row == 1)) {
        // 性别
        AliveSexSettingViewController *vc = [[AliveSexSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.sex = self.masterModel.sex;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ((indexPath.section == 1) &&
               (indexPath.row == 2)) {
        // 所在城市
        AliveCitySettingViewController *vc = [[AliveCitySettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.level = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ((indexPath.section == 2) &&
              (indexPath.row == 0)) {
        // 直播间介绍
        AliveIntroSettingViewController *vc = [[AliveIntroSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.intro = self.masterModel.roomInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
