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
#import "ViewManagerViewController.h"
#import "DaynightCellTableViewCell.h"

#import "CommentsViewController.h"
#import "CollectionViewController.h"
#import "BrowserViewController.h"
#import "UIdaynightModel.h"

@interface PersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource,DaynightCellTableViewCellDelegate>

@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *setupImgArr;
@property (nonatomic,strong) NSArray *setupTitleArr;

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightmodel = [UIdaynightModel sharedInstance];
    
    self.setupImgArr = @[@"btn_yejian@3x.png",@"tab_viewPoint_normal",@"SetupImg.png",@"Beedback.png"];
    self.setupTitleArr = @[@"夜间模式",@"观点管理",@"设置",@"反馈意见"];
    
    [self setupWithTableView];
    // Do any additional setup after loading the view.
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, -1, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
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
        return [self.setupTitleArr count];
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
        
        
        if (indexPath.row == 0) {
            NSString *identifier = @"dn";
            DaynightCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[DaynightCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            NSString *daynight = [userdefault objectForKey:@"daynight"];
            if ([daynight isEqualToString:@"yes"]) {
                [cell.mySwitch setOn:NO];
            }
            else
            {
                [cell.mySwitch setOn:YES];
            }
            cell.delegate = self;
            cell.imgView.image = [UIImage imageNamed:self.setupImgArr[indexPath.row]];
            cell.title.text = self.setupTitleArr[indexPath.row];
            cell.backgroundColor = self.daynightmodel.navigationColor;
            cell.title.textColor = self.daynightmodel.textColor;
            return cell;
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 190;
        }
        else
        {
            return 60;
        }
    }
    else
    {
        return 45;
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
            if (US.isLogIn == NO) {
                //跳转到登录页面
                LoginViewController *login = [[LoginViewController alloc] init];
                login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
                [self.navigationController pushViewController:login animated:YES];
            }
            else
            {
                //跳转到个人信息页面
                MyInfoViewController *MyInfo = [[MyInfoViewController alloc] init];
                MyInfo.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
                [self.navigationController pushViewController:MyInfo animated:YES];
            }
            
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 1) {
            //跳转到观点管理
            if (US.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
                //跳转到登录页面
                LoginViewController *login = [[LoginViewController alloc] init];
                login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
                [self.navigationController pushViewController:login animated:YES];
            }
            else//登录后 跳转设置页面
            {
                ViewManagerViewController *viewmanage = [[ViewManagerViewController alloc] init];
                [self.navigationController pushViewController:viewmanage animated:YES];
            }
            
        }
        else if (indexPath.row == 2) {
            if (US.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
                //跳转到登录页面
                LoginViewController *login = [[LoginViewController alloc] init];
                login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
                [self.navigationController pushViewController:login animated:YES];
            }
            else//登录后 跳转设置页面
            {
                SettingTableViewController *Setting=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingView"];
                [self.navigationController pushViewController:Setting animated:YES];
            }
        }
        else if(indexPath.row == 3)
        {
            if (US.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
                //跳转到登录页面
                LoginViewController *login = [[LoginViewController alloc] init];
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
    [self.tableview setSeparatorColor:self.daynightmodel.lineColor];
    [self.tableview reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    MyHeadTableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    if (US.isLogIn == YES) {
        //加载头像
        NSString*imagePath=[NSString stringWithFormat:@"%@",US.headImage];
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil options:SDWebImageRefreshCached];
        
        cell.nickname.text = US.nickName;
        
        //加载模糊背景图片
        NSString*Path=[NSString stringWithFormat:@"%@",US.headImage];
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
}

#pragma mark - 跳转到评论管理
- (void)GoComment:(UIButton *)sender{
    if (US.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
        //跳转到登录页面
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.navigationController pushViewController:login animated:YES];
    }
    else//登录后 跳转评论管理页面
    {
        CommentsViewController *comments = [[CommentsViewController alloc] init];
        comments.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:comments animated:YES];
    }
}

#pragma mark - 跳转到收藏管理
- (void)GoCollect:(UIButton *)sender{
    if (US.isLogIn == NO) {//检查是否登录，没有登录直接跳转登录界面
        //跳转到登录页面
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.navigationController pushViewController:login animated:YES];
    }
    else//登录后 跳转收藏管理页面
    {
        CollectionViewController *collection = [[CollectionViewController alloc] init];
        collection.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:collection animated:YES];
    }
}
#pragma mark - 跳转到浏览记录
- (void)GoBrowse:(UIButton *)serder{
    if (US.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
        //跳转到登录页面
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.navigationController pushViewController:login animated:YES];
    }
    else//登录后 跳转浏览记录页面
    {
        BrowserViewController *browser = [[BrowserViewController alloc] init];
        browser.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:browser animated:YES];
    }
}

- (void)updateSwitchAtIndexPath:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *daynight = [userdefault objectForKey:@"daynight"];
    
    if ([switchView isOn])
    {
        //do something..
        NSLog(@"开");
        [self.daynightmodel night];
        daynight = @"no";
        [userdefault setValue:daynight forKey:@"daynight"];
        [userdefault synchronize];
        self.tabBarController.tabBar.barTintColor = self.daynightmodel.navigationColor;
        self.tableview.backgroundColor = self.daynightmodel.backColor;
        [self.tableview reloadData];
    }
    else
    {
        //do something
        NSLog(@"关");
        [self.daynightmodel day];
        daynight = @"yes";
        [userdefault setValue:daynight forKey:@"daynight"];
        [userdefault synchronize];
        self.tabBarController.tabBar.barTintColor = self.daynightmodel.navigationColor;
        self.tableview.backgroundColor = self.daynightmodel.backColor;
        [self.tableview reloadData];
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