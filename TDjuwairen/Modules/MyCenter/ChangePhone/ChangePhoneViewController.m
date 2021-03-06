//
//  ChangePhoneViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/2/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "YXSecurityCodeButton.h"
#import "MBProgressHUD.h"
#import "NSString+Util.h"
#import "NetworkManager.h"
#import "LoginStateManager.h"
#import "YXTextFieldPanel.h"

@interface ChangePhoneViewController ()<MBProgressHUDDelegate, YXSecurityCodeButtonDelegate>
@property (weak, nonatomic) IBOutlet YXTextFieldPanel *panelView;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *codeTextField;
@property (nonatomic, weak) IBOutlet YXSecurityCodeButton *codeBtn;
@property (nonatomic, strong) NSString *validateString;
@property (nonatomic, strong) NSString *str;
@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.panelView.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#eeeeee"].CGColor;
    self.panelView.layer.cornerRadius = 3.0f;
    self.panelView.layer.borderWidth = 1.0f;
    self.panelView.clipsToBounds = YES;
    
    self.validateString = @"tuandawangluokeji";
    [self requestAuthentication];
    self.codeBtn.delegate = self;
    self.title = @"更换手机号";
}



#pragma mark -YXSecurityCodeButtonDelegate
- (BOOL)canRequest {
    NSString *phone = [self.phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([US.userPhone isEqualToString:phone]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入正确的手机号";
        [hud hideAnimated:YES afterDelay:0.8];
        return NO;
    }
    return YES;
}

- (NSString *)codeWithPhone {
    NSString *phone = self.phoneTextField.text;
    return phone;
}

- (PhoneCodeType)codeType {
    return kPhoneCodeForUpdate;
}

- (IBAction)donePressed:(id)sender {
    [self.view endEditing:YES];
    
    NSString *phone = self.phoneTextField.text;
    NSString *code = self.codeTextField.text;
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
    }
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *dic = @{@"msg_unique_id": msg_unique_id,
                          @"msg_code": code};
    
    [manager POST:API_LoginCheckPhoneCode parameters:dic completion:^(id data, NSError *error){
        if (data) {
            BOOL is_expire = [data[@"is_expire"] boolValue];
            BOOL is_verify = [data[@"is_verify"] boolValue];
            
            if (is_verify) {
                [self requestChangePhone];
            } else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = is_expire?@"验证码过期，请重新获取":@"验证码错误，请重新输入";
                [hud hideAnimated:YES afterDelay:0.4];
            }
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"验证码错误，请重新输入";
            [hud hideAnimated:YES afterDelay:0.4];
        }
    }];
}

- (void)requestChangePhone {
    if (!self.validateString.length ||
        !self.str.length) {
        return;
    }
    
    NSString *phone = self.phoneTextField.text;
    NSString *msg_unique_id = self.codeBtn.msg_unique_id;
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *dic = @{@"phone": phone,
                          @"authenticationStr":self.validateString,
                          @"encryptedStr":self.str,
                          @"userid": US.userId,
                          @"msg_unique_id" : msg_unique_id};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [manager POST:API_UpdateUserPhone parameters:dic completion:^(id data, NSError *error){
        if (!error && [data[@"status"] boolValue]) {
            hud.label.text = @"更新成功";
            hud.delegate = self;
            [hud hideAnimated:YES afterDelay:0.4];
        } else {
            NSString *message = error.localizedDescription?:@"登录失败";
            hud.label.text = message;
            [hud hideAnimated:YES afterDelay:0.4];
        }
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestAuthentication
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *para = @{@"validatestring":self.validateString};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = data;
            self.str = dic[@"str"];
        } else {
            
        }
    }];
}
@end
