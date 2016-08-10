//
//  SettingTableViewController.m
//  juwairen
//
//  Created by tuanda on 16/5/24.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "SettingTableViewController.h"
#import "LoginState.h"
#import <StoreKit/SKStoreProductViewController.h>
#import "AboutViewController.h"

@interface SettingTableViewController ()<SKStoreProductViewControllerDelegate>
{
    float size;
}
@property (strong,nonatomic)LoginState *loginState;
@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset =UIEdgeInsetsMake(-33, 0, 0, 0);
    [self setNavigation];
    self.loginState=[LoginState addInstance];
    
    //获取沙盒路径
    NSString*rootPath=NSHomeDirectory();
    NSString*path=[NSString stringWithFormat:@"%@/Documents/",rootPath];
    //建立文件管理类
    NSFileManager*manager=[NSFileManager defaultManager];
    size=[[manager attributesOfItemAtPath:path error:nil]fileSize];
    
    self.cacheLabel.text=[NSString stringWithFormat:@"%.2fM",size/1024];
    if ([self.cacheLabel.text floatValue]<0.1) {
        self.cacheLabel.text=@"0.00M";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setNavigation
{
    //    @fql 删除 back 处理
    [self.navigationController.navigationBar setHidden:NO];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
    label.text=@"设置";
    self.navigationItem.titleView=label;
    
    //设置返回button
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    [backItem setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage* image = [UIImage imageNamed:@"back"];
    [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 60, 0, 10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row==0)//清除缓存
    {
        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"" message:@"是否清除缓存" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //取沙盒路径
            NSString *rootPath = NSHomeDirectory();
            NSString *path = [NSString stringWithFormat:@"%@/Documents/",rootPath];
            //建立文件管理类
            NSFileManager *manager=[NSFileManager defaultManager];
            NSString *name;
            NSDirectoryEnumerator *directoryEnumerator= [manager enumeratorAtPath:path];
            //遍历目录
            while (name=[directoryEnumerator nextObject]) {
                NSString *newPath=[NSString stringWithFormat:@"%@/%@",path,name];
                //执行删除沙盒目录里的图片
                [manager removeItemAtPath:newPath error:nil];
            }
            size = 0;
            self.cacheLabel.text = [NSString stringWithFormat:@"%.2fM",size];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];

        
        
    }
    else if (indexPath.section==0&&indexPath.row==1)//给我们评分
    {
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1125295972"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else if (indexPath.section==0&&indexPath.row==2)//关于我们
    {
        AboutViewController*about=[self.storyboard instantiateViewControllerWithIdentifier:@"AboutView"];
        [self.navigationController pushViewController:about animated:YES];
    }
    else//退出登录
    {
        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"" message:@"是否退出登录" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.loginState.isLogIn=NO;
            self.loginState.userName=nil;
            self.loginState.headImage=nil;
            self.loginState.userId=nil;
            
            NSUserDefaults*Defaults=[NSUserDefaults standardUserDefaults];
            [Defaults setValue:@"" forKey:@"loginStyle"];
            [Defaults setValue:@"" forKey:@"account"];
            [Defaults setValue:@"" forKey:@"password"];
            [Defaults setValue:@"" forKey:@"openid"];
            [Defaults setValue:@"" forKey:@"unionid"];
            [Defaults synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//取消按钮监听
-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
