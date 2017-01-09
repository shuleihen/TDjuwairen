//
//  PersonalCenterViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "ManageButtonTableViewCell.h"
#import "SetUpTableViewCell.h"
#import "LoginState.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "SettingUpViewController.h"
#import "AboutMineViewController.h"
#import "ViewManagerViewController.h"
#import "DaynightCellTableViewCell.h"
#import "PushMessageViewController.h"
#import "CommentsViewController.h"
#import "CollectionViewController.h"
#import "MyWalletViewController.h"
#import "MyAttentionViewController.h"
#import "HexColors.h"
#import "YXFont.h"
#import "UIStoryboard+MainStoryboard.h"
#import "PersonalHeaderView.h"
#import "UIdaynightModel.h"
#import "NotificationDef.h"

@interface PersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource,DaynightCellTableViewCellDelegate>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *setupImgArr;
@property (nonatomic,strong) NSArray *setupTitleArr;
@property (nonatomic, strong) PersonalHeaderView *headerView;
@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    self.setupImgArr = @[@"icon_night.png",@"icon_remind.png",@"icon_issued.png",@"icon_collection.png",@"icon_setting.png",@"icon_us.png"];
    self.setupTitleArr = @[@"夜间模式",@"消息提醒",@"发布管理",@"我的收藏",@"设置",@"关于我们"];
    
    [self setupNavigationBar];
    [self setupWithTableView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (US.isLogIn == YES) {
        NSString *bigface = [US.headImage stringByReplacingOccurrencesOfString:@"_70." withString:@"_200."];
        [self.headerView.headImg sd_setImageWithURL:[NSURL URLWithString:bigface] placeholderImage:nil options:SDWebImageRefreshCached];
        [self.headerView.backImg sd_setImageWithURL:[NSURL URLWithString:US.headImage] placeholderImage:nil options:SDWebImageRefreshCached];
        self.headerView.nickname.text = US.nickName;
        self.headerView.backImg.hidden = NO;
    } else {
        self.headerView.nickname.text = @"登陆注册";
        self.headerView.headImg.image = [UIImage imageNamed:@"HeadUnLogin"];
        self.headerView.backImg.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"我的";
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancel;
}

- (void)setupWithTableView {
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-50) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableview.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    self.tableview.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [self.view addSubview:self.tableview];
    
    self.headerView = [[PersonalHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
    self.tableview.tableHeaderView = self.headerView;
    [self.headerView addTarget:self action:@selector(myInfoPressed:)];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return [self.setupTitleArr count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    }else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *identifier = @"buttonCelL";
        ManageButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ManageButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell.CommentManage addTarget:self action:@selector(GoComment:) forControlEvents:UIControlEventTouchUpInside];
            [cell.CollectManage addTarget:self action:@selector(GoCollect:) forControlEvents:UIControlEventTouchUpInside];
            [cell.BrowseManage addTarget:self action:@selector(GoBrowse:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
        
        return cell;
    } else {
        if (indexPath.row == 0) {
            NSString *identifier = @"dn";
            DaynightCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[DaynightCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
                [cell.mySwitch setOn:YES];
            } else {
                [cell.mySwitch setOn:NO];
            }
            

            cell.delegate = self;
            cell.imgView.image = [UIImage imageNamed:self.setupImgArr[indexPath.row]];
            cell.title.text = self.setupTitleArr[indexPath.row];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            NSString *identifier = @"setup";
            SetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[SetUpTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.imgView.image = [UIImage imageNamed:self.setupImgArr[indexPath.row]];
            cell.title.text = self.setupTitleArr[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        if (US.isLogIn==NO) {
            //跳转到登录页面
            LoginViewController *login = [[LoginViewController alloc] init];
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:login animated:YES];
            return;
        }
        
        if (indexPath.row == 1) {
            // 消息管理
            PushMessageViewController *messagePush = [[PushMessageViewController alloc]init];
            messagePush.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:messagePush animated:YES];
            
        }
        else if (indexPath.row == 2) {
            // 发布管理
            ViewManagerViewController *viewmanage = [[ViewManagerViewController alloc] init];
            viewmanage.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewmanage animated:YES];
        }
        else if(indexPath.row == 3) {
            // 收藏
            CollectionViewController *collection = [[CollectionViewController alloc] init];
            collection.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:collection animated:YES];
        }
        else if (indexPath.row == 4) {
            // 设置
            SettingUpViewController *Setting = [[SettingUpViewController alloc]init];
            Setting.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:Setting animated:YES];
        }
        else if (indexPath.row == 5) {
            // 关于
            AboutMineViewController *aboutmine = [[AboutMineViewController alloc]init];
            aboutmine.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutmine animated:YES];
        }
    }
}

#pragma mark - Action
- (void)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)myInfoPressed:(id)sender {
    if (US.isLogIn == NO) {
        //跳转到登录页面
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.navigationController pushViewController:login animated:YES];
    }
    else
    {
        //跳转到个人信息页面
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"MyInfoSetting" bundle:nil] instantiateInitialViewController];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

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

- (void)GoCollect:(UIButton *)sender{
    if (US.isLogIn == NO) {//检查是否登录，没有登录直接跳转登录界面
        //跳转到登录页面
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.navigationController pushViewController:login animated:YES];
    }
    else//登录后 跳转我的关注页面
    {
        MyAttentionViewController *MyAttention = [[MyAttentionViewController alloc]init];
        MyAttention.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:MyAttention animated:YES];
    }
}

- (void)GoBrowse:(UIButton *)serder{
    if (US.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
        //跳转到登录页面
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.navigationController pushViewController:login animated:YES];
    }
    else//登录后 跳转我的钱包
    {
        MyWalletViewController *myWallet = [[MyWalletViewController alloc] init];
        myWallet.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myWallet animated:YES];
    }
}

- (void)updateSwitchAtIndexPath:(id)sender
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    UIdaynightModel *daynightmodel = [UIdaynightModel sharedInstance];
    
    // 夜间模式切换
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        [self.dk_manager dawnComing];
        [daynightmodel day];
        [userdefault setObject:@"yes" forKey:@"daynight"];
    } else {
        [self.dk_manager nightFalling];
        [daynightmodel night];
        [userdefault setObject:@"no" forKey:@"daynight"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNightVersionChanged object:nil];
}

@end
