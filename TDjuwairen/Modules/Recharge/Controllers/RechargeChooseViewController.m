//
//  RechargeChooseViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "RechargeChooseViewController.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "STPopup.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface RechargeChooseViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end

@implementation RechargeChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.contentSizeInPopup = CGSizeMake(260, 150);
}

- (IBAction)zhifbaoPressed:(id)sender {
    NSDictionary *dic = @{@"type":    @(self.type),
                          @"number":  @(self.keyNumber),
                          @"version": @"1.0",
                          @"user_id": US.userId};
    

    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_AliPay parameters:dic completion:^(id data, NSError *error){
        if (!error && data) {
            if ([data isKindOfClass:[NSString class]]) {
                NSString *orderString = data;
                NSString *appScheme = @"TDjuwairen";
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    //                DDLogInfo(@"reslut = %@",resultDic);
                    
                }];
                
                
            } else {
                
            }
        } else {
            
        }
        
        [self.popupController dismiss];
    }];
}

- (IBAction)wexinPressed:(id)sender {
    NSDictionary *dic = @{@"type":    @(self.type),
                          @"number":  @(self.keyNumber),
                          @"device": @"1",
                          @"user_id": US.userId};
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_WXPay parameters:dic completion:^(id data, NSError *error){
        if (!error && data) {
            
            NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *order = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:&err];
            if (!error) {
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = [order objectForKey:@"appid"];
                req.partnerId           = [order objectForKey:@"mch_id"];
                req.prepayId            = [order objectForKey:@"prepay_id"];
                req.nonceStr            = [order objectForKey:@"nonce_str"];
                req.timeStamp           = [[order objectForKey:@"timestamp"] intValue];
                req.package             = @"Sign=WXPay";
                req.sign                = [order objectForKey:@"sign"];
                
                [WXApi sendReq:req];
            } else {
                
            }
        }
        
        [self.popupController dismiss];
    }];
}

@end
