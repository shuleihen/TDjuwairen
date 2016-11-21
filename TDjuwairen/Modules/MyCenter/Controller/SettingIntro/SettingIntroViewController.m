//
//  SettingIntroViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SettingIntroViewController.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "MBProgressHUD.h"

@interface SettingIntroViewController ()
@property (nonatomic, strong) NSString *str;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation SettingIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(donePressed:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.textView.text = US.personal;
    [self.textView becomeFirstResponder];
    
    [self getValidation];
}

- (void)donePressed:(id)sender {
    if (!self.str.length) {
        return;
    }
    
    NSString *intro = self.textView.text;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras=@{@"authenticationStr":US.userId,
                         @"encryptedStr":self.str,
                         @"userid":US.userId,
                         @"Userinfo": intro};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [self.textView resignFirstResponder];
    [manager POST:API_UpdateUserInfo parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            US.personal = intro;
            [hud hide:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            hud.labelText = @"修改失败";
            [hud hide:YES];
        }
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem.enabled = ![textView.text isEqualToString:US.personal];
}

- (void)getValidation{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*para = @{@"validatestring":US.userId};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = data;
            self.str = dic[@"str"];
        } else {
            
        }
    }];
}
@end
