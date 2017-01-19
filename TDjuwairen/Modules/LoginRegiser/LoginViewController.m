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
#import "RegisterViewController.h"
#import "AddUpdatesViewController.h"
#import "YXCheckBox.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "NotificationDef.h"
#import "BPush.h"
#import "YXTextFieldPanel.h"
#import "HexColors.h"

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

- (void)registerPressed:(UIButton *)sender
{
    RegisterViewController *regis = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:regis animated:YES];
}

- (IBAction)loginBtnPressed:(id)sender
{
    [self.view endEditing:YES];
    if (!self.accountText.text.length || !self.passwordText.text.length) {
        
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"登录中";
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *paras = @{@"account":self.accountText.text,
                            @"password":self.passwordText.text};
    [ma POST:@"Login/loginDo" parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            hud.labelText = @"登录成功";
            [hud hide:YES afterDelay:0.4];
            
            
            NSDictionary *dic = data;
            US.userId = dic[@"user_id"];
            US.userName = dic[@"user_name"];
            US.nickName = dic[@"user_nickname"];
            US.userPhone = dic[@"userinfo_phone"];
            US.headImage = dic[@"userinfo_facesmall"];
            US.company = dic[@"userinfo_company"];
            US.post = dic[@"userinfo_occupation"];
            US.personal = dic[@"userinfo_info"];
            
            US.isLogIn=YES;
            
            NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
            [accountDefaults setValue:@"normal" forKey:@"loginStyle"];
            [accountDefaults setValue:self.accountText.text forKey:@"account"];
            [accountDefaults setValue:self.passwordText.text forKey:@"password"];
            [accountDefaults synchronize];
            
            //判断是否开启推送
            UIApplication *app = [UIApplication sharedApplication];
            if ([app isRegisteredForRemoteNotifications]  == YES) {
                [self sendChannel_id];//绑定channel_id
            }
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessedNotification object:nil];
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

- (IBAction)weixinLoginPressed:(id)sender
{    /* 取消授权 */
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
//         NSLog(@"%lu",(unsigned long)state);
         if (state == SSDKResponseStateSuccess)
         {
             NSString *unionid = user.uid;
             
             NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
             NSDictionary *dic = @{@"unionid":unionid};
             
             [manager POST:API_CheckWeixinLogin parameters:dic completion:^(id data, NSError *error){
                 if (!error) {
                     NSDictionary *dic = data;
                     //给loginstate 填充
                     US.userId = dic[@"user_id"];
                     US.userName = dic[@"user_name"];
                     US.nickName = dic[@"user_nickname"];
                     US.userPhone = dic[@"userinfo_phone"];
                     US.headImage = dic[@"userinfo_facesmall"];
                     US.company = dic[@"userinfo_company"];
                     US.post = dic[@"userinfo_occupation"];
                     US.personal = dic[@"userinfo_info"];
                     
                     US.isLogIn = YES;
                     
                     NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
                     [accountDefaults setValue:@"WXlogin" forKey:@"loginStyle"];
                     [accountDefaults setValue:unionid forKey:@"unionid"];
                     [accountDefaults synchronize];

                     if ([dic[@"user_wxunionid"] isEqualToString:@""] ||
                         [dic[@"user_nickname"] isEqualToString:@""] ||
                         [dic[@"user_pwd"] isEqualToString:@""] ||
                         ([dic[@"userinfo_phone"] isEqualToString:@""] && [dic[@"userinfo_email"] isEqualToString:@""])) {

                         AddUpdatesViewController *addview = [[AddUpdatesViewController alloc] init];
                         addview.unionid = unionid;
                         [self.navigationController pushViewController:addview animated:YES];
                     } else {
                         NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
                         NSDictionary *infoDic = @{@"unionid":unionid,
                                                   @"nickname":dic[@"user_nickname"],
                                                   @"password":dic[@"user_pwd"],
                                                   @"email":dic[@"userinfo_email"],
                                                   @"phone":dic[@"userinfo_phone"]};
                         
                         [manager POST:API_LoginWithWeixin parameters:infoDic completion:^(id data, NSError *error){
                             if (!error) {
                                 
                             } else {
                                 
                             }
                         }];
                         UIApplication *app = [UIApplication sharedApplication];
                         if ([app isRegisteredForRemoteNotifications]  == YES) {
                             [self sendChannel_id];//绑定channel_id
                         }
                         
                         [self.navigationController popToRootViewControllerAnimated:YES];
                     }
                     
                 } else {
                     
                 }
             }];
         }
     }];
}

- (IBAction)qqLoginPressed:(id)sender
{     /* 取消授权 */
    [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
//             NSLog(@"uid=%@",user.uid);
//             NSLog(@"%@",user.credential);
//             NSLog(@"token=%@",user.credential.token);
//             NSLog(@"nickname=%@",user.nickname);
//             NSLog(@"icon=%@",user.rawData[@"figureurl_qq_2"]);
             NSString *openid = user.credential.rawData[@"openid"];//rawData 为NSDictionary原始数据
             
             NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
             NSDictionary *dic = @{@"openid":openid};
             
             [manager POST:API_CheckQQLogin parameters:dic completion:^(id data, NSError *error){
                 if (!error) {
                     NSDictionary *dic = data;
                     
                     //给loginstate 填充
                     US.userId = dic[@"user_id"];
                     US.userName = dic[@"user_name"];
                     US.nickName = dic[@"user_nickname"];
                     US.userPhone = dic[@"userinfo_phone"];
                     US.headImage = dic[@"userinfo_facesmall"];
                     US.company = dic[@"userinfo_company"];
                     US.post = dic[@"userinfo_occupation"];
                     US.personal = dic[@"userinfo_info"];
                     
                     US.isLogIn = YES;
                     
                     NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
                     [accountDefaults setValue:@"QQlogin" forKey:@"loginStyle"];
                     [accountDefaults setValue:openid forKey:@"openid"];
                     [accountDefaults synchronize];
                     
                     if ([dic[@"user_qqopenid"] isEqualToString:@""] ||
                         [dic[@"user_nickname"] isEqualToString:@""] ||
                         [dic[@"user_pwd"] isEqualToString:@""] ||
                         ([dic[@"userinfo_phone"] isEqualToString:@""] && [dic[@"userinfo_email"] isEqualToString:@""])) {
                         
                         AddUpdatesViewController *addview = [[AddUpdatesViewController alloc] init];
                         addview.qqopenid = openid;
                         [self.navigationController pushViewController:addview animated:YES];
                     } else {
                         NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
                         NSDictionary *infoDic = @{@"openid":openid,
                                                   @"nickname":dic[@"user_nickname"],
                                                   @"password":dic[@"user_pwd"],
                                                   @"email":dic[@"userinfo_email"],
                                                   @"phone":dic[@"userinfo_phone"]};

                         
                         [manager POST:API_LoginWithQQ parameters:infoDic completion:^(id data, NSError *error){
                             if (!error) {
                                 
                             } else {
                                 
                             }
                         }];
                         
                         UIApplication *app = [UIApplication sharedApplication];
                         if ([app isRegisteredForRemoteNotifications]  == YES) {
                             [self sendChannel_id];//绑定channel_id
                         }
                         
                         [self.navigationController popToRootViewControllerAnimated:YES];
                     }
                     
                 } else {
                     
                 }
             }];
         }
         
     }];
}

#pragma mark - 发送channel_id
- (void)sendChannel_id{
    NSString *channel_id = [BPush getChannelId];
    NSString *url = @"index.php/Login/saveUserChannelID";
    NetworkManager *manager = [[NetworkManager alloc]initWithBaseUrl:API_HOST];
    NSDictionary *para = @{@"user_id":US.userId,
                           @"type":@"1",
                           @"channel_id":channel_id};
    [manager POST:url parameters:para completion:^(id data, NSError *error) {
        NSLog(@"%@",data);
        //绑定指定推送的时候打开回复提醒
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        [userdefault setValue:@"YES" forKey:@"isReply"];
        [userdefault synchronize];
    }];
}

@end
