//
//  RegisterSetInfoTableViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/8.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "RegisterSetInfoTableViewController.h"
#import "NetworkManager.h"
#import "MBProgressHUD+Custom.h"

@interface RegisterSetInfoTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;

@end

@implementation RegisterSetInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)textDidChanged:(id)sender {
    NSString *nickName = self.nickNameTextField.text;
    self.doneBtn.enabled = nickName.length;
}

- (IBAction)donePressed:(id)sender {
//    NSString *nickName = self.nickNameTextField.text;
    [self submitForRegister];
}

- (void)checkNickName {
    
}

- (void)submitForRegister {
    NSString *nickName = self.nickNameTextField.text;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras = @{@"telephone": self.phone,
                           @"password": self.passwrod,
                           @"nickname": nickName};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中";
    
    [manager POST:API_RegWithPhone parameters:paras completion:^(id data, NSError *error){
        [hud hide:YES];
        
        if (!error) {
            // 异步提交头像
            
        } else {
            NSString *message = error.description?:@"注册失败";
            [MBProgressHUD showHUDAddedTo:self.view message:message];
        }
    }];
}
@end
