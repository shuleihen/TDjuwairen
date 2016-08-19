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
#import "UIdaynightModel.h"

@interface SettingTableViewController ()<SKStoreProductViewControllerDelegate>
{
    float size;
}
@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightmodel = [UIdaynightModel sharedInstance];
    [self setNavigation];
    
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
    self.view.backgroundColor = self.daynightmodel.backColor;
    self.cell1.backgroundColor = self.daynightmodel.navigationColor;
    self.lab1.textColor = self.daynightmodel.textColor;
    
    self.cell2.backgroundColor = self.daynightmodel.navigationColor;
    self.lab2.textColor = self.daynightmodel.textColor;
    
    self.cell3.backgroundColor = self.daynightmodel.navigationColor;
    self.lab3.textColor = self.daynightmodel.textColor;
    
    self.cell4.backgroundColor = self.daynightmodel.navigationColor;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setNavigation
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"设置";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:self.daynightmodel.titleColor}];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row==0)//清除缓存
    {
        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"" message:@"是否清除缓存？" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
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
        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"" message:@"是否退出登录？" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            US.isLogIn=NO;
            US.userName=nil;
            US.headImage=nil;
            US.userId=nil;
            
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
