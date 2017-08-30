//
//  MemberCenterVipManager.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/30.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "MemberCenterVipManager.h"
#import "MemberCenterVipModel.h"
#import "MemberCenterVipViewController.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "STPopup.h"
#import <StoreKit/StoreKit.h>
#import "CocoaLumberjack.h"


@interface MemberCenterVipManager ()<MemberCenterVipDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation MemberCenterVipManager

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
        _indicator.hidesWhenStopped = YES;
    }
    return _indicator;
}

#pragma mark - Vip
- (void)unlockVipIsRenew:(BOOL)isRenew withController:(UIViewController *)controller {
    self.viewController = controller;
    
    [self.indicator startAnimating];
    [self.viewController.view addSubview:self.indicator];
    
    __weak MemberCenterVipManager *wself = self;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_PayGetVipList parameters:nil completion:^(id data, NSError *error){
        [wself.indicator stopAnimating];
        
        if (!error) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
            for (NSDictionary *dict in data) {
                MemberCenterVipModel *model = [[MemberCenterVipModel alloc] initWithDictionary:dict];
                [array addObject:model];
            }
            [wself unlockVipIsRenew:isRenew withVipList:array withController:controller];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.viewController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = error.localizedDescription;
            [hud hideAnimated:YES afterDelay:0.6];
        }
        
    }];
}

- (void)unlockVipIsRenew:(BOOL)isRenew withVipList:(NSArray *)array withController:(UIViewController *)controller {
    MemberCenterVipViewController *vc = [[MemberCenterVipViewController alloc] init];
    vc.vipList = array;
    vc.isRenew = isRenew;
    vc.delegate = self;
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.style = STPopupStyleBottomSheet;
    popupController.navigationBarHidden = YES;
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:controller];
}

- (void)didSelectedWithMemberCenterVipModel:(MemberCenterVipModel *)vipModel {
    [self requestProductWithIdentifier:vipModel.vipId];
}

- (void)requestProductWithIdentifier:(NSString *)identifier {
    if (![SKPaymentQueue canMakePayments]) {
        return;
    }
    
    [self.indicator startAnimating];
    [self.viewController.view addSubview:self.indicator];
    
    __weak MemberCenterVipManager *wself = self;
    
    NSSet *nsset = [NSSet setWithObject:identifier];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = wself;
    [request start];
}

#pragma mark -SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    if([response.products count] == 0){
        [self.indicator stopAnimating];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
        hud.label.text = @"加载失败";
        [hud hideAnimated:YES afterDelay:0.6];
        DDLogError(@"应用内购买商品为空");
        return;
    }
    
    SKProduct *product = response.products.firstObject;
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    DDLogError(@"加载苹果应用内购买失败 error=%@",error);
    [self.indicator stopAnimating];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    hud.label.text = @"加载失败";
    [hud hideAnimated:YES afterDelay:0.6];
}

- (void)requestDidFinish:(SKRequest *)request{
}

#pragma mark -SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions  {
    for(SKPaymentTransaction *tran in transactions){
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                [self.indicator stopAnimating];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
                [self verifyPurchaseWithPaymentTransaction];
            }
                break;
            case SKPaymentTransactionStatePurchasing:
                DDLogInfo(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:{
                DDLogInfo(@"已经购买过商品");
                
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
            }
                break;
            case SKPaymentTransactionStateFailed:{
                DDLogError(@"交易失败");
                [self.indicator stopAnimating];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
                hud.label.text = @"购买失败";
                [hud hideAnimated:YES afterDelay:0.6];
            }
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)verifyPurchaseWithPaymentTransaction{
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    __weak MemberCenterVipManager *wself = self;
    
    BOOL isDebug = NO;
#ifdef DEBUG
    isDebug = YES;
#endif
    
    NSDictionary *para = @{@"receipt": receiptString,
                           @"debug": @(isDebug)};
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    
    [ma POST:API_IAPVerify parameters:para completion:^(id data, NSError *error){
        [MBProgressHUD hideHUDForView:wself.viewController.view animated:YES];
        
        if (!error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.viewController.view animated:YES];
            hud.label.text = @"购买成功";
            [hud hideAnimated:YES afterDelay:0.6];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.viewController.view animated:YES];
            hud.label.text = @"购买失败";
            [hud hideAnimated:YES afterDelay:0.6];
        }
    }];
}
@end
