//
//  RegisterViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginState.h"
#import "MBProgressHUD.h"
#import "AgreeViewController.h"
#import "UIStoryboard+MainStoryboard.h"
#import <SMS_SDK/SMSSDK.h>
#import "NetworkManager.h"
#import "UIdaynightModel.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) UITextField *accountText;
@property (nonatomic,strong) UITextField *validationText;
@property (nonatomic,strong) UIButton *validationBtn;
@property (nonatomic,strong) UITextField *passwordText;
@property (nonatomic,strong) UITextField *surePassword;
@property (nonatomic,strong) UITextField *nicknameText;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightmodel = [UIdaynightModel sharedInstance];
    
    self.view.backgroundColor = self.daynightmodel.backColor;
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [self setupWithNavigation];
    [self setupWithTextField];
    [self setupWithRegisterBtn];
    [self setupWithAgreements];
    // Do any additional setup after loading the view.
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

- (void)setupWithNavigation{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"注册";
    [self.navigationController.navigationBar setBackgroundColor:self.daynightmodel.navigationColor];
    [self.navigationController.navigationBar setBarTintColor:self.daynightmodel.navigationColor];
}

- (void)setupWithTextField{
    self.accountText = [[UITextField alloc]initWithFrame:CGRectMake(0, 16, kScreenWidth, 47)];
    self.accountText.backgroundColor = [UIColor whiteColor];
    self.accountText.textColor = [UIColor darkGrayColor];
    self.accountText.font = [UIFont systemFontOfSize:14];
    self.accountText.placeholder = @"手机号码";
    self.accountText.delegate = self;
    self.accountText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.accountText.leftViewMode = UITextFieldViewModeAlways;
    
    self.validationText = [[UITextField alloc]initWithFrame:CGRectMake(0, 16+47+1, kScreenWidth, 47)];
    self.validationText.backgroundColor = [UIColor whiteColor];
    self.validationText.textColor = [UIColor darkGrayColor];
    self.validationText.font = [UIFont systemFontOfSize:14];
    self.validationText.placeholder = @"请输入验证码";
    self.validationText.delegate = self;
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
//    [self.validationBtn addTarget:self action:@selector(Verification) forControlEvents:UIControlEventTouchUpInside];
    [self.validationBtn addTarget:self action:@selector(ClickSend:) forControlEvents:UIControlEventTouchUpInside];
    
    self.passwordText = [[UITextField alloc]initWithFrame:CGRectMake(0, 16+47+1+47+1, kScreenWidth, 47)];
    self.passwordText.backgroundColor = [UIColor whiteColor];
    self.passwordText.textColor = [UIColor darkGrayColor];
    self.passwordText.font = [UIFont systemFontOfSize:14];
    self.passwordText.placeholder = @"请设置密码(6-20位英文或数字)";
    self.passwordText.delegate = self;
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
    self.surePassword.delegate = self;
    self.surePassword.clearButtonMode = UITextFieldViewModeAlways;//右边X号
    self.surePassword.secureTextEntry = YES;//显示为星号
    self.surePassword.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.surePassword.leftViewMode = UITextFieldViewModeAlways;
    
    self.nicknameText = [[UITextField alloc]initWithFrame:CGRectMake(0, 16+47+1+47+1+47+1+47+1, kScreenWidth, 47)];
    self.nicknameText.backgroundColor = [UIColor whiteColor];
    self.nicknameText.textColor = [UIColor darkGrayColor];
    self.nicknameText.font = [UIFont systemFontOfSize:14];
    self.nicknameText.placeholder = @"请设置昵称(昵称只能设置一次，请谨慎选择)";
    self.nicknameText.delegate = self;
    self.nicknameText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.nicknameText.leftViewMode = UITextFieldViewModeAlways;
    
    self.accountText.backgroundColor = self.daynightmodel.navigationColor;
    self.accountText.textColor = self.daynightmodel.textColor;
    self.validationText.backgroundColor = self.daynightmodel.navigationColor;
    self.validationText.textColor = self.daynightmodel.textColor;
    self.passwordText.backgroundColor = self.daynightmodel.navigationColor;
    self.passwordText.textColor = self.daynightmodel.textColor;
    self.surePassword.backgroundColor = self.daynightmodel.navigationColor;
    self.surePassword.textColor = self.daynightmodel.textColor;
    self.nicknameText.backgroundColor = self.daynightmodel.navigationColor;
    self.nicknameText.textColor = self.daynightmodel.textColor;
    
    
    [self.view addSubview:self.accountText];
    [self.view addSubview:self.validationText];
    [self.view addSubview:self.validationBtn];
    [self.view addSubview:label];
    [self.view addSubview:self.passwordText];
    [self.view addSubview:self.surePassword];
    [self.view addSubview:self.nicknameText];
}

- (void)setupWithRegisterBtn{
    UIButton *registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 16+47+1+47+1+47+1+47+1+47+30, kScreenWidth-30, 50)];
    registerBtn.backgroundColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.layer.cornerRadius = 5;//圆角半径
    [registerBtn addTarget:self action:@selector(ClickRegis:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}

- (void)setupWithAgreements{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 16+47+1+47+1+47+1+47+1+47+30+50+10, kScreenWidth-30, 30)];
    label.text = @"点击“注册”即表示您已统一并愿意遵守局外人用户协议和隐私政策";
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:label.text];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] range:NSMakeRange(21, 4)];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] range:NSMakeRange(26, 4)];
    
    label.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    
    [label addGestureRecognizer:labelTapGestureRecognizer];
    
    label.attributedText = att;
    [self.view addSubview:label];
}

- (void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    AgreeViewController *agreeview = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"AgreeView"];
    [self.navigationController pushViewController:agreeview animated:YES];
}

- (void)ClickSend:(UIButton *)sender{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/Reg/checkTelephone/"];
    NSDictionary *para = @{@"telephone":self.accountText.text};
    [manager POST:url parameters:para completion:^(id data, NSError *error) {
        if (!error) {
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.accountText.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
                if (!error) {
                    [self Verification];
                } else {
                    nil;
                }
            }];
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号已注册！" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
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

#pragma mark - 点击完成注册
- (void)ClickRegis:(UIButton *)sender{
    //判断
    if ([self.accountText.text isEqualToString:@""]) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        
        hud.labelText = @"请输入手机号";
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [hud hide:YES afterDelay:0.1f];
        }];
        return;
    }else if ([self.validationText.text isEqualToString:@""]){
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        
        hud.labelText = @"验证码不能为空";
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [hud hide:YES afterDelay:0.1f];
        }];
        return;
    }else if ([self.passwordText.text isEqualToString:@""]){
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        
        hud.labelText = @"密码不能为空";
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [hud hide:YES afterDelay:0.1f];
        }];
        return;
    }
    else if([self.nicknameText.text isEqualToString:@""])
    {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        
        hud.labelText = @"用户名不能为空";
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [hud hide:YES afterDelay:0.1f];
        }];
        return;
    }
    else if (![self.passwordText.text isEqualToString:self.surePassword.text]){
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        
        hud.labelText = @"两次输入密码不一样";
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [hud hide:YES afterDelay:0.1f];
        }];
        return;
    }
    else
    {
        [SMSSDK commitVerificationCode:self.validationText.text phoneNumber:self.accountText.text zone:@"86" result:^(NSError *error) {
            if (!error) {
                //提交注册信息
                [self SubmitUserinfo];
            } else {
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
    NSDictionary*paras = @{@"telephone":self.accountText.text,
                           @"password":self.passwordText.text,
                           @"nickname":self.nicknameText.text};
    
    [manager POST:API_RegWithPhone parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self requestLogin];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"注册失败" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)requestLogin{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *paras = @{@"account":self.accountText.text,
                            @"password":self.passwordText.text};
    
    [manager POST:API_GetApiValidate parameters:paras completion:^(id data, NSError *error){
        if (!error) {
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
            NSString *message = error.localizedDescription;
            if (error.code == NSURLErrorTimedOut) {
                UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败!请检查网络链接!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *conformAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                
                [aler addAction:conformAction];
                [self presentViewController:aler animated:YES completion:nil];
            } else {
                UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *conformAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                [aler addAction:conformAction];
                [self presentViewController:aler animated:YES completion:nil];
            }
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
