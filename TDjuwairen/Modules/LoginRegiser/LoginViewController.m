//
//  LoginViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "LoginViewController.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "LoginState.h"
#import "MobileLoginViewController.h"
#import "ForgetViewController.h"
#import "AddUpdatesViewController.h"
#import "YXCheckBox.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "NotificationDef.h"
#import "BPush.h"
#import "YXTextFieldPanel.h"
#import "HexColors.h"
#import "LoginHandler.h"
#import "ThirdPartLoginUpdateViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet YXTextFieldPanel *panelView;
@property (nonatomic,strong) IBOutlet UITextField *accountText;
@property (nonatomic,strong) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) IBOutlet YXCheckBox *passwordCheckBox;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    self.panelView.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#eeeeee"].CGColor;
    self.panelView.layer.cornerRadius = 3.0f;
    self.panelView.layer.borderWidth = 1.0f;
    self.panelView.clipsToBounds = YES;
    
    self.loginBtn.layer.cornerRadius = 3.0f;
    self.loginBtn.clipsToBounds = YES;
    
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    __weak LoginViewController *wself = self;
    self.passwordCheckBox.checkedBoxBlock = ^(YXCheckBox *checkBox){
        wself.passwordText.secureTextEntry = !checkBox.checked;
        [wself.passwordText becomeFirstResponder];
    };
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}


- (IBAction)loginBtnPressed:(id)sender
{
    [self.view endEditing:YES];
    
    NSString *account = self.accountText.text;
    NSString *pwd = self.passwordText.text;
    
    if (!account.length || !pwd.length) {
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        
        hud.labelText = @"请输入用户名或手机号和密码";
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [hud hide:YES afterDelay:0.1f];
        }];
        return;
    }
    
    __weak LoginViewController *wself = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"登录中";
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *paras = @{@"account": account,
                            @"password": pwd};
    
    [ma POST:API_Login parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            hud.labelText = @"登录成功";
            [hud hide:YES afterDelay:0.4];
            
            US.isLogIn = YES;
            
            [LoginHandler saveLoginSuccessedData:data];
            [LoginHandler saveLoginAccountId:account password:pwd];
            [LoginHandler checkOpenRemotePush];
            
            [wself.navigationController popToRootViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangedNotification object:nil];
        } else {
            NSString *message = error.localizedDescription?:@"登录失败";
            hud.labelText = message;
            [hud hide:YES afterDelay:0.4];
        }
    }];

}

- (IBAction)mobileLoginPressed:(id)sender
{
    MobileLoginViewController *mobilelogin = [[MobileLoginViewController alloc] init];
    [self.navigationController pushViewController:mobilelogin animated:YES];
}

- (IBAction)forgetPasswordPressed:(id)sender
{
    ForgetViewController *forget = [[ForgetViewController alloc] init];
    [self.navigationController pushViewController:forget animated:YES];
}

- (IBAction)weixinLoginPressed:(id)sender {
    
    __weak LoginViewController *wself = self;
    
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSDictionary *rowData = user.rawData;
             
             NSString *unionid = rowData[@"unionid"];
             NSString *nickName = user.nickname;
             NSString *avatar = user.icon;
             
             NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
             
             
             NSDictionary *dic = @{@"unionid":unionid,
                                   @"nickname" : nickName,
                                   @"avatar_url": avatar};
             
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.labelText = @"登录中...";
             
             [manager POST:API_LoginWithWeixin parameters:dic completion:^(id data, NSError *error){
                 [hud hide:YES];
                 
                 if (!error) {
                     if ([data[@"need_complete"] boolValue] == NO) {
                         US.isLogIn = YES;
                         
                         [LoginHandler saveLoginSuccessedData:data];
                         [LoginHandler saveThirdType:@"weixin" unionid:unionid nickName:nickName avatar:avatar];
                         [LoginHandler checkOpenRemotePush];
                         
                         [wself.navigationController popToRootViewControllerAnimated:YES];
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangedNotification object:nil];
                     } else {
                         // 需要补齐信息
                         US.isLogIn = NO;
                         // 这里要去服务器返回的nickname，因为服务器会检测第三方的nickname 是否重复
                         NSString *userName = data[@"user_nickname"];
                         
                         ThirdPartLoginUpdateViewController *vc = [[UIStoryboard storyboardWithName:@"Register" bundle:nil] instantiateViewControllerWithIdentifier:@"ThirdPartLoginUpdateViewController"];
                         vc.type = kUpdateTypeWeXin;
                         vc.thirdPartId = unionid;
                         vc.thirdPartName = userName;
                         vc.avatar_url = avatar;
                         [self.navigationController pushViewController:vc animated:YES];
                     }
                 } else {
                     NSString *message = error.localizedDescription?:@"登录失败";
                     
                     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     hud.mode = MBProgressHUDModeText;
                     hud.labelText = message;
                     [hud hide:YES afterDelay:0.4];
                 }
             }];
         }
     }];
}

- (IBAction)qqLoginPressed:(id)sender {
    __weak LoginViewController *wself = self;
    
    [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSString *unionid = user.uid;
             NSString *nickName = user.nickname;
             NSString *avatar = user.icon;
             
             NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
             NSDictionary *dic = @{@"unionid":unionid,
                                   @"nickname" : nickName,
                                   @"avatar_url": avatar};
             
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
             hud.labelText = @"登录中...";
             
             [manager POST:API_LoginWithQQ parameters:dic completion:^(id data, NSError *error){
                 [hud hide:YES];
                 
                 if (!error) {
                     if ([data[@"need_complete"] boolValue] == NO) {
                         US.isLogIn = YES;
                         
                         [LoginHandler saveLoginSuccessedData:data];
                         [LoginHandler saveThirdType:@"qq" unionid:unionid nickName:nickName avatar:avatar];
                         [LoginHandler checkOpenRemotePush];
                         
                         [wself.navigationController popToRootViewControllerAnimated:YES];
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangedNotification object:nil];
                     } else {
                         // 需要补齐信息
                         US.isLogIn = NO;
                         // 这里要去服务器返回的nickname，因为服务器会检测第三方的nickname 是否重复
                         NSString *userName = data[@"user_nickname"];
                         
                         ThirdPartLoginUpdateViewController *vc = [[UIStoryboard storyboardWithName:@"Register" bundle:nil] instantiateViewControllerWithIdentifier:@"ThirdPartLoginUpdateViewController"];
                         vc.type = kUpdateTypeQQ;
                         vc.thirdPartId = unionid;
                         vc.thirdPartName = userName;
                         vc.avatar_url = avatar;
                         [self.navigationController pushViewController:vc animated:YES];
                     }
                 } else {
                     NSString *message = error.localizedDescription?:@"登录失败";
                     
                     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     hud.mode = MBProgressHUDModeText;
                     hud.labelText = message;
                     [hud hide:YES afterDelay:0.4];
                 }
             }];
         }
         
     }];
}

@end
