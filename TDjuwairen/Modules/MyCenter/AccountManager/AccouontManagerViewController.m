//
//  AccouontManagerViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/2/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AccouontManagerViewController.h"
#import "UIMacroDef.h"
#import "LoginStateManager.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "HexColors.h"
#import "ChangePhoneViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface AccouontManagerViewController ()
@property (nonatomic, strong) NSString *str;
@property (nonatomic, assign) BOOL isBindingWeixin;
@property (nonatomic, assign) BOOL isBindingQQ;
@property (nonatomic, copy) NSString *bindPhone;
@end

@implementation AccouontManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    
    [self queryBindingAccount];
    [self requestAuthentication];
}

-(void)requestAuthentication
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *para = @{@"validatestring": US.userId};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = data;
            self.str = dic[@"str"];
        } else {
            
        }
    }];
}

- (void)queryBindingAccount {
    
    __weak AccouontManagerViewController *wself = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    void (^queryBindInfo)(NSString *) = ^(NSString *string){
        NSDictionary*paras=@{@"authenticationStr":US.userId,
                             @"encryptedStr": string,
                             @"userid":US.userId};
        
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        [manager POST:API_UserBindInfo parameters:paras completion:^(id data, NSError *error){
            if (!error) {
                [hud hide:YES];
                
                wself.bindPhone = data[@"userinfo_phone"];
                wself.isBindingWeixin = [data[@"is_wx_bind"] boolValue];
                wself.isBindingQQ = [data[@"is_qq_bind"] boolValue];
                [wself.tableView reloadData];
            } else {
                hud.labelText = @"加载失败";
                [hud hide:YES];
            }
        }];
    };
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*para = @{@"validatestring":US.userId};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSString *string = data[@"str"];
            
            queryBindInfo(string);
        } else {
            
        }
    }];
}

- (void)bindWeixin {
    __weak AccouontManagerViewController *wself = self;
    
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSDictionary *rowData = user.rawData;
             
             NSString *unionid = rowData[@"unionid"];
             
             NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
             
             NSDictionary *dic = @{@"unionid": unionid,
                                   @"authenticationStr": US.userId,
                                   @"encryptedStr":self.str,
                                   @"userid": US.userId};
             
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.labelText = @"绑定中...";
             
             [manager POST:API_BindWeixin parameters:dic completion:^(id data, NSError *error){
                 [hud hide:YES];
                 
                 if (!error && [data[@"status"] boolValue]) {
                     NSString *message = error.localizedDescription?:@"绑定成功";
                     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     hud.mode = MBProgressHUDModeText;
                     hud.labelText = message;
                     [hud hide:YES afterDelay:0.4];
                     
                     wself.isBindingWeixin = YES;
                     [wself.tableView reloadData];
                 } else {
                     NSString *message = error.localizedDescription?:@"绑定失败";
                     
                     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     hud.mode = MBProgressHUDModeText;
                     hud.labelText = message;
                     [hud hide:YES afterDelay:0.6];
                 }
             }];
         }
     }];
}

- (void)unbindWeixin {
    __weak AccouontManagerViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    
    NSDictionary *dic = @{@"authenticationStr": US.userId,
                          @"encryptedStr":self.str,
                          @"userid": US.userId};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"解绑中...";
    
    [manager POST:API_UnbindWeixin parameters:dic completion:^(id data, NSError *error){
        [hud hide:YES];
        
        if (!error && [data[@"status"] boolValue]) {
            NSString *message = error.localizedDescription?:@"解绑成功";
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = message;
            [hud hide:YES afterDelay:0.4];
            
            wself.isBindingWeixin = NO;
            [wself.tableView reloadData];
        } else {
            NSString *message = error.localizedDescription?:@"解绑失败";
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = message;
            [hud hide:YES afterDelay:0.6];
        }
    }];
}

- (void)bindQQ {
    __weak AccouontManagerViewController *wself = self;
    
    [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSString *unionid = user.uid;
             
             NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
             NSDictionary *dic = @{@"unionid": unionid,
                                   @"authenticationStr": US.userId,
                                   @"encryptedStr":self.str,
                                   @"userid": US.userId};
             
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.labelText = @"绑定中...";
             
             [manager POST:API_BindQQ parameters:dic completion:^(id data, NSError *error){
                 [hud hide:YES];
                 
                 if (!error && [data[@"status"] boolValue]) {
                     NSString *message = error.localizedDescription?:@"绑定成功";
                     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     hud.mode = MBProgressHUDModeText;
                     hud.labelText = message;
                     [hud hide:YES afterDelay:0.4];
                     
                     wself.isBindingQQ = YES;
                     [wself.tableView reloadData];
                 } else {
                     NSString *message = error.localizedDescription?:@"绑定失败";
                     
                     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     hud.mode = MBProgressHUDModeText;
                     hud.labelText = message;
                     [hud hide:YES afterDelay:0.6];
                 }
             }];
         }
         
     }];
}

- (void)unbindQQ {
    __weak AccouontManagerViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *dic = @{@"authenticationStr": US.userId,
                          @"encryptedStr":self.str,
                          @"userid": US.userId};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"解绑中...";
    
    [manager POST:API_UnbindQQ parameters:dic completion:^(id data, NSError *error){
        [hud hide:YES];
        
        if (!error && [data[@"status"] boolValue]) {
            NSString *message = error.localizedDescription?:@"解绑成功";
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = message;
            [hud hide:YES afterDelay:0.4];
            
            wself.isBindingQQ = NO;
            [wself.tableView reloadData];
        } else {
            NSString *message = error.localizedDescription?:@"解绑失败";
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = message;
            [hud hide:YES afterDelay:0.6];
        }
    }];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ 更换",self.bindPhone];
    } else if (indexPath.row == 1) {
        if (self.isBindingWeixin) {
            cell.detailTextLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
            cell.detailTextLabel.text = @"解除绑定";
        } else {
            cell.detailTextLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#3371e2"];
            cell.detailTextLabel.text = @"立即绑定";
        }
        
    } else if (indexPath.row == 2) {
        if (self.isBindingQQ) {
            cell.detailTextLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
            cell.detailTextLabel.text = @"解除绑定";
        } else {
            cell.detailTextLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#3371e2"];
            cell.detailTextLabel.text = @"立即绑定";
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        ChangePhoneViewController *vc = [[ChangePhoneViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        if (self.isBindingWeixin) {
            [self unbindWeixin];
        } else {
            [self bindWeixin];
        }
        
    } else if (indexPath.row == 2) {
        if (self.isBindingQQ) {
            [self unbindQQ];
        } else {
            [self bindQQ];
        }
    }
}
@end
