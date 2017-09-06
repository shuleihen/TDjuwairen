//
//  SettingIntroViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SettingIntroViewController.h"
#import "NetworkManager.h"
#import "LoginStateManager.h"
#import "MBProgressHUD.h"
#import "UITextView+Placeholder.h"

@interface SettingIntroViewController ()
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
    self.textView.placeholder = TDDefaultRoomDesc;
    [self.textView becomeFirstResponder];
}

- (void)donePressed:(id)sender {

    NSString *intro = self.textView.text;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras=@{@"Userinfo": intro};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"提交中...";
    [self.textView resignFirstResponder];
    [manager POST:API_UpdateUserInfo parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            US.personal = intro;
            [hud hideAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            hud.label.text = @"修改失败";
            [hud hideAnimated:YES];
        }
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem.enabled = ![textView.text isEqualToString:US.personal];
}

@end
