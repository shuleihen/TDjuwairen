//
//  RegisterCodeTableViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/8.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "RegisterCodeTableViewController.h"
#import "RegisterSetInfoTableViewController.h"
#import "MBProgressHUD+Custom.h"
#import "YXSecurityCodeButton.h"
#import <SMS_SDK/SMSSDK.h>

@interface RegisterCodeTableViewController ()<YXSecurityCodeButtonDelegate>
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UILabel *phoneTipLabel;
@property (weak, nonatomic) IBOutlet YXSecurityCodeButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation RegisterCodeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.getCodeBtn handStart];
}

- (IBAction)nextPressed:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *code = self.codeTextField.text;
    [SMSSDK commitVerificationCode:code phoneNumber:self.phone zone:@"86" result:^(NSError *error) {
        [hud hide:YES];
        
        if (!error) {
            RegisterSetInfoTableViewController *vc = [[UIStoryboard storyboardWithName:@"Register" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterSetInfoTableViewController"];
            vc.phone = self.phone;
            vc.passwrod = self.passwrod;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showHUDAddedTo:self.view message:@"验证码错误"];
        }
    }];
}

- (IBAction)textDidChanged:(id)sender {
    NSString *code = self.codeTextField.text;
    self.nextBtn.enabled = code.length;
}

#pragma mark -YXSecurityCodeButtonDelegate 
- (NSString *)codeWithPhone {
    return self.phone;
}

- (void)codeCompletionWithResult:(NSError *)error {
    if (error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"获取验证码失败";
        [hud hide:YES afterDelay:0.4];
    } else {
        self.phoneTipLabel.text = [NSString stringWithFormat:@"已向手机%@发送验证码",self.phone];
    }
}
@end
