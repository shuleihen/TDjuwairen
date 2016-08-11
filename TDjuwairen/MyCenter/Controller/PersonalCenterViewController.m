//
//  PersonalCenterViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "MyHeadTableViewCell.h"
#import "ManageButtonTableViewCell.h"
#import "SetUpTableViewCell.h"
#import "LoginState.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "MyInfoViewController.h"
#import "SettingTableViewController.h"
#import "FeedbackViewController.h"

#import "CommentsViewController.h"
#import "CollectionViewController.h"
#import "BrowserViewController.h"
#import "UIdaynightModel.h"

@interface PersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) LoginState *loginState;
@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *setupImgArr;
@property (nonatomic,strong) NSArray *setupTitleArr;

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginState = [LoginState addInstance];
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.setupImgArr = @[@"ViewPointUnSelect@3x.png",@"SetupImg.png",@"Beedback.png"];
    self.setupTitleArr = @[@"观点管理",@"设置",@"反馈意见"];
    
    [self setupWithTableView];
    // Do any additional setup after loading the view.
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, -21, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else
    {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *identifier = @"head";
            MyHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[MyHeadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.backgroundColor = self.daynightmodel.navigationColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            NSString *identifier = @"button";
            ManageButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[ManageButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                [cell.CommentManage addTarget:self action:@selector(GoComment:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.CollectManage addTarget:self action:@selector(GoCollect:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.BrowseManage addTarget:self action:@selector(GoBrowse:) forControlEvents:UIControlEventTouchUpInside];
            }
            [cell.CommentManage setTitleColor:self.daynightmodel.textColor forState:UIControlStateNormal];
            [cell.CollectManage setTitleColor:self.daynightmodel.textColor forState:UIControlStateNormal];
            [cell.BrowseManage setTitleColor:self.daynightmodel.textColor forState:UIControlStateNormal];
            cell.backgroundColor = self.daynightmodel.navigationColor;
            return cell;
        }
    }
    else
    {
        NSString *identifier = @"setup";
        SetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[SetUpTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.imgView.image = [UIImage imageNamed:self.setupImgArr[indexPath.row]];
        cell.title.text = self.setupTitleArr[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.backgroundColor = self.daynightmodel.navigationColor;
        cell.title.textColor = self.daynightmodel.textColor;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 190;
        }
        else
        {
            return 67;
        }
    }
    else
    {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.00000001f;
    }
    else
    {
        return 20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.loginState.isLogIn == NO) {
                //跳转到登录页面
                LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
                [self.navigationController pushViewController:login animated:YES];
            }
            else
            {
                //跳转到个人信息页面
                MyInfoViewController *MyInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"myinfo"];
                MyInfo.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
                [self.navigationController pushViewController:MyInfo animated:YES];
            }
            
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            if (self.loginState.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
                //跳转到登录页面
                LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
                [self.navigationController pushViewController:login animated:YES];
            }
            else//登录后 跳转设置页面
            {
                SettingTableViewController *Setting=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingView"];
                [self.navigationController pushViewController:Setting animated:YES];
            }
        }
        else
        {
            if (self.loginState.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
                //跳转到登录页面
                LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
                [self.navigationController pushViewController:login animated:YES];
            }
            else//登录后 跳转反馈意见页面
            {
                FeedbackViewController *feedback = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackView"];
                [self.navigationController pushViewController:feedback animated:YES];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    //set ui
    self.tabBarController.tabBar.barTintColor = self.daynightmodel.navigationColor;
    self.tableview.backgroundColor = self.daynightmodel.backColor;
    [self.tableview reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    MyHeadTableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    if (self.loginState.isLogIn == YES) {
        //加载头像
        NSString*imagePath=[NSString stringWithFormat:@"%@",self.loginState.headImage];
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil options:SDWebImageRefreshCached];
        
        cell.nickname.text = self.loginState.nickName;
        
        //加载模糊背景图片
        NSString*Path=[NSString stringWithFormat:@"%@",self.loginState.headImage];
        [cell.backImg sd_setImageWithURL:[NSURL URLWithString:Path] placeholderImage:nil options:SDWebImageRefreshCached];
    }
    else
    {
        cell.nickname.text = @"登陆注册";
        cell.headImg.image = [UIImage imageNamed:@"HeadUnLogin"];
        cell.backImg.image = [UIImage imageNamed:@"NotLogin.png"];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - 跳转到评论管理
- (void)GoComment:(UIButton *)sender{
    if (self.loginState.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
        //跳转到登录页面
        LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.navigationController pushViewController:login animated:YES];
    }
    else//登录后 跳转评论管理页面
    {
        CommentsViewController *comments = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentsView"];
        [self.navigationController pushViewController:comments animated:YES];
    }
}

#pragma mark - 跳转到收藏管理
- (void)GoCollect:(UIButton *)sender{
    if (self.loginState.isLogIn == NO) {//检查是否登录，没有登录直接跳转登录界面
        //跳转到登录页面
        LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.navigationController pushViewController:login animated:YES];
    }
    else//登录后 跳转收藏管理页面
    {
        CollectionViewController*collection=[self.storyboard instantiateViewControllerWithIdentifier:@"CollectionView"];
        [self.navigationController pushViewController:collection animated:YES];
    }
}
#pragma mark - 跳转到浏览浏览记录
- (void)GoBrowse:(UIButton *)serder{
    if (self.loginState.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
        //跳转到登录页面
        LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.navigationController pushViewController:login animated:YES];
    }
    else//登录后 跳转浏览记录页面
    {
        BrowserViewController*browser=[self.storyboard instantiateViewControllerWithIdentifier:@"BrowserView"];
        [self.navigationController pushViewController:browser animated:YES];
    }
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
