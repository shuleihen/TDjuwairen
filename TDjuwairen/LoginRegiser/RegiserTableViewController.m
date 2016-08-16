//
//  RegiserTableViewController.m
//  juwairen
//
//  Created by tuanda on 16/5/17.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "RegiserTableViewController.h"
#import "RegiserSecondTableViewController.h"
#import "AgreeViewController.h"
#import "NetworkManager.h"


@interface RegiserTableViewController ()

@end

@implementation RegiserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset =UIEdgeInsetsMake(-33, 0, 0, 0);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self setNavgation];
    [self.checkbox setBackgroundImage:[UIImage imageNamed:@"用户协议未同意"] forState:UIControlStateNormal];
    
    [self.checkbox setBackgroundImage:[UIImage imageNamed:@"用户协议同意"] forState:UIControlStateSelected];
    
    [self.checkbox setSelected:YES];
    
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    self.Regiser.layer.cornerRadius=5;
    [self.Regiser setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:105.0/255.0 blue:177.0/255.0 alpha:1.0]];
    [self.agreeBtn setTitleColor:[UIColor colorWithRed:27.0/255.0 green:105.0/255.0 blue:177.0/255.0 alpha:1.0]forState:UIControlStateNormal];
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置navgation
-(void)setNavgation
{
    //设置标题
    UILabel*lable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
    lable.text=@"注册";
    self.navigationItem.titleView=lable;
    
    //设置返回button
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    [backItem setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage* image = [UIImage imageNamed:@"back"];
    [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 60, 0, 10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
}



- (IBAction)RegiserBtn:(UIButton *)sender {
    
    if ([self.phonetext.text isEqualToString:@""]||self.phonetext.text.length!=11) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的手机号！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary*para=@{@"telephone":self.phonetext.text};
        
        [manager POST:API_CheckPhone parameters:para completion:^(id data, NSError *error){
            if (!error) {
                RegiserSecondTableViewController*regiser=[self.storyboard instantiateViewControllerWithIdentifier:@"SecondView"];
                regiser.phone=self.phonetext.text;
                [self.navigationController pushViewController:regiser animated:YES];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号已注册！" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
}

//用户协议勾选框
- (IBAction)checkbox:(UIButton *)sender {
    sender.selected=!sender.selected;
    if (sender.selected) {
        [self.Regiser setTitle:@"下一步" forState:UIControlStateNormal];
        self.Regiser.enabled=YES;
        [self.Regiser setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:105.0/255.0 blue:177.0/255.0 alpha:1.0]];
    }
    else
    {
        [self.Regiser setTitle:@"下一步" forState:UIControlStateDisabled];
        self.Regiser.enabled=NO;
        [self.Regiser setBackgroundColor:[UIColor grayColor]];
    }
    
}
- (IBAction)agreeBtn:(UIButton *)sender {
    AgreeViewController*agree=[self.storyboard instantiateViewControllerWithIdentifier:@"AgreeView"];
    [self.navigationController pushViewController:agree animated:YES];
}
@end
