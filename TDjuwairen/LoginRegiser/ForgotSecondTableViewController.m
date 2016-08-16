//
//  ForgotSecondTableViewController.m
//  juwairen
//
//  Created by tuanda on 16/5/19.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "ForgotSecondTableViewController.h"
#import "LoginTableViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "NetworkManager.h"

@interface ForgotSecondTableViewController ()

@end

@implementation ForgotSecondTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset =UIEdgeInsetsMake(-33, 0, 0, 0);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    //验证码的监听事件
    [self.VerificationBtn addTarget:self action:@selector(Verification) forControlEvents:UIControlEventTouchUpInside];
    
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    self.FinishBtn.layer.cornerRadius=5;
    [self.FinishBtn setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:105.0/255.0 blue:177.0/255.0 alpha:1.0]];
    
    self.VerificationBtn.layer.cornerRadius=3;
    [self.VerificationBtn setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:105.0/255.0 blue:177.0/255.0 alpha:1.0]];
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavgation];
}

-(void)setNavgation
{
    UILabel*lable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
    lable.text=@"找回密码";
    self.navigationItem.titleView=lable;
    
    
}

-(void)Verification
{
            __block int timeout=59;  //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);  //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if (timeout<=0) {      //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [self.VerificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                        self.VerificationBtn.userInteractionEnabled = YES;
                    });
                }else{
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [self.VerificationBtn setTitle:[NSString stringWithFormat:@"重新发送(%@s)",strTime] forState:UIControlStateNormal];
                        self.VerificationBtn.userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);

}



- (IBAction)Verification:(UIButton *)sender {
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phone zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
          //  NSLog(@"获取验证码成功");
        } else {
            NSLog(@"错误信息：%@",error);
        }
    }];
}



- (IBAction)FinishBtn:(UIButton *)sender {
    
    if (self.passwordTextField.text.length<=20&&self.passwordTextField.text.length>=6) {
    
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary*para=@{@"validatestring":self.phone};
        
        [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
            if (!error) {
                
                [SMSSDK commitVerificationCode:self.VerificationTextField.text phoneNumber:self.phone zone:@"86" result:^(NSError *error) {
                    if (!error) {
                        NSDictionary*dic = data;
                        self.str=dic[@"str"];
                        [self requestchangePassword];
                    }
                    else
                    {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入验证码！" preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:nil]];
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }
                }];
                
            } else {
                
            }
        }];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入6~20位数字或英文密码！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }

}
//请求重置密码
-(void)requestchangePassword
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras = @{@"authenticationStr":self.phone,
                         @"encryptedStr":self.str,
                         @"telephone":self.phone,
                         @"password":self.passwordTextField.text};
    
    [manager POST:API_ResetPasswordk parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"密码重置成功" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            
        }
    }];
}


@end
