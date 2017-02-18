//
//  MobileLoginViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MobileLoginViewController.h"
#import "LoginState.h"
#import "NetworkManager.h"
#import "HexColors.h"
#import "YXTextFieldPanel.h"
#import "YXCheckBox.h"
#import "NSString+Util.h"
#import "MBProgressHUD.h"
#import "NotificationDef.h"
#import "FastLoginUpdateInfoViewController.h"
#import "LoginHandler.h"
#import "YXSecurityCodeButton.h"
#import "TDWebViewController.h"

@interface MobileLoginViewController ()<YXSecurityCodeButtonDelegate>

@property (nonatomic, weak) IBOutlet UITextField *accountText;
@property (nonatomic, weak) IBOutlet UITextField *validationText;
@property (nonatomic, weak) IBOutlet YXSecurityCodeButton *validationBtn;
@property (weak, nonatomic) IBOutlet YXTextFieldPanel *panelView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic,strong) NSString *validateString;
@property (nonatomic,strong) NSString *encryptedStr;
@property (weak, nonatomic) IBOutlet YXCheckBox *agreeBtn;
@property (nonatomic, strong) MBProgressHUD *hud;

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
    
    self.agreeBtn.checked = YES;
    self.validationBtn.delegate = self;
    
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

    NSURL *url = [NSURL URLWithString:@"https://appapi.juwairen.net/Page/index/p/yonghuxieyi"];
    TDWebViewController *vc = [[TDWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -YXSecurityCodeButtonDelegate
- (NSString *)codeWithPhone {
    NSString *phone = self.accountText.text;
    return phone;
}

- (PhoneCodeType)codeType {
    return kPhoneCodeForLogin;
}

- (IBAction)loginPressed:(id)sender{
    
    NSString *phone = self.accountText.text;
    NSString *code = self.validationText.text;
    NSString *msg_unique_id = self.validationBtn.msg_unique_id;
    
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
    } else if (!msg_unique_id.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先获取证码";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if (!code.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先填写验证码";
        [hud hide:YES afterDelay:0.4];
        return;
    }
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"登录";
    
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
                self.hud.labelText = is_expire?@"验证码过期，请重新获取":@"验证码错误，请重新输入";
                [self.hud hide:YES afterDelay:0.4];
            }
        } else {
            self.hud.labelText = @"验证码错误，请重新输入";
            [self.hud hide:YES afterDelay:0.4];
        }
    }];
}

- (void)requestLogin{
    if (!self.validateString.length ||
        !self.encryptedStr.length) {
        return;
    }
    
    NSString *phone = self.accountText.text;
    NSString *msg_unique_id = self.validationBtn.msg_unique_id;
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *dic = @{@"user_phone": phone,
                          @"authenticationStr":self.validateString,
                          @"encryptedStr":self.encryptedStr,
                          @"msg_unique_id": msg_unique_id};

    
    [manager POST:API_LoginWithPhone parameters:dic completion:^(id data, NSError *error){
        if (!error) {
            [self.hud hide:YES];
            
            if ([data[@"need_complete"] boolValue] == NO) {
                US.isLogIn = YES;
                
                [LoginHandler saveLoginSuccessedData:data];
                [LoginHandler saveFastLoginWithPhone:phone];
                [LoginHandler checkOpenRemotePush];
                                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangedNotification object:nil];
            } else {
                // 需要补齐信息
                US.isLogIn = NO;
                
                FastLoginUpdateInfoViewController *vc = [[UIStoryboard storyboardWithName:@"Register" bundle:nil] instantiateViewControllerWithIdentifier:@"FastLoginUpdateInfoViewController"];
                vc.phone = phone;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            NSString *message = error.localizedDescription?:@"登录失败";
            self.hud.labelText = message;
            [self.hud hide:YES afterDelay:0.4];
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
