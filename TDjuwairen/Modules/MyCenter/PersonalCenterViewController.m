//
//  PersonalCenterViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PersonalCenterViewController.h"
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
#import "UIButton+Align.h"

#define kPersonalHeaderViewHeight 210
#define kButtonsPanelHeight 75

@interface PersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource,DaynightCellTableViewCellDelegate>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *setupImgArr;
@property (nonatomic,strong) NSArray *setupTitleArr;
@property (nonatomic, strong) PersonalHeaderView *headerView;
@property (nonatomic, strong) UIView *buttonsPanel;
@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    self.setupImgArr = @[@[@"1"],@[@"icon_remind.png",@"icon_issued.png",@"icon_collection.png"],@[@"icon_us.png"],@[@"icon_setting.png"]];
    self.setupTitleArr = @[@[@"1"],@[@"消息提醒",@"发布管理",@"我的收藏"],@[@"关于我们"],@[@"设置"]];
    
    [self setupNavigationBar];
    [self setupWithTableView];
    [self setupButtons];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (US.isLogIn == YES) {
        NSString *bigface = [US.headImage stringByReplacingOccurrencesOfString:@"_70." withString:@"_200."];
        [self.headerView.headImg sd_setImageWithURL:[NSURL URLWithString:bigface] placeholderImage:nil options:SDWebImageRefreshCached];
        self.headerView.nickname.text = US.nickName;
    } else {
        self.headerView.nickname.text = @"登陆注册";
        self.headerView.headImg.image = [UIImage imageNamed:@"HeadUnLogin"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"我的";
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancel;
}

- (void)setupWithTableView {
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f8f8f8"];
    self.tableview.separatorColor = [UIColor hx_colorWithHexRGBAString:@"#eeeeee"];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.tableview];
    
    self.headerView = [[PersonalHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kPersonalHeaderViewHeight)];
    self.tableview.tableHeaderView = self.headerView;
    [self.headerView addTarget:self action:@selector(myInfoPressed:)];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(12, 30, 30, 30);
    [cancel setImage:[UIImage imageNamed:@"ico_close.png"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:cancel];
}

- (void)setupButtons {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 75)];
    view.backgroundColor = [UIColor whiteColor];
    
    NSArray *titles = @[@"评论管理",@"我的关注",@"我的钱包"];
    NSArray *images = @[@"icon_comment.png",@"icon_attention.png",@"icon_wallet.png"];
    NSArray *selectors = @[@"commentPressed:",@"collectPressed:",@"walletPressed:"];
    
    int i=0;
    CGFloat w = kScreenWidth/3;
    for (NSString *title in titles) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*w, 0, w, 75)];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
  
        [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#333333"] forState:UIControlStateNormal];
//        [btn dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
//        [btn dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateHighlighted];
        
        UIImage *image = [UIImage imageNamed:images[i]];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateHighlighted];
        
        SEL action = NSSelectorFromString(selectors[i]);
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        [btn align:BAVerticalImage withSpacing:12.0f];
        i++;
    }
    
//    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, kBannerHeiht+75.5, kScreenWidth, 0.5)];
//    sep.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
//    [view addSubview:sep];
    
    self.buttonsPanel = view;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.setupTitleArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.setupTitleArr[section];
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 75;
    }else {
        return 44;
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
        NSString *identifier = @"buttonCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell.contentView addSubview:self.buttonsPanel];
        }
        
        return cell;
    } else {
        NSString *identifier = @"UserCenterCellID";
        SetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[SetUpTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSArray *images = self.setupImgArr[indexPath.section];
        NSString *imageName = images[indexPath.row];
        
        NSArray *titles = self.setupTitleArr[indexPath.section];
        NSString *title = titles[indexPath.row];
        
        cell.imgView.image = [UIImage imageNamed:imageName];
        cell.title.text = title;
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section >= 1)
    {
        if (US.isLogIn==NO) {
            //跳转到登录页面
            LoginViewController *login = [[LoginViewController alloc] init];
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:login animated:YES];
            return;
        }
        
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            // 消息管理
            PushMessageViewController *messagePush = [[PushMessageViewController alloc]init];
            messagePush.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:messagePush animated:YES];
            
        }
        else if (indexPath.section == 1 && indexPath.row == 1) {
            // 发布管理
            ViewManagerViewController *viewmanage = [[ViewManagerViewController alloc] init];
            viewmanage.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewmanage animated:YES];
        }
        else if(indexPath.section == 1 && indexPath.row == 2) {
            // 收藏
            CollectionViewController *collection = [[CollectionViewController alloc] init];
            collection.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:collection animated:YES];
        }
        else if (indexPath.section == 2) {
            // 关于
            AboutMineViewController *aboutmine = [[AboutMineViewController alloc]init];
            aboutmine.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutmine animated:YES];
        }
        else if (indexPath.section == 3) {
            // 设置
            SettingUpViewController *Setting = [[SettingUpViewController alloc]init];
            Setting.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:Setting animated:YES];
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

- (void)commentPressed:(UIButton *)sender{
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

- (void)collectPressed:(UIButton *)sender{
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

- (void)walletPressed:(UIButton *)serder{
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
