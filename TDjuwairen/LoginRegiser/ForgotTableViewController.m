//
//  ForgotTableViewController.m
//  juwairen
//
//  Created by tuanda on 16/5/19.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "ForgotTableViewController.h"
#import "ForgotSecondTableViewController.h"
#import "AFNetworking.h"


@interface ForgotTableViewController ()

@end

@implementation ForgotTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset =UIEdgeInsetsMake(-33, 0, 0, 0);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self setNavgation];
    
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    
    self.NextBtn.layer.cornerRadius=5;
    [self.NextBtn setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:105.0/255.0 blue:177.0/255.0 alpha:1.0]];
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavgation
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
    label.text=@"找回密码";
    self.navigationItem.titleView=label;
    //设置返回button
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    [backItem setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage* image = [UIImage imageNamed:@"back"];
    [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 60, 0, 10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
    
}

- (IBAction)NextBtn:(UIButton *)sender {
    if ([self.forgotTextField.text isEqualToString:@""]||self.forgotTextField.text.length!=11) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的手机号！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        
        AFHTTPRequestOperationManager*manager=[[AFHTTPRequestOperationManager alloc]init];
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/Reg/checkTelephone/"];
        NSDictionary*para=@{@"telephone":self.forgotTextField.text};
        [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString*code=[responseObject objectForKey:@"code"];
            if ([code isEqualToString:@"200"]) {
                NSLog(@"手机号未注册！");
                UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"手机号未注册" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                ForgotSecondTableViewController*forgot=[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotSecondView"];
                forgot.phone=self.forgotTextField.text;
                [self.navigationController pushViewController:forgot animated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败！");
        }];

    }

}
@end
