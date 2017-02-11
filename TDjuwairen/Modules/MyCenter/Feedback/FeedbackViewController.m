//
//  FeedbackViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/2/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "FeedbackViewController.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "MBProgressHUD.h"

@interface FeedbackViewController ()<MBProgressHUDDelegate>
@property (nonatomic, strong) NSString *str;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIButton *doneBtn;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.textView becomeFirstResponder];
    self.doneBtn.enabled = NO;
    [self getValidation];
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

- (void)textViewDidChange:(UITextView *)textView {
    NSString *intro = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.doneBtn.enabled = intro.length;
}

- (IBAction)donePressed:(id)sender {
    if (!self.str.length) {
        return;
    }
    
    NSString *intro = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (intro.length <= 0) {
        return;
    }
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*para = @{@"authenticationStr":US.userId,
                          @"encryptedStr":self.str,
                          @"userid":US.userId,
                          @"feedbackContent": intro};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中...";
    [self.textView resignFirstResponder];
    
    [manager POST:API_AddUserFeedback parameters:para completion:^(id data, NSError *error){
        if (!error) {
            US.personal = intro;
            hud.labelText = @"提交成功";
            hud.delegate = self;
            [hud hide:YES afterDelay:0.4];
            
        } else {
            hud.labelText = @"提交失败";
            [hud hide:YES];
        }
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
