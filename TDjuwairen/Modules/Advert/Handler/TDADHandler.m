//
//  TDADHandler.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/21.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDADHandler.h"
#import "StockDetailViewController.h"
#import "VideoDetailViewController.h"
#import "TDRechargeViewController.h"
#import "SurveyDetailWebViewController.h"
#import "TDWebViewHandler.h"

@implementation TDADHandler
+ (void)pushWithAdModel:(TDAdvertModel *)model inNav:(UINavigationController *)nav {
    
    switch (model.adType) {
        case kADTypeH5:{
            [TDWebViewHandler openURL:model.adUrl inNav:nav];
            break;
        }
        case kADTypeStock:{
            StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
            vc.stockCode = model.adUrl;
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case kADTypeVideo:{
            VideoDetailViewController *vc = [[VideoDetailViewController alloc] initWithVideoId:model.adUrl];
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case kADTypeSurvey:{
            SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
            vc.url =  model.adUrl;
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case kADTypeRecharge:{
            TDRechargeViewController *vc = [[TDRechargeViewController alloc] init];
            vc.isVipRecharge = YES;
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}
@end
