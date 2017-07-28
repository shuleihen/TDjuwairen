//
//  FastLoginUpdateInfoViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/21.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "FastLoginUpdateInfoViewController.h"
#import "NSString+Util.h"
#import "MBProgressHUD.h"
#import "NotificationDef.h"
#import "NetworkManager.h"
#import "LoginStateManager.h"
#import "YXTextFieldPanel.h"
#import "HexColors.h"
#import "LoginHandler.h"

@interface FastLoginUpdateInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet YXTextFieldPanel *panelView;
@end

@implementation FastLoginUpdateInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.panelView.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#eeeeee"].CGColor;
    self.panelView.layer.cornerRadius = 3.0f;
    self.panelView.layer.borderWidth = 1.0f;
    self.panelView.clipsToBounds = YES;
}

- (IBAction)donePressed:(id)sender {
    NSString *nickName = self.nickNameTextField.text;
    NSString *pwd = self.passwordTextField.text;
    
    if (!nickName.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"昵称不能为空";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if (!pwd.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"密码不能为空";
        [hud hide:YES afterDelay:0.4];
        return;
    }
    
    NSString *ecriptPwd = [LoginHandler encryptWithPassword:pwd];
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *dic = @{@"phone": self.phone,
                          @"nickname": nickName,
                          @"password": ecriptPwd};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中...";
    __weak FastLoginUpdateInfoViewController *wself = self;
    
    [manager POST:API_LoginWithPhoneAdd parameters:dic completion:^(id data, NSError *error){
        [hud hide:YES];
        
        if (!error && data) {
            US.isLogIn = YES;
            
            [LoginHandler saveLoginSuccessedData:data];
            [LoginHandler saveLoginAccountId:US.userId password:pwd];
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
