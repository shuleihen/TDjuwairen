//
//  AddUpdatesViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/5.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AddUpdatesViewController.h"
#import "LoginState.h"
#import "MBProgressHUD.h"
#import "PhoneNumHold.h"
#import <SMS_SDK/SMSSDK.h>
#import "NetworkManager.h"

@interface AddUpdatesViewController ()<PhoneNumHoldDelegate>

@property (nonatomic,strong) UITextField *accountText;
@property (nonatomic,strong) UITextField *validationText;
@property (nonatomic,strong) UIButton *validationBtn;
@property (nonatomic,strong) UITextField *passwordText;
@property (nonatomic,strong) UITextField *nicknameText;

@property (nonatomic,strong) UIView *backview;
@property (nonatomic,strong) PhoneNumHold *phoneview;

@end

@implementation AddUpdatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];

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
//    [self.navigationController.navigationBar setHidden:NO];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    //设置navigation背景色
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    self.title = @"信息补全";
    // 设置标题颜色，和大小,如果标题是使用titleView方式定义不行
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
}

- (void)setupWithTextField{
    self.accountText = [[UITextField alloc]initWithFrame:CGRectMake(0, 16, kScreenWidth, 47)];
    self.accountText.backgroundColor = [UIColor whiteColor];
    self.accountText.textColor = [UIColor darkGrayColor];
    self.accountText.font = [UIFont systemFontOfSize:14];
    self.accountText.placeholder = @"手机号码/邮箱";
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
//    [self.validationBtn addTarget:self action:@selector(Verification) forControlEvents:UIControlEventTouchUpInside];
    [self.validationBtn addTarget:self action:@selector(ClickSend:) forControlEvents:UIControlEventTouchUpInside];
    
    self.passwordText = [[UITextField alloc]initWithFrame:CGRectMake(0, 16+47+1+47+1, kScreenWidth, 47)];
    self.passwordText.backgroundColor = [UIColor whiteColor];
    self.passwordText.textColor = [UIColor darkGrayColor];
    self.passwordText.font = [UIFont systemFontOfSize:14];
    self.passwordText.placeholder = @"请设置密码(6-20位英文或数字)";
//    self.passwordText.keyboardType = UIKeyboardTypeNumberPad;//数字键盘
    self.passwordText.clearButtonMode = UITextFieldViewModeAlways;//右边X号
    self.passwordText.secureTextEntry = YES;//显示为星号
    self.passwordText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.passwordText.leftViewMode = UITextFieldViewModeAlways;
    
    self.nicknameText = [[UITextField alloc]initWithFrame:CGRectMake(0, 16+47+1+47+1+47+1, kScreenWidth, 47)];
    self.nicknameText.backgroundColor = [UIColor whiteColor];
    self.nicknameText.textColor = [UIColor darkGrayColor];
    self.nicknameText.font = [UIFont systemFontOfSize:14];
    self.nicknameText.placeholder = @"请设置昵称(昵称只能设置一次，请谨慎选择)";
    self.nicknameText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.nicknameText.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:self.accountText];
    [self.view addSubview:self.validationText];
    [self.view addSubview:self.validationBtn];
    [self.view addSubview:label];
    [self.view addSubview:self.passwordText];
    [self.view addSubview:self.nicknameText];
}

- (void)setupWithRegisterBtn{
    UIButton *registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 16+47+1+47+1+47+1+47+30, kScreenWidth-30, 50)];
    registerBtn.backgroundColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0];
    [registerBtn setTitle:@"提交" forState:UIControlStateNormal];
    registerBtn.layer.cornerRadius = 5;//圆角半径
    [registerBtn addTarget:self action:@selector(ClickAddUpdates:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}

- (void)setupWithAgreements{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 16+47+1+47+1+47+1+47+30+50+10, kScreenWidth-30, 40)];
    label.text = @"点击“注册”即表示您已统一并愿意遵守局外人用户协议和隐私政策";
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:label.text];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] range:NSMakeRange(21, 4)];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] range:NSMakeRange(26, 4)];
    label.attributedText = att;
    [self.view addSubview:label];
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
            
            self.backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            self.backview.backgroundColor = [UIColor blackColor];
            self.backview.alpha = 0.3;
            
            self.phoneview = [[PhoneNumHold alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth-40, 200)];
            self.phoneview.delegate = self;
            self.phoneview.center = CGPointMake(kScreenWidth/2, kScreenHeight/3);
            self.phoneview.backgroundColor = [UIColor whiteColor];
            
            [self.view addSubview:self.backview];
            [self.view addSubview:self.phoneview];
        }
    }];
}

- (void)phoneSure:(UIButton *)sender
{
    [self.backview removeFromSuperview];
    [self.phoneview removeFromSuperview];
}

- (void)phoneClean:(UIButton *)sender
{
    [self.backview removeFromSuperview];
    [self.phoneview removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark - 提交内容
- (void)ClickAddUpdates:(UIButton *)sender{
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
    else
    {
        [SMSSDK commitVerificationCode:self.validationText.text phoneNumber:self.accountText.text zone:@"86" result:^(NSError *error) {
            if (!error) {
                //提交更新
                [self updateUserinfo];
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

- (void)updateUserinfo{
    NSString *updateurl ;
    NSDictionary *infoDic;
    if (self.qqopenid == nil) {            //微信登录
        infoDic = @{@"unionid":self.unionid,
                    @"phone":self.accountText.text,
                    @"password":self.passwordText.text,
                    @"email":@"",
                    @"nickname":self.nicknameText.text};
        updateurl = [NSString stringWithFormat:@"index.php/Login/WXLoginDo1_2"];
    }
    else                                                  //QQ登录
    {
        infoDic = @{@"openid":self.qqopenid,
                    @"phone":self.accountText.text,
                    @"password":self.passwordText.text,
                    @"email":@"",
                    @"nickname":self.nicknameText.text};
        updateurl = [NSString stringWithFormat:@"index.php/Login/qqLoginDo1_2"];
    }
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    [manager POST:updateurl parameters:infoDic completion:^(id data, NSError *error){
        if (!error) {
            US.nickName = self.nicknameText.text;
            US.userPhone = self.accountText.text;
            US.isLogIn = YES;
            
            NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
            [accountDefaults setValue:self.accountText.text forKey:@"account"];
            [accountDefaults setValue:self.passwordText.text forKey:@"password"];
            [accountDefaults synchronize];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            
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
