//
//  StockUnlockManager.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/2.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockUnlockManager.h"
#import "NetworkManager.h"
#import "StockUnlockModel.h"
#import "MBProgressHUD.h"
#import "StockUnlockViewController.h"
#import "STPopupController.h"
#import "TDRechargeViewController.h"

@interface StockUnlockManager ()<StockUnlockDelegate>
@property (nonatomic, weak) UIViewController *viewController;
@end

@implementation StockUnlockManager
- (void)unlockStock:(NSString *)stockCode withStockName:(NSString *)stockName withController:(UIViewController *)controller {
    
    NSAssert(stockCode.length, @"查询是否解锁股票，股票代码不能为空");
    
    self.viewController = controller;
    
    NSDictionary *para = @{@"code": stockCode};
    StockUnlockModel *model = [[StockUnlockModel alloc] init];
    model.stockCode = stockCode;
    model.stockName = stockName;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(controller.view.bounds.size.width/2, controller.view.bounds.size.height/2);
    [indicator startAnimating];
    [controller.view addSubview:indicator];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_SurveyIsUnlock parameters:para completion:^(id data, NSError *error){
        
        [indicator stopAnimating];
        
        if (!error) {
            NSString *vipTitle = data[@"vip_desc"];
            BOOL isUnlock = [data[@"is_unlock"] boolValue];
            NSInteger userKeyNum = [data[@"user_keynum"] integerValue];
            NSInteger unlockKeyNum = [data[@"unlock_keynum"] integerValue];
            
            model.vipDesc = vipTitle;
            model.isUnlock = isUnlock;
            model.userKeyNum = userKeyNum;
            model.unlockKeyNum = unlockKeyNum;
            
            if (isUnlock) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"已经解锁";
                [hud hide:YES afterDelay:0.7];
            } else {
                [self unlockWithModel:model withController:controller];
            }
            
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"查询解锁信息失败";
            [hud hide:YES afterDelay:0.7];
        }
    }];
}

- (void)unlockWithModel:(StockUnlockModel *)model withController:(UIViewController *)controller {
    
    StockUnlockViewController *vc = [[UIStoryboard storyboardWithName:@"Recharge" bundle:nil] instantiateViewControllerWithIdentifier:@"StockUnlockViewController"];
    vc.model = model;
    vc.delegate = self;
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.navigationBarHidden = YES;
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:controller];
}


#pragma mark - StockUnlockDelegate

- (void)unlockWithStockCode:(NSString *)stockCode {
    NSDictionary *para = @{@"code": stockCode};
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    indicator.hidesWhenStopped = YES;
    [indicator stopAnimating];
    [self.viewController.view addSubview:indicator];
    
    __weak StockUnlockManager *wself = self;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_SurveyUnlockCompany parameters:para completion:^(id data, NSError *error){
        [indicator stopAnimating];
        
        if (!error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.viewController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"解锁成功";
            [hud hide:YES afterDelay:0.6];
            
            if (wself.delegate && [wself.delegate respondsToSelector:@selector(unlockManager:withStockCode:)]) {
                [wself.delegate unlockManager:wself withStockCode:stockCode];
            }
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

- (void)vipPressed:(id)sender {
    TDRechargeViewController *vc = [[TDRechargeViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
@end
