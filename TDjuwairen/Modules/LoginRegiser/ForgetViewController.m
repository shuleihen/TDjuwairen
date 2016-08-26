//
//  ForgetViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ForgetViewController.h"
#import "LoginState.h"
#import "NetworkManager.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIStoryboard+MainStoryboard.h"
#import <SMS_SDK/SMSSDK.h>

@interface ForgetViewController ()

@property (nonatomic,strong) UITextField *accountText;
@property (nonatomic,strong) UITextField *validationText;
@property (nonatomic,strong) UIButton *validationBtn;
@property (nonatomic,strong) UITextField *passwordText;
@property (nonatomic,strong) NSString *str;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
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
    //    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    self.accountText.placeholder = @"手机号/用户名";
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
    //竖线
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-8-101, 16+47+1+18, 1, 12)];
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 1.0;
    
    self.validationBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-8-100, 16+47+1, 100, 47)];
    self.validationBtn.backgroundColor = [UIColor clearColor];
    [self.validationBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.validationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.validationBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateNormal];
    //验证码的监听事件
    [self.validationBtn addTarget:self action:@selector(Verification) forControlEvents:UIControlEventTouchUpInside];
    [self.validationBtn addTarget:self action:@selector(ClickSend:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    [self.view addSubview:self.accountText];
    [self.view addSubview:self.validationText];
    [self.view addSubview:self.validationBtn];
    [self.view addSubview:label];
    [self.view addSubview:self.passwordText];
}

#pragma mark - 点击提交
- (void)setupWithSubmit{
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 16+47+1+47+1+47+30, kScreenWidth-30, 50)];
    submitBtn.backgroundColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 5;//圆角半径
    [submitBtn addTarget:self action:@selector(ClickSubmit:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *service = [[UIButton alloc]initWithFrame:CGRectMake(15, 16+47+1+47+1+47+30+50+10, kScreenWidth-30, 14)];
    [service setTitle:@"没有绑定手机号码/邮箱？点击联系客服" forState:UIControlStateNormal];
    service.titleLabel.font = [UIFont systemFontOfSize:14];
    [service setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [service addTarget:self action:@selector(contactCS:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:submitBtn];
    [self.view addSubview:service];
}

- (void)ClickSubmit:(UIButton *)sender{
    //判断
    if ([self.accountText.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入手机号" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }else if ([self.validationText.text isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        return;
    }else if ([self.passwordText.text isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        return;
    }
    else
    {
        [SMSSDK commitVerificationCode:self.validationText.text phoneNumber:self.accountText.text zone:@"86" result:^(NSError *error) {
            if (!error) {
                //提交修改信息
                [self SubmitUserinfo];
            } else {
                NSLog(@"错误信息：%@",error);
                if ([self.validationText.text isEqualToString:@""]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码为空" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码错误，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        }];
    }
}

- (void)SubmitUserinfo{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *para = @{@"validatestring":self.accountText.text};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = data;
            self.str = dic[@"str"];
            [self Submit];
        } else {
            
        }
    }];
    
    
}

- (void)Submit{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *paras = @{@"authenticationStr":self.accountText.text,
                            @"encryptedStr":self.str,
                            @"telephone":self.accountText.text,
                            @"password":self.passwordText.text
                            };
    NSString *url = [NSString stringWithFormat:@"http://appapi.juwairen.net/Login/telFindpwd/"];
    [manager POST:url parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //登录
                [self requestLoging];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            NSLog(@"%@",error);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改失败" message:@"修改失败" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
}

#pragma mark - 登录
- (void)requestLoging{
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
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } else {
            NSString *message = error.localizedDescription?:@"登录失败";
            hud.labelText = message;
            [hud hide:YES afterDelay:0.4];
        }
    }];
}

- (void)ClickSend:(UIButton *)sender{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.accountText.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            //  NSLog(@"获取验证码成功");
        } else {
            NSLog(@"错误信息：%@",error);
        }
    }];
}

- (void)contactCS:(UIButton *)sender{
    
}

-(void)Verification
{
    __block int timeout=59;  //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);  //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout<=0) {      //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.validationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.validationBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateNormal];
                
                self.validationBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.validationBtn setTitle:[NSString stringWithFormat:@"重新发送(%@s)",strTime] forState:UIControlStateNormal];
                [self.validationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                self.validationBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
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
