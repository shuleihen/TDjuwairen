//
//  RegiserSecondTableViewController.m
//  juwairen
//
//  Created by tuanda on 16/5/17.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "RegiserSecondTableViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "AFNetworking.h"
#import "LoginState.h"
#import "SurveyViewController.h"

@interface RegiserSecondTableViewController ()
@property(nonatomic,strong)LoginState*LoginState;
@end

@implementation RegiserSecondTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset =UIEdgeInsetsMake(-33, 0, 0, 0);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    //验证码的监听事件
    [self.messageBtn addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
    
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    
    self.finishBtn.layer.cornerRadius=5;
    [self.finishBtn setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:105.0/255.0 blue:177.0/255.0 alpha:1.0]];
    
    self.messageBtn.layer.cornerRadius=3;
    [self.messageBtn setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:105.0/255.0 blue:177.0/255.0 alpha:1.0]];

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
    [self setNavgation];
}

-(void)setNavgation
{
    UILabel*lable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
    lable.text=@"填写信息";
    self.navigationItem.titleView=lable;
    
}


//验证码倒计时
-(void)startTime
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
                        [self.messageBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                        self.messageBtn.userInteractionEnabled = YES;
                    });
                }else{
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [self.messageBtn setTitle:[NSString stringWithFormat:@"已发送(%@s)",strTime] forState:UIControlStateNormal];
                        self.messageBtn.userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);


}
//获取验证码
- (IBAction)messageBtn:(UIButton *)sender {
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phone zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            NSLog(@"获取验证码成功");
        } else {
            NSLog(@"错误信息：%@",error);
        }
    }];
}

//请求注册
-(void)requestRegiser
{
    if ([self.password.text isEqualToString:@""]) {
        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [SMSSDK commitVerificationCode:self.VerificationTextField.text phoneNumber:self.phone zone:@"86" result:^(NSError *error) {
            if (!error) {
                AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
                manager.responseSerializer=[AFJSONResponseSerializer serializer];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/Reg/doTelReg/"];
                NSDictionary*paras=@{@"telephone":self.phone,
                                     @"password":self.password.text,
                                     @"nickname":self.nickname.text};
                [manager POST:url parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSString*code=[responseObject objectForKey:@"code"];
                    if ([code isEqualToString:@"200"]) {
                        
                        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [self requestLogin];
                        }]];
                        [self presentViewController:alert animated:YES completion:nil];
                        
                        //跳转至主页面
                        SurveyViewController *survey = [self.storyboard instantiateViewControllerWithIdentifier:@"Survey"];
                        [self.navigationController popToViewController:survey animated:YES];
                    }
                    else
                    {
                        NSLog(@"注册失败！");
                        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"注册失败" preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"请求失败!");
                }];
                
            } else {
                NSLog(@"错误信息：%@",error);
                if ([self.VerificationTextField.text isEqualToString:@""]) {
                    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"验证码为空" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else{
                    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"验证码错误" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        }];
      }
}

-(void)requestLogin
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/Login/loginDo/"];
    NSDictionary*paras=@{@"account":self.phone,
                         @"password":self.password.text};
    
    [manager POST:url parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSLog(@"登陆成功");
            
            NSDictionary*dic=responseObject[@"data"];
        
            self.LoginState.userId=dic[@"user_id"];
            self.LoginState.userName=dic[@"user_name"];
            self.LoginState.userPhone=dic[@"userinfo_phone"];
            self.LoginState.headImage=dic[@"userinfo_faceimg"];
            self.LoginState.nickName=dic[@"user_nickname"];
            
            self.LoginState.isLogIn=YES;
            
            NSUserDefaults*accountDefaults=[NSUserDefaults standardUserDefaults];
            [accountDefaults setValue:self.phone forKey:@"account"];
            [accountDefaults setValue:self.password.text forKey:@"password"];
            [accountDefaults synchronize];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名，手机号或密码错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *conformAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [aler addAction:conformAction];
            [self presentViewController:aler animated:YES completion:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败!请检查网络链接!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *conformAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [aler addAction:conformAction];
        [self presentViewController:aler animated:YES completion:nil];
    }];

}

//完成注册
- (IBAction)finishBtn:(UIButton *)sender {
    if ([self.nickname.text isEqualToString:@""]) {
        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"昵称不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/Reg/checkNickname/"];
    NSDictionary*para=@{@"nickname":self.nickname.text};
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            [self requestRegiser];
        }
        else
        {
            UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"该昵称已注册" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    }
}
@end
