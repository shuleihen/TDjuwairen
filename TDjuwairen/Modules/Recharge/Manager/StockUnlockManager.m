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
#import "DeepUnlockViewController.h"
#import "StockPoolUnlockModel.h"
#import "StockPoolUnlockViewController.h"

@interface StockUnlockManager ()<StockUnlockDelegate, DeepUnlockDelegate, StockPoolUnlockDelegate>
@property (nonatomic, weak) UIViewController *viewController;
@end

@implementation StockUnlockManager

#pragma mark - Stock Unlock
- (void)unlockSurvey:(NSString *)surveyId withSurveyType:(NSInteger)surveyType withSureyTitle:(NSString *)surveyTitle withController:(UIViewController *)controller {
    NSAssert(surveyId.length, @"查询是否解锁股票，股票代码不能为空");
    
    self.viewController = controller;
    
    NSDictionary *para = @{@"content_id": surveyId,@"type":@(surveyType)};
    StockUnlockModel *model = [[StockUnlockModel alloc] init];
    model.sruveyTitle = surveyTitle;
    model.sruveyId = surveyId;
    model.sruveyType = surveyType;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(controller.view.bounds.size.width/2, controller.view.bounds.size.height/2);
    [indicator startAnimating];
    [controller.view addSubview:indicator];
    
    __weak StockUnlockManager *wself = self;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_SurveyIsUnlockSurvey parameters:para completion:^(id data, NSError *error){
        
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
                hud.label.text = @"已经解锁";
                [hud hideAnimated:YES afterDelay:0.7];
                
                hud.completionBlock = ^{
                    if (wself.delegate && [wself.delegate respondsToSelector:@selector(unlockManager:withSurveyId:)]) {
                        [wself.delegate unlockManager:wself withSurveyId:surveyId];
                    }
                };
            } else {
                [self unlockSurveyWithModel:model withController:controller];
            }
            
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"查询解锁信息失败";
            [hud hideAnimated:YES afterDelay:0.7];
        }
    }];
}

- (void)unlockSurveyWithModel:(StockUnlockModel *)model withController:(UIViewController *)controller {
    
    StockUnlockViewController *vc = [[StockUnlockViewController alloc] init];
    vc.unlockModel = model;
    vc.delegate = self;
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.style = STPopupStyleBottomSheet;
    popupController.navigationBarHidden = YES;
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:controller];
}

- (void)unlockWithSurveyId:(NSString *)surveyId withSurveyType:(NSInteger)surveyType {
    NSDictionary *para = @{@"content_id": surveyId,@"type":@(surveyType)};
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    indicator.hidesWhenStopped = YES;
    [indicator stopAnimating];
    [self.viewController.view addSubview:indicator];
    
    __weak StockUnlockManager *wself = self;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_SurveyUnlockSurvey parameters:para completion:^(id data, NSError *error){
        [indicator stopAnimating];
        
        if (!error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.viewController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"解锁成功";
            [hud hideAnimated:YES afterDelay:0.6];
            
            if (wself.delegate && [wself.delegate respondsToSelector:@selector(unlockManager:withSurveyId:)]) {
                [wself.delegate unlockManager:wself withSurveyId:surveyId];
            }
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.viewController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = error.localizedDescription;
            [hud hideAnimated:YES afterDelay:0.4];
        }
        
    }];
}

#pragma mark - Deep Unlock
- (void)unlockDeep:(NSString *)deepId withController:(UIViewController *)controller {
    NSAssert(deepId.length, @"查询是否解锁深度调研，深度调研ID不能为空");
    
    self.viewController = controller;
    
    NSDictionary *para = @{@"survey_id": deepId};
    StockUnlockModel *model = [[StockUnlockModel alloc] init];
    model.deepId = deepId;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(controller.view.bounds.size.width/2, controller.view.bounds.size.height/2);
    [indicator startAnimating];
    [controller.view addSubview:indicator];
    
    __weak StockUnlockManager *wself = self;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_SurveyIsUnlockDeep parameters:para completion:^(id data, NSError *error){
        
        [indicator stopAnimating];
        
        if (!error) {
            NSString *vipTitle = data[@"vip_desc"];
            BOOL isUnlock = [data[@"is_unlock"] boolValue];
            NSInteger userKeyNum = [data[@"user_keynum"] integerValue];
            NSInteger unlockKeyNum = [data[@"unlock_keynum"] integerValue];
            NSInteger deepType = [data[@"deep_pay_type"] integerValue];
            NSString *deepPayTip = data[@"deep_pay_tip"];
            
            model.vipDesc = vipTitle;
            model.isUnlock = isUnlock;
            model.userKeyNum = userKeyNum;
            model.unlockKeyNum = unlockKeyNum;
            model.deepPayType = deepType;
            model.deepPayTip = deepPayTip;
            
            if (isUnlock) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"已经解锁";
                [hud hideAnimated:YES afterDelay:0.7];
                hud.completionBlock = ^{
                    if (wself.delegate && [wself.delegate respondsToSelector:@selector(unlockManager:withDeepId:)]) {
                        [wself.delegate unlockManager:wself withDeepId:deepId];
                    }
                };
                
            } else {
                [self unlockDeepWithModel:model withController:controller];
            }
            
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"查询解锁信息失败";
            [hud hideAnimated:YES afterDelay:0.7];
        }
    }];
}


- (void)unlockDeepWithModel:(StockUnlockModel *)model withController:(UIViewController *)controller {
    
    DeepUnlockViewController *vc = [[DeepUnlockViewController alloc] init];
    vc.unlockModel = model;
    vc.delegate = self;
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.style = STPopupStyleBottomSheet;
    popupController.navigationBarHidden = YES;
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:controller];
}

- (void)unlockDeepWithDeepId:(NSString *)deepId {
    NSDictionary *para = @{@"survey_id": deepId};
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    indicator.hidesWhenStopped = YES;
    [indicator stopAnimating];
    [self.viewController.view addSubview:indicator];
    
    __weak StockUnlockManager *wself = self;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_SurveyUnlockDeep parameters:para completion:^(id data, NSError *error){
        [indicator stopAnimating];
        
        if (!error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.viewController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"解锁成功";
            [hud hideAnimated:YES afterDelay:0.6];
            hud.completionBlock = ^{
                if (wself.delegate && [wself.delegate respondsToSelector:@selector(unlockManager:withDeepId:)]) {
                    [wself.delegate unlockManager:wself withDeepId:deepId];
                }
            };
            
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.viewController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = error.localizedDescription;
            [hud hideAnimated:YES afterDelay:0.4];
        }
        
    }];
}


#pragma mark - StockPool Unlock
- (void)unlockStockPool:(NSString *)masterId withController:(UIViewController *)controller {
    self.viewController = controller;
    
    NSDictionary *para = @{@"master_id": masterId};
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(controller.view.bounds.size.width/2, controller.view.bounds.size.height/2);
    [indicator startAnimating];
    [controller.view addSubview:indicator];
    
    __weak StockUnlockManager *wself = self;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_StockPoolGetSubscribe parameters:para completion:^(id data, NSError *error){
        
        [indicator stopAnimating];
        
        if (!error && [data isKindOfClass:[NSDictionary class]]) {
            
            StockPoolUnlockModel *model = [[StockPoolUnlockModel alloc] initWithDictionary:data];
            model.masterId = masterId;
            
            if (model.isSubscribe && !model.isSubscribeExpire) {
                
                if (wself.delegate && [wself.delegate respondsToSelector:@selector(unlockManager:withMasterId:)]) {
                    [wself.delegate unlockManager:wself withMasterId:masterId];
                }
            } else {
                [self unlockStockPoolWithModel:model withController:controller];
            }
            
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"查询股票池信息失败";
            [hud hideAnimated:YES afterDelay:0.7];
        }
    }];
}


- (void)unlockStockPoolWithModel:(StockPoolUnlockModel *)model withController:(UIViewController *)controller {
    
    StockPoolUnlockViewController *vc = [[StockPoolUnlockViewController alloc] init];
    vc.unlockModel = model;
    vc.delegate = self;
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.style = STPopupStyleBottomSheet;
    popupController.navigationBarHidden = YES;
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:controller];
}

- (void)unlockWithStockPoolMasterId:(NSString *)masterId {
    NSDictionary *para = @{@"master_id": masterId};
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    indicator.hidesWhenStopped = YES;
    [indicator stopAnimating];
    [self.viewController.view addSubview:indicator];
    
    __weak StockUnlockManager *wself = self;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_StockPoolSubscribe parameters:para completion:^(id data, NSError *error){
        [indicator stopAnimating];
        
        if (!error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.viewController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"订阅成功";
            [hud hideAnimated:YES afterDelay:0.6];
            
            if (wself.delegate && [wself.delegate respondsToSelector:@selector(unlockManager:withMasterId:)]) {
                [wself.delegate unlockManager:wself withMasterId:masterId];
            }
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.viewController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = error.localizedDescription;
            [hud hideAnimated:YES afterDelay:0.4];
        }
        
    }];
}


#pragma mark -

- (void)rechargePressed:(id)sender {
    TDRechargeViewController *vc = [[TDRechargeViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)vipPressed:(id)sender {
    TDRechargeViewController *vc = [[TDRechargeViewController alloc] init];
    vc.isVipRecharge = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
