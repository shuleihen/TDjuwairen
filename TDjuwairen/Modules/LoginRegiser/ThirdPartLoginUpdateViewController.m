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
#import "LoginState.h"
#import "YXTextFieldPanel.h"
#import "HexColors.h"
#import "LoginHandler.h"
#import "YXSecurityCodeButton.h"
#import <SMS_SDK/SMSSDK.h>

@interface ThirdPartLoginUpdateViewController ()<YXSecurityCodeButtonDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet YXSecurityCodeButton *codeBtn;
@property (weak, nonatomic) IBOutlet YXTextFieldPanel *panelView;
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

- (void)codeCompletionWithResult:(NSError *)error {
    if (error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = error.userInfo[@"getVerificationCode"];
        [hud hide:YES afterDelay:0.6];
    }
}

- (IBAction)donePressed:(id)sender {
    [self.view endEditing:YES];
    
    NSString *phone = self.phoneTextField.text;
    NSString *code = self.codeTextField.text;
    NSString *nickName = self.nickNameTextField.text;
    NSString *pwd = self.passwordTextField.text;
    
    if(![phone isValidateMobile]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = (phone.length==0)?@"手机号不能为空":@"手机号格式错误";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if (!code.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先填写验证码";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if (!nickName.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先填写昵称";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if (!pwd.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先填写设置密码";
        [hud hide:YES afterDelay:0.4];
        return;
    }
    
    // 检测用户名称是否重复
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *dic = @{@"nickname": nickName};
    [manager POST:API_CheckNickName parameters:dic completion:^(id data, NSError *error){
        if (!error) {
            [self verificationPhone:phone code:code];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"昵称重复或不合法，请重新输入";
            [hud hide:YES afterDelay:0.4];
        }
    }];
}

- (void)verificationPhone:(NSString *)phone code:(NSString *)code {
    [SMSSDK commitVerificationCode:code phoneNumber:phone zone:@"86" result:^(NSError *error) {
        if (!error) {
            [self requestLogin];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"验证码错误，请重新输入";
            [hud hide:YES afterDelay:0.4];
        }
    }];
}

- (void)requestLogin {
    
    NSString *nickName = self.nickNameTextField.text;
    NSString *pwd = self.passwordTextField.text;
    NSString *phone = self.phoneTextField.text;
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *dic = @{@"unionid": self.thirdPartId,
                          @"nickname": nickName,
                          @"phone": phone,
                          @"password": pwd,
                          @"avatar_url": self.avatar_url};
    NSString *url;
    if (self.type == kUpdateTypeQQ) {
        url = API_LoginWithQQAdd;
    } else if (self.type == kUpdateTypeWeXin) {
        url = API_LoginWithWeixinAdd;
    } else {
        NSAssert(nil, @"第三方登录类型不对");
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中...";
    __weak ThirdPartLoginUpdateViewController *wself = self;
    
    [manager POST:url parameters:dic completion:^(id data, NSError *error){
        
        [hud hide:YES];
        
        if (!error) {
            US.isLogIn = YES;
            
            [LoginHandler saveLoginSuccessedData:data];
            [LoginHandler saveLoginAccountId:US.userName password:pwd];
            [LoginHandler checkOpenRemotePush];
            
            [wself.navigationController popToRootViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangedNotification object:nil];
        } else {
            NSString *message = error.localizedDescription?:@"提交失败";
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = message;
            [hud hide:YES afterDelay:0.4];
        }
    }];
}
@end
