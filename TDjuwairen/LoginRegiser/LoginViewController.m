//
//  LoginViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "LoginViewController.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "AFNetworking.h"

#import "LoginState.h"
#import "MobileLoginViewController.h"
#import "ForgetViewController.h"
#import "RegisterViewController.h"
#import "AddUpdatesViewController.h"
#import "YXCheckBox.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"

@interface LoginViewController ()

@property (nonatomic,strong) LoginState *loginState;
@property (nonatomic,strong) IBOutlet UITextField *accountText;
@property (nonatomic,strong) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) IBOutlet YXCheckBox *passwordCheckBox;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
    self.loginState = [LoginState addInstance];
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [self setupWithNavigation];
    
    __weak LoginViewController *wself = self;
    self.passwordCheckBox.checkedBoxBlock = ^(BOOL checked){
        wself.passwordText.secureTextEntry = !checked;
        [wself.passwordText becomeFirstResponder];
    };
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

- (void)setupWithNavigation
{
    //设置右边注册按钮
    UIBarButtonItem *regist = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(registerPressed:)];
    self.navigationItem.rightBarButtonItem = regist;
}

- (void)registerPressed:(UIButton *)sender
{
    RegisterViewController *regis = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"regis"];
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
            self.loginState.userId = dic[@"user_id"];
            self.loginState.userName = dic[@"user_name"];
            self.loginState.nickName = dic[@"user_nickname"];
            self.loginState.userPhone = dic[@"userinfo_phone"];
            self.loginState.headImage = dic[@"userinfo_facesmall"];
            self.loginState.company = dic[@"userinfo_company"];
            self.loginState.post = dic[@"userinfo_occupation"];
            self.loginState.personal = dic[@"userinfo_info"];
            
            self.loginState.isLogIn=YES;
            
            NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
            [accountDefaults setValue:@"normal" forKey:@"loginStyle"];
            [accountDefaults setValue:self.accountText.text forKey:@"account"];
            [accountDefaults setValue:self.passwordText.text forKey:@"password"];
            [accountDefaults synchronize];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            NSString *message = error.localizedDescription?:@"登录失败";
            hud.labelText = message;
            [hud hide:YES afterDelay:0.4];
        }
    }];

}

- (IBAction)mobileLoginPressed:(id)sender
{
    MobileLoginViewController *mobilelogin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mobilelogin"];
    [self.navigationController pushViewController:mobilelogin animated:YES];
}

- (IBAction)forgetPasswordPressed:(id)sender
{
    ForgetViewController *forget = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"forget"];
    [self.navigationController pushViewController:forget animated:YES];
}

- (IBAction)weixinLoginPressed:(id)sender
{    /* 取消授权 */
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         NSLog(@"%lu",(unsigned long)state);
         if (state == SSDKResponseStateSuccess)
         {
             NSLog(@"uid=%@",user.uid);
//             NSLog(@"%@",user.credential);
//             NSLog(@"token=%@",user.credential.token);
//             NSLog(@"nickname=%@",user.nickname);
             NSString *unionid = user.uid;
             NSDictionary *dic = @{@"unionid":unionid};
             NSString *url = [NSString stringWithFormat:@"%@Login/checkWXAccount1_2",kAPI_bendi];
             AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
             manager.responseSerializer = [AFJSONResponseSerializer serializer];
             manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
             [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSDictionary *dic = responseObject[@"data"];
                 NSLog(@"%@",dic);
                 if ([dic[@"user_wxunionid"] isEqualToString:@""] ||
                     [dic[@"user_nickname"] isEqualToString:@""] ||
                     [dic[@"user_pwd"] isEqualToString:@""] ||
                     ([dic[@"userinfo_phone"] isEqualToString:@""] && [dic[@"userinfo_email"] isEqualToString:@""])) {
                     //跳转到补全页面
                     //给loginstate 填充
                     self.loginState.userId = dic[@"user_id"];
                     self.loginState.userName = dic[@"user_name"];
                     self.loginState.nickName = dic[@"user_nickname"];
                     self.loginState.userPhone = dic[@"userinfo_phone"];
                     self.loginState.headImage = dic[@"userinfo_facesmall"];
                     self.loginState.company = dic[@"userinfo_company"];
                     self.loginState.post = dic[@"userinfo_occupation"];
                     self.loginState.personal = dic[@"userinfo_info"];
                     
                     self.loginState.isLogIn = YES;
                     
                     NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
                     [accountDefaults setValue:@"WXlogin" forKey:@"loginStyle"];
                     [accountDefaults setValue:unionid forKey:@"unionid"];
                     [accountDefaults synchronize];
                     
                     AddUpdatesViewController *addview = [self.storyboard instantiateViewControllerWithIdentifier:@"addupdates"];
                     addview.unionid = unionid;
                     [self.navigationController pushViewController:addview animated:YES];
                 }
                 else
                 {
                     //给loginstate 填充
                     self.loginState.userId = dic[@"user_id"];
                     self.loginState.userName = dic[@"user_name"];
                     self.loginState.nickName = dic[@"user_nickname"];
                     self.loginState.userPhone = dic[@"userinfo_phone"];
                     self.loginState.headImage = dic[@"userinfo_facesmall"];
                     self.loginState.company = dic[@"userinfo_company"];
                     self.loginState.post = dic[@"userinfo_occupation"];
                     self.loginState.personal = dic[@"userinfo_info"];
                     
                     self.loginState.isLogIn = YES;
                     
                     NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
                     [accountDefaults setValue:@"WXlogin" forKey:@"loginStyle"];
                     [accountDefaults setValue:unionid forKey:@"unionid"];
                     [accountDefaults synchronize];
                     //允许登录
                     NSLog(@"登录成功");
                     NSString *updateurl = [NSString stringWithFormat:@"%@Login/WXLoginDo1_2",kAPI_bendi];
                     NSDictionary *infoDic = @{@"unionid":unionid,
                                               @"nickname":dic[@"user_nickname"],
                                               @"password":dic[@"user_pwd"],
                                               @"email":dic[@"userinfo_email"],
                                               @"phone":dic[@"userinfo_phone"]};
                     AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
                     manager.responseSerializer = [AFJSONResponseSerializer serializer];
                     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                     [manager POST:updateurl parameters:infoDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSLog(@"成功");
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"信息更新失败");
                     }];
                     [self.navigationController popToRootViewControllerAnimated:YES];
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"请求失败");
             }];
         }
         else
         {
             NSLog(@"%@",error);
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
             NSLog(@"%@",openid);
             NSDictionary *dic = @{@"openid":openid};
             NSString *url = [NSString stringWithFormat:@"%@Login/checkQQAccount1_2",kAPI_bendi];
             AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
             manager.responseSerializer = [AFJSONResponseSerializer serializer];
             manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
             [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 //
                 NSDictionary *dic = responseObject[@"data"];
                 NSLog(@"%@",dic);
                 if ([dic[@"user_qqopenid"] isEqualToString:@""] ||
                     [dic[@"user_nickname"] isEqualToString:@""] ||
                     [dic[@"user_pwd"] isEqualToString:@""] ||
                     ([dic[@"userinfo_phone"] isEqualToString:@""] && [dic[@"userinfo_email"] isEqualToString:@""])) {
                     //跳转到补全页面
                     //给loginstate 填充
                     self.loginState.userId = dic[@"user_id"];
                     self.loginState.userName = dic[@"user_name"];
                     self.loginState.nickName = dic[@"user_nickname"];
                     self.loginState.userPhone = dic[@"userinfo_phone"];
                     self.loginState.headImage = dic[@"userinfo_facesmall"];
                     self.loginState.company = dic[@"userinfo_company"];
                     self.loginState.post = dic[@"userinfo_occupation"];
                     self.loginState.personal = dic[@"userinfo_info"];
                     self.loginState.isLogIn = YES;
                     
                     NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
                     [accountDefaults setValue:@"QQlogin" forKey:@"loginStyle"];
                     [accountDefaults setValue:openid forKey:@"openid"];
                     [accountDefaults synchronize];
                     
                     AddUpdatesViewController *addview = [self.storyboard instantiateViewControllerWithIdentifier:@"addupdates"];
                     addview.qqopenid = openid;
                     [self.navigationController pushViewController:addview animated:YES];
                 }
                 else
                 {
                     //给loginstate 填充
                     self.loginState.userId = dic[@"user_id"];
                     self.loginState.userName = dic[@"user_name"];
                     self.loginState.nickName = dic[@"user_nickname"];
                     self.loginState.userPhone = dic[@"userinfo_phone"];
                     self.loginState.headImage = dic[@"userinfo_facesmall"];
                     self.loginState.company = dic[@"userinfo_company"];
                     self.loginState.post = dic[@"userinfo_occupation"];
                     self.loginState.personal = dic[@"userinfo_info"];
                     
                     self.loginState.isLogIn = YES;
                     
                     NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
                     [accountDefaults setValue:@"QQlogin" forKey:@"loginStyle"];
                     [accountDefaults setValue:openid forKey:@"openid"];
                     [accountDefaults synchronize];
                     //允许登录
                     NSLog(@"登录成功");
                     NSString *updateurl = [NSString stringWithFormat:@"%@Login/qqLoginDo1_2",kAPI_bendi];
                     NSDictionary *infoDic = @{@"openid":openid,
                                               @"nickname":dic[@"user_nickname"],
                                               @"password":dic[@"user_pwd"],
                                               @"email":dic[@"userinfo_email"],
                                               @"phone":dic[@"userinfo_phone"]};
                     AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
                     manager.responseSerializer = [AFJSONResponseSerializer serializer];
                     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                     [manager POST:updateurl parameters:infoDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSLog(@"成功");
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"信息更新失败");
                     }];
                     [self.navigationController popToRootViewControllerAnimated:YES];
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"请求失败");
             }];
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
