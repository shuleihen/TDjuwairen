//
//  ThirdPartLoginUpdateViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/21.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "ThirdPartLoginUpdateViewController.h"
#import "NSString+Util.h"
#import "MBProgressHUD.h"
#import "NotificationDef.h"
#import "NetworkManager.h"
#import "LoginStateManager.h"
#import "YXTextFieldPanel.h"
#import "HexColors.h"
#import "LoginHandler.h"
#import "YXSecurityCodeButton.h"

@interface ThirdPartLoginUpdateViewController ()<YXSecurityCodeButtonDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet YXSecurityCodeButton *codeBtn;
@property (weak, nonatomic) IBOutlet YXTextFieldPanel *panelView;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation ThirdPartLoginUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.codeBtn.delegate = self;
    self.nickNameTextField.text = self.thirdPartName;
    
    self.panelView.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#eeeeee"].CGColor;
    self.panelView.layer.cornerRadius = 3.0f;
    self.panelView.layer.borderWidth = 1.0f;
    self.panelView.clipsToBounds = YES;
}

#pragma mark -YXSecurityCodeButtonDelegate
- (NSString *)codeWithPhone {
    NSString *phone = self.phoneTextField.text;
    return phone;
}

- (PhoneCodeType)codeType {
    return kPhoneCodeForSupplement;
}

- (IBAction)donePressed:(id)sender {
    [self.view endEditing:YES];
    
    NSString *phone = self.phoneTextField.text;
    NSString *code = self.codeTextField.text;
    NSString *nickName = self.nickNameTextField.text;
    NSString *pwd = self.passwordTextField.text;
    NSString *msg_unique_id = self.codeBtn.msg_unique_id;
    
    if(![phone isValidateMobile]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = (phone.length==0)?@"手机号不能为空":@"手机号格式错误";
        [hud hideAnimated:YES afterDelay:0.4];
        return;
    } else if (!msg_unique_id.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请先获取证码";
        [hud hideAnimated:YES afterDelay:0.4];
        return;
    } else if (!code.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请先填写验证码";
        [hud hideAnimated:YES afterDelay:0.4];
        return;
    } else if (!nickName.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请先填写昵称";
        [hud hideAnimated:YES afterDelay:0.4];
        return;
    } else if (!pwd.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请先填写设置密码";
        [hud hideAnimated:YES afterDelay:0.4];
        return;
    }
    
    // 检测用户名称是否重复
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.label.text = @"提交中...";
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *dic = @{@"nickname": nickName};
    [manager POST:API_CheckNickName parameters:dic completion:^(id data, NSError *error){
        if (!error) {
            [self checkPhoneCode];
        } else {
            self.hud.label.text = @"昵称重复或不合法，请重新输入";
            [self.hud hideAnimated:YES afterDelay:0.4];
        }
    }];
}

- (void)checkPhoneCode {
    NSString *code = self.codeTextField.text;
    NSString *msg_unique_id = self.codeBtn.msg_unique_id;
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *dic = @{@"msg_unique_id": msg_unique_id,
                          @"msg_code": code};
    
    [manager POST:API_LoginCheckPhoneCode parameters:dic completion:^(id data, NSError *error){
        if (data) {
            BOOL is_expire = [data[@"is_expire"] boolValue];
            BOOL is_verify = [data[@"is_verify"] boolValue];
            
            if (is_verify) {
                [self requestLogin];
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

- (void)requestLogin {
    
    NSString *nickName = self.nickNameTextField.text;
    NSString *pwd = self.passwordTextField.text;
    NSString *phone = self.phoneTextField.text;
    NSString *msg_unique_id = self.codeBtn.msg_unique_id;
    
    NSString *ecriptPwd = [LoginHandler encryptWithPassword:pwd];
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *dic = @{@"unionid": self.thirdPartId,
                          @"nickname": nickName,
                          @"phone": phone,
                          @"password": ecriptPwd,
                          @"avatar_url": self.avatar_url,
                          @"msg_unique_id": msg_unique_id};
    NSString *url;
    if (self.type == kUpdateTypeQQ) {
        url = API_LoginWithQQAdd;
    } else if (self.type == kUpdateTypeWeXin) {
        url = API_LoginWithWeixinAdd;
    } else {
        NSAssert(nil, @"第三方登录类型不对");
    }
    
    
    [manager POST:url parameters:dic completion:^(id data, NSError *error){

        if (!error) {
            US.isLogIn = YES;
            
            [LoginHandler saveLoginSuccessedData:data];
            [LoginHandler saveLoginAccountId:US.userName password:pwd];
            [LoginHandler checkOpenRemotePush];
            
            [self.hud hideAnimated:YES];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangedNotification object:nil];
        } else {
            NSString *message = error.localizedDescription?:@"提交失败";
            self.hud.label.text = message;
            [self.hud hideAnimated:YES afterDelay:0.4];
        }
    }];
}
@end
