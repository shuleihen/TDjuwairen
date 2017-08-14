//
//  CenterViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "CenterViewController.h"
#import "LoginStateManager.h"
#import "LoginViewController.h"
#import "UIButton+WebCache.h"
#import "NSString+Util.h"
#import "AliveMasterListViewController.h"
#import "NetworkManager.h"
#import "CenterItemView.h"
#import "AliveRoomViewController.h"
#import "UIImage+Resize.h"
#import "TDWebViewController.h"

@interface CenterViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerBgImageheight;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, strong) NSArray *classesArray;
@property (nonatomic, strong) IBOutlet CenterItemView *dynamicView;
@property (nonatomic, strong) IBOutlet CenterItemView *attentionView;
@property (nonatomic, strong) IBOutlet CenterItemView *fansView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.tableView.backgroundView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    
//    self.headerImageView.contentMode = UIViewContentModeCenter;
//    UIImage *image = [UIImage imageNamed:@"bg_mine.png"];
//    self.headerImageView.image = [image resize:CGSizeMake(kScreenWidth, 210)];
    
    self.avatarBtn.layer.cornerRadius = 32.5f;
    self.avatarBtn.clipsToBounds = YES;
    self.avatarBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarBtn.layer.borderWidth = 1.0f;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor hx_colorWithHexRGBAString:@"#2662D0"].CGColor,(__bridge id)[UIColor hx_colorWithHexRGBAString:@"#1BAFE7"].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, kScreenWidth, 180);
    self.gradientLayer = gradientLayer;
    [self.headerView.layer insertSublayer:gradientLayer atIndex:0];
    
    self.classesArray = @[@[],
                          @[@"", @"",@"CollectionViewController",],
                          @[@"SystemMessageViewController",@"AboutMineViewController"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self queryUserInfo];
    [self setupUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)queryUserInfo {
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    __weak CenterViewController *wself = self;
    
    [manager POST:API_GetUserInfo parameters:nil completion:^(id data, NSError *error){
        
        if (!error) {
            [wself setupAliveInfoWithDictionary:data];
            
        } else {
            [wself setupAliveInfoWithDictionary:nil];
        }
        
    }];
}

- (void)setupUserInfo {
    if (US.isLogIn == YES) {
        NSString *bigface = [US.headImage userBigAvatar];
        [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:bigface] forState:UIControlStateNormal placeholderImage:TDCenterUserAvatar options:SDWebImageRefreshCached];
        
        self.nickNameLabel.text = US.nickName;
    } else {
        [self.avatarBtn setImage:TDCenterUserAvatar forState:UIControlStateNormal];
        self.nickNameLabel.text = @"登陆注册";
        self.levelImageView.image = nil;
    }
}

- (void)setupAliveInfoWithDictionary:(NSDictionary *)dict {
    // 1表示黄金会员，0表示普通会员
    if (dict) {
        NSInteger dy = [dict[@"alive_num"] integerValue];
        NSInteger at = [dict[@"atten_num"] integerValue];
        NSInteger fan = [dict[@"fans_num"] integerValue];
        NSInteger level = [dict[@"user_level"] integerValue];
        
        [self.dynamicView setupNumber:dy];
        [self.attentionView setupNumber:at];
        [self.fansView setupNumber:fan];
        
        if (level == kUserLevelNormal) {
            self.levelImageView.image = [UIImage imageNamed:@"level_nomal.png"];
        } else if (level == kUserLevelGold) {
            self.levelImageView.image = [UIImage imageNamed:@"level_huangjin.png"];
        } else {
            self.levelImageView.image = nil;
        }
        
        US.userLevel = level;
    }
}

#pragma mark - Action
//- (IBAction)cancelPressed:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (IBAction)avatarPressed:(id)sender {
    if (US.isLogIn == NO) {
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
         login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    } else {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"MyInfoSetting" bundle:nil] instantiateInitialViewController];
         vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)liveDynamicPressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    } else {
        AliveRoomViewController *vc = [[AliveRoomViewController alloc] initWithMasterId:US.userId];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)attentionPressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    } else {
        AliveMasterListViewController *aliveMasterListVC = [[AliveMasterListViewController alloc] init];
        aliveMasterListVC.masterId = US.userId;
        aliveMasterListVC.listType = kAliveAttentionList;
        aliveMasterListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aliveMasterListVC animated:YES];
    }
    
}

- (IBAction)fansPressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    } else {
        AliveMasterListViewController *aliveMasterListVC = [[AliveMasterListViewController alloc] init];
        aliveMasterListVC.masterId = US.userId;
        aliveMasterListVC.listType = kAliveFansList;
        aliveMasterListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aliveMasterListVC animated:YES];
    }
}

// 会员中心
- (IBAction)memberCenterPressed:(id)sender {
    
    if (US.isLogIn == NO) {
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
        
    }else {
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"unique_str"];
        NSString *url = [NSString stringWithFormat:@"%@%@?unique_str=%@",API_HOST,API_UserVipCenter,accessToken];
        
        TDWebViewController *vc = [[TDWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (IBAction)walletPressed:(id)sender {
    [self pushViewControllerWithClassName:@"WalletViewController"];
}

- (IBAction)settingPressed:(id)sender {
    [self pushViewControllerWithClassName:@"SettingViewController"];
}

#pragma mark - UIScrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offy = scrollView.contentOffset.y;
    if (offy < 0) {
        self.gradientLayer.frame = CGRectMake(0, offy, kScreenWidth, 180-offy);
    }
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = self.classesArray[indexPath.section];
    NSString *className = array[indexPath.row];
    
    [self pushViewControllerWithClassName:className];
    
}

- (void)pushViewControllerWithClassName:(NSString *)className {
    if (!className.length) {
        return;
    }
    
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    } else {
        UIViewController *vc = [[NSClassFromString(className) alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
