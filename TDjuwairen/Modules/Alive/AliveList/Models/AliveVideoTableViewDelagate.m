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
#import "StockUnlockViewController.h"
#import "TDRechargeViewController.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "STPopupController.h"
#import "DetailPageViewController.h"

@interface AliveVideoTableViewDelagate ()<StockUnlockDelegate>

@end

@implementation AliveVideoTableViewDelagate

- (id)initWithTableView:(UITableView *)tableView withViewController:(UIViewController *)viewController {
    if ([super initWithTableView:tableView withViewController:viewController]) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        UINib *nib = [UINib nibWithNibName:@"AliveVideoListTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"AliveVideoListTableViewCellID"];
    }
    
    return self;
}

- (void)setupAliveListArray:(NSArray *)array {
    self.itemList = array;
}

- (void)reloadUnlockWithStockCode:(NSString *)stockCode {
    for (AliveListModel *model in self.itemList) {
        if ([model.extra.companyCode isEqualToString:stockCode]) {
            model.extra.isUnlock = YES;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - StockUnlockDelegate

- (void)unlockWithStockCode:(NSString *)stockCode {
    NSDictionary *para = @{@"user_id":  US.userId,
                           @"code":     stockCode};
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    indicator.hidesWhenStopped = YES;
    [indicator stopAnimating];
    [self.viewController.view addSubview:indicator];
    
    __weak AliveVideoTableViewDelagate *wself = self;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_SurveyUnlock parameters:para completion:^(id data, NSError *error){
        [indicator stopAnimating];
        
        if (!error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.viewController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"解锁成功";
            [hud hide:YES afterDelay:0.6];
            
            [wself reloadUnlockWithStockCode:stockCode];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.viewController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = error.localizedDescription;
            [hud hide:YES afterDelay:0.4];
        }
        
    }];
}

- (void)rechargePressed:(id)sender {
    TDRechargeViewController *vc = [[TDRechargeViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
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
        
        
        StockUnlockViewController *vc = [[UIStoryboard storyboardWithName:@"Recharge" bundle:nil] instantiateViewControllerWithIdentifier:@"StockUnlockViewController"];
        vc.stockCode = model.extra.companyCode;
        vc.stockName = model.extra.companyName;
        vc.needKey = model.extra.unlockKeyNum;
        vc.delegate = self;
        
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
        popupController.navigationBarHidden = YES;
        popupController.containerView.layer.cornerRadius = 4;
        [popupController presentInViewController:self.viewController];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

@end
