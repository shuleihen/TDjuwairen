//
//  AliveMasterListTabelViewDelegate.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveMasterListTabelViewDelegate.h"
#import "AliveRoomViewController.h"
#import "AliveMasterListTableViewCell.h"
#import "AliveMasterModel.h"
#import "NetworkManager.h"
#import "AliveTypeDefine.h"

@interface AliveMasterListTabelViewDelegate ()<AliveMasterListCellDelegate>

@end

@implementation AliveMasterListTabelViewDelegate
- (id)initWithTableView:(UITableView *)tableView withViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.tableView = tableView;
        self.viewController = viewController;
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        UINib *nib = [UINib nibWithNibName:@"AliveVideoListTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"AliveVideoListTableViewCellID"];
    }
    
    return self;
}

- (void)setItemList:(NSArray *)itemList {
    _itemList = itemList;
    
    [self.tableView reloadData];
}

#pragma mark - AliveMasterListCellDelegate

- (void)aliveMasterListCell:(AliveMasterListTableViewCell *)cell attentPressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.viewController.navigationController pushViewController:login animated:YES];
        return;
    }
    
    AliveMasterModel *model = cell.aliveModel;
    if (model.masterId.length <= 0) {
        return ;
    }
    __weak typeof(self)weakSelf = self;
    NSString *str = API_AliveAddAttention;
    if (model.isAtten) {
        // 取消关注
        str = API_AliveDelAttention;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    //    cell.attentBtn.isLoading = YES;
    
    [manager POST:str parameters:@{@"user_id":model.masterId} completion:^(id data, NSError *error){
        
        //        cell.attentBtn.isLoading = NO;
        
        if (!error) {
            
            if (data && [data[@"status"] integerValue] == 1) {
                
                model.isAtten = !model.isAtten;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
            }
        } else {
        }
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.itemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AliveMasterListTableViewCell *cell = [AliveMasterListTableViewCell loadAliveMasterListTableViewCell:tableView];
    
    AliveMasterModel *model = self.itemList[indexPath.row];
    cell.aliveModel = model;
    cell.delegate = self;
    
    if (self.listType == kAliveDianZanList) {
        cell.introLabel.hidden = YES;
    }else {
        cell.introLabel.hidden = NO;
        
    }
    
    if (self.listType == kAliveAttentionList || self.listType == kAliveFansList) {
        cell.aLevelLabel.hidden = YES;
        cell.aFansCountLabel.hidden = YES;
    }else {
        cell.aLevelLabel.hidden = NO;
        cell.aFansCountLabel.hidden = YES;
        
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AliveMasterModel *model = self.itemList[indexPath.row];
    if (model.masterId.length <= 0) {
        return;
    }
    
    AliveRoomViewController *vc = [[AliveRoomViewController alloc] initWithMasterId:model.masterId];
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listType == kAliveDianZanList) {
        return 74;
    }else if (self.listType == kAliveAttentionList || self.listType == kAliveFansList) {
        return 80;
    }else {
        return 100;
    }
}

@end
