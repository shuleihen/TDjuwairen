//
//  AliveVideoTableViewDelagate.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/1.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveVideoTableViewDelagate.h"
#import "AliveVideoListTableViewCell.h"
#import "AliveListModel.h"
#import "SurveyDetailWebViewController.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "DetailPageViewController.h"
#import "StockUnlockManager.h"

@interface AliveVideoTableViewDelagate ()<StockUnlockManagerDelegate>
@property (nonatomic, strong) StockUnlockManager *unlockManager;
@end

@implementation AliveVideoTableViewDelagate

- (id)initWithTableView:(UITableView *)tableView withViewController:(UIViewController *)viewController {
    if ([super initWithTableView:tableView withViewController:viewController]) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        UINib *nib = [UINib nibWithNibName:@"AliveVideoListTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"AliveVideoListTableViewCellID"];
        
        self.unlockManager = [[StockUnlockManager alloc] init];
        self.unlockManager.delegate = self;
    }
    
    return self;
}

- (void)setupAliveListArray:(NSArray *)array {
    self.itemList = array;
}


#pragma mark - StockUnlockManagerDelegate
- (void)unlockManager:(StockUnlockManager *)manager withStockCode:(NSString *)stockCode {
    for (AliveListModel *model in self.itemList) {
        if ([model.extra.companyCode isEqualToString:stockCode]) {
            model.extra.isUnlock = YES;
        }
    }
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.itemList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AliveListModel *model = self.itemList[indexPath.section];
    return [AliveVideoListTableViewCell heightWithAliveModel:model];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AliveVideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveVideoListTableViewCellID"];
    
    AliveListModel *model = self.itemList[indexPath.section];
    [cell setupAliveModel:model];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AliveListModel *model = self.itemList[indexPath.section];
    
    if (model.extra.isUnlock) {
//        SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
//        vc.contentId = model.aliveId;
//        vc.stockCode = model.extra.companyCode;
//        vc.stockName = model.extra.companyName;
//        vc.tag = 0;
//        vc.url = [SurveyDetailContentViewController contenWebUrlWithContentId:model.aliveId withTag:@"0"];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.viewController.navigationController pushViewController:vc animated:YES];
        
        DetailPageViewController *vc = [[DetailPageViewController alloc] init];
        vc.sharp_id = model.aliveId;
        vc.pageMode = @"sharp";
        [self.viewController.navigationController pushViewController:vc animated:YES];
    } else {
        if (!US.isLogIn) {
            LoginViewController *login = [[LoginViewController alloc] init];
            login.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:login animated:YES];
            return;
        }
        
        [self.unlockManager unlockStock:model.extra.companyCode withStockName:model.extra.companyName withController:self.viewController];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

@end
