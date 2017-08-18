//
//  ForgetViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ForgetViewController.h"
#import "LoginStateManager.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "YXSecurityCodeButton.h"
#import "NSString+Util.h"
#import "LoginHandler.h"
#import "NotificationDef.h"

@interface ForgetViewController ()<YXSecurityCodeButtonDelegate>

@property (nonatomic,strong) UITextField *accountText;
@property (nonatomic,strong) UITextField *validationText;
@property (nonatomic,strong) YXSecurityCodeButton *validationBtn;
@property (nonatomic,strong) UITextField *passwordText;
@property (nonatomic,strong) UITextField *surePassword;
@property (nonatomic,strong) NSString *str;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TDViewBackgrouondColor;
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [self setupWithNavigation];
    [self setupWithTextField];
    [self setupWithSubmit];//提交
    
    // Do any additional setup after loading the view.
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

- (void)setupWithNavigation{
    //设置navigation背景色
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    self.title = @"找回密码";
    // 设置标题颜色，和大小,如果标题是使用titleView方式定义不行
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    
}

- (void)setupWithTextField{
    self.accountText = [[UITextField alloc]initWithFrame:CGRectMake(0, 16, kScreenWidth, 47)];
    self.accountText.backgroundColor = [UIColor whiteColor];
    self.accountText.textColor = [UIColor darkGrayColor];
    self.accountText.font = [UIFont systemFontOfSize:14];
    self.accountText.placeholder = @"手机号";
    self.accountText.keyboardType = UIKeyboardTypePhonePad;
    self.accountText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.accountText.leftViewMode = UITextFieldViewModeAlways;
    
    self.validationText = [[UITextField alloc]initWithFrame:CGRectMake(0, 16+47+1, kScreenWidth, 47)];
    self.validationText.backgroundColor = [UIColor whiteColor];
    self.validationText.textColor = [UIColor darkGrayColor];
    self.validationText.font = [UIFont systemFontOfSize:14];
    self.validationText.placeholder = @"请输入验证码";
    self.validationText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.validationText.leftViewMode = UITextFieldViewModeAlways;
    self.validationText.keyboardType = UIKeyboardTypeNumberPad;
    
    self.validationBtn = [[YXSecurityCodeButton alloc]initWithFrame:CGRectMake(kScreenWidth-8-100, 16+47+1, 100, 47)];
    self.validationBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.validationBtn.delegate = self;
    
    self.passwordText = [[UITextField alloc]initWithFrame:CGRectMake(0, 16+47+1+47+1, kScreenWidth, 47)];
    self.passwordText.backgroundColor = [UIColor whiteColor];
    self.passwordText.textColor = [UIColor darkGrayColor];
    self.passwordText.font = [UIFont systemFontOfSize:14];
    self.passwordText.placeholder = @"密码";
    self.passwordText.clearButtonMode = UITextFieldViewModeAlways;//右边X号
    self.passwordText.secureTextEntry = YES;//显示为星号
    self.passwordText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.passwordText.leftViewMode = UITextFieldViewModeAlways;
    
    self.surePassword = [[UITextField alloc]initWithFrame:CGRectMake(0, 16+47+1+47+1+47+1, kScreenWidth, 47)];
    self.surePassword.backgroundColor = [UIColor whiteColor];
    self.surePassword.textColor = [UIColor darkGrayColor];
    self.surePassword.font = [UIFont systemFontOfSize:14];
    self.surePassword.placeholder = @"请再次输入密码";
    self.surePassword.clearButtonMode = UITextFieldViewModeAlways;//右边X号
    self.surePassword.secureTextEntry = YES;//显示为星号
    self.surePassword.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.surePassword.leftViewMode = UITextFieldViewModeAlways;
    
    self.accountText.backgroundColor = [UIColor whiteColor];
    self.accountText.textColor = TDTitleTextColor;
    self.validationText.textColor = TDTitleTextColor;
    self.passwordText.textColor = TDTitleTextColor;
    self.surePassword.textColor = TDTitleTextColor;
    
    [self.view addSubview:self.accountText];
    [self.view addSubview:self.validationText];
    [self.view addSubview:self.validationBtn];
    [self.view addSubview:self.passwordText];
    [self.view addSubview:self.surePassword];
}

- (void)setupWithSubmit{
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 16+47+1+47+1+47+1+47+30, kScreenWidth-30, 50)];
    submitBtn.backgroundColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 5;//圆角半径
    [submitBtn addTarget:self action:@selector(ClickSubmit:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *service = [[UIButton alloc]initWithFrame:CGRectMake(15, 16+47+1+47+1+47+1+47+30+50+10, kScreenWidth-30, 14)];
    [service setTitle:@"没有绑定手机号码？点击联系客服" forState:UIControlStateNormal];
    service.titleLabel.font = [UIFont systemFontOfSize:14];
    [service setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [service addTarget:self action:@selector(contactCS:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:submitBtn];
    [self.view addSubview:service];
}

#pragma mark -YXSecurityCodeButtonDelegate
- (NSString *)codeWithPhone {
    NSString *phone = self.accountText.text;
    return phone;
}

- (PhoneCodeType)codeType {
    return kPhoneCodeForFind;
}


- (void)ClickSubmit:(UIButton *)sender{
    
    NSString *phone = self.accountText.text;
    NSString *code = self.validationText.text;
    NSString *pwd = self.passwordText.text;
    NSString *pwd2 = self.surePassword.text;
    NSString *msg_unique_id = self.validationBtn.msg_unique_id;
   
    if(![phone isValidateMobile]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = (phone.length==0)?@"手机号不能为空":@"手机号格式错误";
        [hud hideAnimated:YES afterDelay:0.4];
        return;
    } else if (!msg_unique_id.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"验证码有误";
        [hud hideAnimated:YES afterDelay:0.4];
        return;
    } else if (!code.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请先填写验证码";
        [hud hideAnimated:YES afterDelay:0.4];
        return;
    } else if (!pwd.length || !pwd2.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请先填写密码";
        [hud hideAnimated:YES afterDelay:0.4];
        return;
    } else if (![pwd isEqualToString:pwd2]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"两次密码输入不一致";
        [hud hideAnimated:YES afterDelay:0.4];
        return;
    }
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.label.text = @"提交中...";
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *dic = @{@"msg_unique_id": msg_unique_id,
                          @"msg_code": code};
    
    [manager POST:API_LoginCheckPhoneCode parameters:dic completion:^(id data, NSError *error){
        if (data) {
            BOOL is_expire = [data[@"is_expire"] boolValue];
            BOOL is_verify = [data[@"is_verify"] boolValue];
            
            if (is_verify) {
                [self submitUserinfo];
            } else {
                self.hud.label.text = is_expire?@"验证码过期，请重新获取":@"验证码错误，请重新输入";
                [self.hud hideAnimated:YES afterDelay:0.4];
            }
        } else {
            self.hud.label.text = @"验证码错误，请重新输入";
            [self.hud hideAnimated:YES afterDelay:0.4];
        }
    }];
}

- (void)submitUserinfo{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *para = @{@"validatestring":self.accountText.text};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = data;
            self.str = dic[@"str"];
            [self submit];
        } else {
            self.hud.label.text = @"提交失败";
            [self.hud hideAnimated:YES afterDelay:0.5];
        }
    }];
}

- (void)submit{
    NSString *phone = self.accountText.text;
    NSString *pwd = self.passwordText.text;
    NSString *msg_unique_id = self.validationBtn.msg_unique_id;
    
    NSString *ecriptPwd = [LoginHandler encryptWithPassword:pwd];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *paras = @{@"authenticationStr": phone,
                            @"encryptedStr":self.str,
                            @"telephone": phone,
                            @"password": ecriptPwd,
                            @"msg_unique_id" : msg_unique_id
                            };
    
    [manager POST:API_ResetPasswordk parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            [self.hud hideAnimated:YES];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //登录
                [self requestLoging];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            NSString *message = error.localizedDescription?:@"修改密码失败";
            self.hud.label.text = message;
            [self.hud hideAnimated:YES afterDelay:0.4];
        }
    }];
    
}

#pragma mark - 登录
- (void)requestLoging{
    NSString *phone = self.accountText.text;
    NSString *pwd = self.passwordText.text;
    
    NSString *ecriptPwd = [LoginHandler encryptWithPassword:pwd];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"登录中";
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *paras = @{@"account": phone,
                            @"password": ecriptPwd};
    
    [ma POST:API_Login parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            hud.label.text = @"登录成功";
            [hud hideAnimated:YES afterDelay:0.4];
            
            US.isLogIn = YES;
            
            [LoginHandler saveLoginSuccessedData:data];
            [LoginHandler saveLoginAccountId:phone password:pwd];
            [LoginHandler checkOpenRemotePush];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangedNotification object:nil];
        } else {
            NSString *message = error.localizedDescription?:@"登录失败";
            hud.label.text = message;
            [hud hideAnimated:YES afterDelay:0.4];
        }
    }];
}

- (void)contactCS:(UIButton *)sender{
    NSURL *url = [NSURL URLWithString:@"telprompt://0571-86716203"];
    [[UIApplication sharedApplication] openURL:url];
}

@end
