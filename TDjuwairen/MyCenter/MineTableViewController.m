//
//  MineTableViewController.m
//  juwairen
//
//  Created by tuanda on 16/5/16.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "MineTableViewController.h"
#import "LoginTableViewController.h"
#import "LoginState.h"
#import "UIImageView+WebCache.h"
#import "MyInfoTableViewController.h"
#import "SettingTableViewController.h"
#import "FeedbackViewController.h"
#import "BrowserViewController.h"
#import "CollectionViewController.h"
#import "CommentsViewController.h"

@interface MineTableViewController ()
{
    UIVisualEffectView *effectView;
}
@property(nonatomic,strong)LoginState*LoginState;

@end

@implementation MineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.LoginState=[LoginState addInstance];
    self.tableView.contentInset =UIEdgeInsetsMake(-100, 0, 0, 0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setNavgation];
    
    if (self.LoginState.isLogIn==YES) {
        //加载头像
        NSString*imagePath=[NSString stringWithFormat:@"%@",self.LoginState.headImage];
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil options:SDWebImageRefreshCached];
        
        self.accountName.text=self.LoginState.nickName;
        
        //加载模糊背景图片
        NSString*Path=[NSString stringWithFormat:@"%@",self.LoginState.headImage];
        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:Path] placeholderImage:nil options:SDWebImageRefreshCached];
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
        effectView.frame = CGRectMake(0, 0, kScreenWidth, self.backgroundImageView.frame.size.height);
        [self.backgroundImageView addSubview:effectView];
    }
    else
    {
        self.accountName.text=@"登陆注册";
        self.headImageView.image=[UIImage imageNamed:@"头像 140x140px"];
        self.backgroundImageView.image=[UIImage imageNamed:@"未登录默认背景图.png"];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [effectView removeFromSuperview];
}

-(void)setNavgation{
    
    
    //设置返回button
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    
   [backItem setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage* image = [UIImage imageNamed:@"back"];
    [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 60, 0, 10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
    
    //设置navigationbar透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        NSArray *list = self.navigationController.navigationBar.subviews;
        
        for (id obj in list) {
            
            if ([obj isKindOfClass:[UIImageView class]]) {
                
                UIImageView *imageView = (UIImageView *)obj;
                
                imageView.hidden = YES;
                
            }
            
        }
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0&&indexPath.row==0) {
        
        if (self.LoginState.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
            LoginTableViewController*login=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
            [self.navigationController pushViewController:login animated:YES];
        }
        else//登录后 跳转个人信息页面
        {
            MyInfoTableViewController*MyInfo=[self.storyboard instantiateViewControllerWithIdentifier:@"MyInfoView"];
            [self.navigationController pushViewController:MyInfo animated:YES];
        }
        
    }
    else if(indexPath.section==1&&indexPath.row==0)
    {
        if (self.LoginState.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
            LoginTableViewController*login=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
            [self.navigationController pushViewController:login animated:YES];
        }
        else//登录后 跳转设置页面
        {
            SettingTableViewController*Setting=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingView"];
            [self.navigationController pushViewController:Setting animated:YES];
        }

    }
    else if (indexPath.section==1&&indexPath.row==1)
    {
        if (self.LoginState.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
            LoginTableViewController*login=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
            [self.navigationController pushViewController:login animated:YES];
        }
        else//登录后 跳转反馈意见页面
        {
            FeedbackViewController*feedback=[self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackView"];
            [self.navigationController pushViewController:feedback animated:YES];
        }

    }
}

- (IBAction)commentBtn:(UIButton *)sender {
    if (self.LoginState.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
        LoginTableViewController*login=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.navigationController pushViewController:login animated:YES];
    }
    else//登录后 跳转评论管理页面
    {
        CommentsViewController *comments = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentsView"];
        [self.navigationController pushViewController:comments animated:YES];
    }
}

- (IBAction)collectionBtn:(UIButton *)sender {
    if (self.LoginState.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
        LoginTableViewController*login=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.navigationController pushViewController:login animated:YES];
    }
    else//登录后 跳转收藏管理页面
    {
        CollectionViewController*collection=[self.storyboard instantiateViewControllerWithIdentifier:@"CollectionView"];
        [self.navigationController pushViewController:collection animated:YES];
    }
    
}

- (IBAction)browserBtn:(UIButton *)sender {
    if (self.LoginState.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
        LoginTableViewController*login=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.navigationController pushViewController:login animated:YES];
    }
    else//登录后 跳转浏览记录页面
    {
        BrowserViewController*browser=[self.storyboard instantiateViewControllerWithIdentifier:@"BrowserView"];
        [self.navigationController pushViewController:browser animated:YES];
    }
}
@end
