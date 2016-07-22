//
//  MobileLoginViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MobileLoginViewController.h"
#import <SMS_SDK/SMSSDK.h>

@interface MobileLoginViewController ()

@property (nonatomic,strong) UITextField *accountText;
@property (nonatomic,strong) UITextField *validationText;
@property (nonatomic,strong) UIButton *validationBtn;

@end

@implementation MobileLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
    
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [self setupWithNavigation];
    [self setupWithLogoImage];
    [self setupWithTextView];
    [self setupWithLogin];
    // Do any additional setup after loading the view.
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

- (void)setupWithNavigation{
    [self.navigationController.navigationBar setHidden:NO];
    //设置navigation背景色
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"手机短信验证登录";
    // 设置标题颜色，和大小,如果标题是使用titleView方式定义不行
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    
    //设置返回button
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    
    [backItem setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage* image = [UIImage imageNamed:@"back"];
    [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 60, 0, 10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
    
    //设置右边注册按钮
    UIBarButtonItem *regist = [[UIBarButtonItem alloc]initWithTitle:@"注册账号" style:UIBarButtonItemStyleDone target:self action:@selector(ClickRegister:)];
    self.navigationItem.rightBarButtonItem = regist;
}

- (void)setupWithLogoImage{
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 120)];
    imageview.image = [UIImage imageNamed:@"jwr.jpg"];
    [self.view addSubview:imageview];
}

- (void)setupWithTextView{
    self.accountText = [[UITextField alloc]initWithFrame:CGRectMake(0, kScreenWidth/8*3+64, kScreenWidth, 47)];
    self.accountText.backgroundColor = [UIColor whiteColor];
    self.accountText.textColor = [UIColor darkGrayColor];
    self.accountText.font = [UIFont systemFontOfSize:14];
    self.accountText.placeholder = @"请输入手机号";
    self.accountText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.accountText.leftViewMode = UITextFieldViewModeAlways;
    
    self.validationText = [[UITextField alloc]initWithFrame:CGRectMake(0, kScreenWidth/8*3+64+47+1, kScreenWidth, 47)];
    self.validationText.backgroundColor = [UIColor whiteColor];
    self.validationText.textColor = [UIColor darkGrayColor];
    self.validationText.font = [UIFont systemFontOfSize:14];
    self.validationText.placeholder = @"请输入验证码";
    self.validationText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.validationText.leftViewMode = UITextFieldViewModeAlways;
    //竖线
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-8-81, kScreenWidth/8*3+64+47+1+18, 1, 12)];
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 1.0;
    
    self.validationBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-8-80, kScreenWidth/8*3+64+47+1, 80, 47)];
    self.validationBtn.backgroundColor = [UIColor clearColor];
    [self.validationBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.validationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.validationBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateNormal];
    //验证码的监听事件
    [self.validationBtn addTarget:self action:@selector(Verification) forControlEvents:UIControlEventTouchUpInside];
    [self.validationBtn addTarget:self action:@selector(ClickSend:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.accountText];
    [self.view addSubview:self.validationText];
    [self.view addSubview:self.validationBtn];
    [self.view addSubview:label];
}
- (void)ClickSend:(UIButton *)sender{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.accountText.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            //  NSLog(@"获取验证码成功");
        } else {
            NSLog(@"错误信息：%@",error);
        }
    }];
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
                [self.validationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.validationBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateNormal];
                
                self.validationBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.validationBtn setTitle:[NSString stringWithFormat:@"重新发送(%@s)",strTime] forState:UIControlStateNormal];
                [self.validationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                self.validationBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

- (void)setupWithLogin{
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, kScreenWidth/8*3+64+47+47+1+30, kScreenWidth-30, 50)];
    loginBtn.backgroundColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 5;//圆角半径
    [loginBtn addTarget:self action:@selector(ClickLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

#pragma mark - 点击注册
- (void)ClickRegister:(UIButton *)sender{
    //
}

#pragma mark - 点击登录
- (void)ClickLogin:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
