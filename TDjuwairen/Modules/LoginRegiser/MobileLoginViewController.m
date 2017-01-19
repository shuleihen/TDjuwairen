//
//  MobileLoginViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MobileLoginViewController.h"
#import "RegisterViewController.h"
#import "LoginState.h"
#import <SMS_SDK/SMSSDK.h>
#import "NetworkManager.h"
#import "HexColors.h"
#import "YXTextFieldPanel.h"
#import "AgreeViewController.h"
#import "YXCheckBox.h"
#import "NSString+Util.h"
#import "MBProgressHUD.h"
#import "NotificationDef.h"

@interface MobileLoginViewController ()

@property (nonatomic,strong) IBOutlet UITextField *accountText;
@property (nonatomic,strong) IBOutlet UITextField *validationText;
@property (nonatomic,strong) IBOutlet UIButton *validationBtn;
@property (weak, nonatomic) IBOutlet YXTextFieldPanel *panelView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic,strong) NSString *validateString;
@property (nonatomic,strong) NSString *encryptedStr;
@property (weak, nonatomic) IBOutlet YXCheckBox *agreeBtn;

@end

@implementation MobileLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"快速登录";
    self.validateString = @"tuandawangluokeji";
    
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
    
    [self requestAuthentication];
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

- (IBAction)agreePressed:(id)sender {
    AgreeViewController *agreeview = [[UIStoryboard storyboardWithName:@"Register" bundle:nil] instantiateViewControllerWithIdentifier:@"AgreeViewController"];
    [self.navigationController pushViewController:agreeview animated:YES];
}

- (IBAction)privacyPressed:(id)sender {
    AgreeViewController *agreeview = [[UIStoryboard storyboardWithName:@"Register" bundle:nil] instantiateViewControllerWithIdentifier:@"AgreeViewController"];
    [self.navigationController pushViewController:agreeview animated:YES];
}


- (IBAction)getCodePressed:(UIButton *)sender{
    if (!self.accountText.text.length) {
        return;
    }
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.accountText.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            [self verification];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"获取验证码失败";
            [hud hide:YES afterDelay:0.4];
        }
    }];
}

-(void)verification
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
                [self.validationBtn setTitle:@"| 获取验证码" forState:UIControlStateNormal];
                [self.validationBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#3371e2"] forState:UIControlStateNormal];
                
                self.validationBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.validationBtn setTitle:[NSString stringWithFormat:@"重新发送(%@s)",strTime] forState:UIControlStateNormal];
                [self.validationBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#999999"] forState:UIControlStateNormal];
                self.validationBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

- (IBAction)loginPressed:(id)sender{
    
    NSString *phone = self.accountText.text;
    NSString *code = self.validationText.text;
    
    if (!self.agreeBtn.checked) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先勾选局外人协议";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if(![phone isValidateMobile]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = (phone.length==0)?@"手机号不能为空":@"手机号格式错误";
        [hud hide:YES afterDelay:0.4];
        return;
    }else if (!code.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先填写验证码";
        [hud hide:YES afterDelay:0.4];
        return;
    }
    
    [SMSSDK commitVerificationCode:code phoneNumber:phone zone:@"86" result:^(NSError *error) {
        if (!error) {
            //请求登录信息
            [self requestLogin];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码错误，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)requestLogin{
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *dic = @{@"user_phone":self.accountText.text,
                          @"authenticationStr":self.validateString,
                          @"encryptedStr":self.encryptedStr};

    
    [manager POST:API_LoginWithPhone parameters:dic completion:^(id data, NSError *error){
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
            
            US.isLogIn = YES;
            
            [self.navigationController popToRootViewControllerAnimated:YES];

            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessedNotification object:nil];
        } else {
            NSString *message = error.localizedDescription?:@"登录失败";
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = message;
            [hud hide:YES afterDelay:0.4];
        }
    }];
}

-(void)requestAuthentication
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *para = @{@"validatestring":self.validateString};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = data;
            self.encryptedStr = dic[@"str"];
        } else {
            
        }
    }];
}

@end
