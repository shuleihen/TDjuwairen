//
//  RegisterTableViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/8.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "RegisterTableViewController.h"
#import "RegisterCodeTableViewController.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "NSString+Util.h"
#import "YXCheckBox.h"
#import "HexColors.h"
#import "AgreeViewController.h"


@interface RegisterTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet YXCheckBox *checkBtn;

@end

@implementation RegisterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.checkBtn.checked = YES;
}

- (IBAction)textDidChanged:(id)sender {
    NSString *phone = self.phoneTextField.text;
    if ([phone isValidateMobile]) {
        [self checkIsRegisterWithPhone:phone];
    } 
}

- (IBAction)nextPressed:(id)sender {
    NSString *phone = self.phoneTextField.text;
    NSString *pwd = self.passwordTextField.text;
    
    if (!self.checkBtn.checked) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先同意用户协议";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if (!phone.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"手机号不能为空";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if (!pwd.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"密码不能为空";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if (![phone isValidateMobile]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"手机号格式错误";
        [hud hide:YES afterDelay:0.4];
    } else if (![phone isValidatePassword]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"密码格式错误，请重设";
        [hud hide:YES afterDelay:0.4];
    }
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"加载中";
//    
//    NetworkManager *manager = [[NetworkManager alloc] init];
//    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/Reg/checkTelephone/"];
//    NSDictionary *para = @{@"telephone": phone};
//    [manager POST:url parameters:para completion:^(id data, NSError *error) {
//        [hud hide:YES];
//        
//        if (!error) {
            RegisterCodeTableViewController *vc = [[UIStoryboard storyboardWithName:@"Register" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterCodeTableViewController"];
            vc.phone = phone;
            vc.passwrod = pwd;
            [self.navigationController pushViewController:vc animated:YES];
//        } else {
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"该手机号已经被注册";
//            [hud hide:YES afterDelay:0.5];
//        }
//    }];
}

- (IBAction)agreementPressed:(id)sender {
    AgreeViewController *agreeview = [[UIStoryboard storyboardWithName:@"Register" bundle:nil] instantiateViewControllerWithIdentifier:@"AgreeView"];
    [self.navigationController pushViewController:agreeview animated:YES];
}

- (void)checkIsRegisterWithPhone:(NSString *)phone {
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/Reg/checkTelephone/"];
    NSDictionary *para = @{@"telephone": phone};
    
    [manager POST:url parameters:para completion:^(id data, NSError *error) {
        if (error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"该手机号已经被注册";
            [hud hide:YES afterDelay:0.5];
        }
    }];
}
@end
