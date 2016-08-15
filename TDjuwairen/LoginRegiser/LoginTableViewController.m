//
//  LoginTableViewController.m
//  juwairen
//
//  Created by tuanda on 16/5/17.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "LoginTableViewController.h"
#import "RegiserTableViewController.h"
#import "ForgotTableViewController.h"
#import "LoginState.h"
#import "AFNetworking.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "NetworkManager.h"

@interface LoginTableViewController ()

@property(nonatomic,strong)LoginState*LoginState;
@end

@implementation LoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset =UIEdgeInsetsMake(-33, 0, 0, 0);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.LoginState=[LoginState addInstance];
    
    [self.openBtn setBackgroundImage:[UIImage imageNamed:@"关闭显示"] forState:UIControlStateNormal];
     [self.openBtn setBackgroundImage:[UIImage imageNamed:@"显示密码"] forState:UIControlStateSelected];
    [self.openBtn setSelected:NO];
    
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    self.loginBtn.layer.cornerRadius=5;
    [self.loginBtn setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:105.0/255.0 blue:177.0/255.0 alpha:1.0]];
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
//    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


//设置navgation
-(void)setNavgation
{
    //    @fql 删除 back 处理
    //标题
    UILabel*Title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
    Title.text=@"登录";
    self.navigationItem.titleView=Title;
    
    //注册button
    UIBarButtonItem*regiserBtn=[[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(regiserClick)];
    
    self.navigationItem.rightBarButtonItem=regiserBtn;
    
    //设置返回button
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    [backItem setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage* image = [UIImage imageNamed:@"back"];
    [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 60, 0, 10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
}
//注册button的点击事件
-(void)regiserClick
{
    RegiserTableViewController*regiser=[self.storyboard instantiateViewControllerWithIdentifier:@"RegiserView"];
    [self.navigationController pushViewController:regiser animated:YES];
}



- (IBAction)loginBtn:(UIButton *)sender {
    
    if ([self.accountTextField.text isEqualToString:@""]||[self.passwordTextField.text isEqualToString:@""]) {
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入用户名或手机号和密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *conformAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [aler addAction:conformAction];
        [self presentViewController:aler animated:YES completion:nil];
    }
    else{
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary*paras = @{@"account":self.accountTextField.text,
                             @"password":self.passwordTextField.text};
        
        [manager POST:API_Login parameters:paras completion:^(id data, NSError *error){
            if (!error) {
                NSDictionary *dic = data;
                self.LoginState.userId=dic[@"user_id"];
                self.LoginState.userName=dic[@"user_name"];
                self.LoginState.nickName=dic[@"user_nickname"];
                self.LoginState.userPhone=dic[@"userinfo_phone"];
                self.LoginState.headImage=dic[@"userinfo_facesmall"];
                self.LoginState.company=dic[@"userinfo_company"];
                self.LoginState.post=dic[@"userinfo_occupation"];
                self.LoginState.personal=dic[@"userinfo_info"];
                
                self.LoginState.isLogIn=YES;
                
                NSUserDefaults*accountDefaults=[NSUserDefaults standardUserDefaults];
                [accountDefaults setValue:self.accountTextField.text forKey:@"account"];
                [accountDefaults setValue:self.passwordTextField.text forKey:@"password"];
                [accountDefaults synchronize];
                
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                if (error.code == NSURLErrorTimedOut) {
                    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名，手机号或密码错误" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *conformAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    [aler addAction:conformAction];
                    [self presentViewController:aler animated:YES completion:nil];
                } else {
                    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败!请检查网络链接!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *conformAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    
                    [aler addAction:conformAction];
                    [self presentViewController:aler animated:YES completion:nil];
                }
            }
        }];
    }
}

- (IBAction)forgotBtn:(UIButton *)sender {
    ForgotTableViewController*forgot=[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotView"];
    [self.navigationController pushViewController:forgot animated:YES];
}
- (IBAction)openBtn:(UIButton *)sender {
    sender.selected=!sender.selected;
    if (sender.selected) {
        [self.passwordTextField setSecureTextEntry:NO];
    }
    else
    {
        [self.passwordTextField setSecureTextEntry:YES];
    }
    
}
- (IBAction)QQdenglu:(UIButton *)sender {
    /* 取消授权 */
    [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}
- (IBAction)WXdenglu:(UIButton *)sender {
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         NSLog(@"%lu",(unsigned long)state);
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}

@end
