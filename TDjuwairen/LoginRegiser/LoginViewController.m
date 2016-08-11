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

@interface LoginViewController ()

@property (nonatomic,strong) LoginState *loginState;
@property (nonatomic,strong) UITextField *accountText;
@property (nonatomic,strong) UITextField *passwordText;

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
    [self setupWithLogoImage];
    [self setupWithTextView];
    [self setupWithLogin];
    [self setupWithMobileAndForget];//短信验证和忘记密码
    [self setupWithQQWXLogin];//第三方登录
    // Do any additional setup after loading the view.
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

- (void)setupWithNavigation{
    
    //设置右边注册按钮
    UIBarButtonItem *regist = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(ClickRegister:)];
    self.navigationItem.rightBarButtonItem = regist;
}

- (void)setupWithLogoImage{
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/8*3)];
    imageview.contentMode = UIViewContentModeCenter;
    imageview.image = [UIImage imageNamed:@"logo.png"];
    [self.view addSubview:imageview];
}

- (void)setupWithTextView{
    self.accountText = [[UITextField alloc]initWithFrame:CGRectMake(0, kScreenWidth/8*3, kScreenWidth, 47)];
    self.accountText.backgroundColor = [UIColor whiteColor];
    self.accountText.textColor = [UIColor darkGrayColor];
    self.accountText.font = [UIFont systemFontOfSize:14];
    self.accountText.placeholder = @"手机号/用户名";
    self.accountText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.accountText.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordText = [[UITextField alloc]initWithFrame:CGRectMake(0, kScreenWidth/8*3+47+1, kScreenWidth, 47)];
    self.passwordText.backgroundColor = [UIColor whiteColor];
    self.passwordText.textColor = [UIColor darkGrayColor];
    self.passwordText.font = [UIFont systemFontOfSize:14];
    self.passwordText.placeholder = @"密码";
    self.passwordText.clearButtonMode = UITextFieldViewModeAlways;//右边X号
    self.passwordText.secureTextEntry = YES;//显示为星号
    self.passwordText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.passwordText.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:self.accountText];
    [self.view addSubview:self.passwordText];
}

- (void)setupWithLogin{
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, kScreenWidth/8*3+47+47+1+30, kScreenWidth-30, 50)];
    loginBtn.backgroundColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 5;//圆角半径
    [loginBtn addTarget:self action:@selector(GoLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)setupWithMobileAndForget{
    UIButton *mobile = [[UIButton alloc]initWithFrame:CGRectMake(15, kScreenWidth/8*3+47+47+1+80+8, 120, 14)];
    [mobile setTitle:@"手机短信验证登录" forState:UIControlStateNormal];
    mobile.titleLabel.font = [UIFont systemFontOfSize:14];
    mobile.titleLabel.textAlignment = NSTextAlignmentLeft;
    [mobile setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateNormal];
    [mobile addTarget:self action:@selector(ClickMobileLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *forget = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-15-80, kScreenWidth/8*3+47+47+1+80+8, 80, 14)];
    [forget setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forget.titleLabel.font = [UIFont systemFontOfSize:14];
    forget.titleLabel.textAlignment = NSTextAlignmentRight;
    [forget setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateNormal];
    [forget addTarget:self action:@selector(ClickForget:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:mobile];
    [self.view addSubview:forget];
}

- (void)setupWithQQWXLogin{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/3, kScreenWidth/8*3+47+47+1+80+8+14+40, kScreenWidth/3, 14)];
    label.text = @"第三方登录";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label];
    
    UIButton *WXLogin = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-120)/3, kScreenWidth/8*3+47+47+1+80+8+14+40+14+30, 60, 60)];
    [WXLogin setBackgroundImage:[UIImage imageNamed:@"WXlogin"] forState:UIControlStateNormal];
    WXLogin.layer.cornerRadius = 30;
    [WXLogin addTarget:self action:@selector(WXlogin:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *QQLogin = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-120)/3*2+60, kScreenWidth/8*3+47+47+1+80+8+14+40+14+30, 60, 60)];
    [QQLogin setBackgroundImage:[UIImage imageNamed:@"QQlogin"] forState:UIControlStateNormal];
    QQLogin.layer.cornerRadius = 30;
    [QQLogin addTarget:self action:@selector(QQlogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:WXLogin];
    [self.view addSubview:QQLogin];
}

//- (BOOL)prefersStatusBarHidden {
//    return NO;
//}

#pragma mark - 点击注册
- (void)ClickRegister:(UIButton *)sender{
    //
    RegisterViewController *regis = [self.storyboard instantiateViewControllerWithIdentifier:@"regis"];
    [self.navigationController pushViewController:regis animated:YES];
}

#pragma mark - 点击登录
- (void)GoLogin:(UIButton *)sender{
    //
    if ([self.accountText.text isEqualToString:@""]||[self.passwordText.text isEqualToString:@""]) {
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入用户名或手机号和密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *conformAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [aler addAction:conformAction];
        [self presentViewController:aler animated:YES completion:nil];
    }
    else{
        AFHTTPRequestOperationManager*manager=[[AFHTTPRequestOperationManager alloc]init];
        manager.responseSerializer = [AFJSONResponseSerializer  serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString *url = [NSString stringWithFormat:@"%@Login/loginDo",kAPI_bendi];
        NSDictionary *paras = @{@"account":self.accountText.text,
                                @"password":self.passwordText.text};
        
        [manager POST:url parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString*code=[responseObject objectForKey:@"code"];
            if ([code isEqualToString:@"200"]) {
                NSLog(@"登陆成功");
                
                NSDictionary *dic = responseObject[@"data"];
                NSLog(@"%@",dic);
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
            }
            else
            {
                UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *conformAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [aler addAction:conformAction];
                [self presentViewController:aler animated:YES completion:nil];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败!请检查网络链接!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *conformAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            
            [aler addAction:conformAction];
            [self presentViewController:aler animated:YES completion:nil];
        }];
    }
}

#pragma mark - 手机短信登录
- (void)ClickMobileLogin:(UIButton *)sender{
    MobileLoginViewController *mobilelogin = [self.storyboard instantiateViewControllerWithIdentifier:@"mobilelogin"];
    [self.navigationController pushViewController:mobilelogin animated:YES];
}

#pragma mark - 忘记密码
- (void)ClickForget:(UIButton *)sender{
    ForgetViewController *forget = [self.storyboard instantiateViewControllerWithIdentifier:@"forget"];
    [self.navigationController pushViewController:forget animated:YES];
}

#pragma mark - wx登录
- (void)WXlogin:(UIButton *)sender{
    /* 取消授权 */
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

- (void)QQlogin:(UIButton *)sender{
    /* 取消授权 */
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
