//
//  SettingNickNameViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SettingNickNameViewController.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "MBProgressHUD.h"

@interface SettingNickNameViewController ()
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSString *str;
@end

@implementation SettingNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(donePressed:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.textField.text = US.userName;
    [self.textField becomeFirstResponder];
    
    [self getValidation];
}

- (void)donePressed:(id)sender {
    if (!self.str.length) {
        return;
    }
    
    NSString *userName = self.textField.text;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *paras = @{@"authenticationStr":US.userId,
                            @"encryptedStr":self.str,
                            @"userid": US.userId,
                            @"username": userName};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [self.textField resignFirstResponder];
    [manager POST:API_UpdateUserName parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            US.userName = userName;
            [hud hide:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            hud.labelText = @"修改失败";
            [hud hide:YES];
        }
    }];
}

- (IBAction)textDidChange:(UITextField *)textField {
    self.navigationItem.rightBarButtonItem.enabled = ![textField.text isEqualToString:US.nickName];
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
