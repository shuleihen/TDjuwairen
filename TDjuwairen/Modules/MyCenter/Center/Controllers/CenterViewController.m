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
#import "LoginHandler.h"
#import "CenterHeaderItemView.h"

@interface CenterViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerBgImageheight;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, strong) NSArray *classesArray;
@property (nonatomic, strong) IBOutlet CenterHeaderItemView *subscribeView;
@property (nonatomic, strong) IBOutlet CenterHeaderItemView *attentionView;
@property (nonatomic, strong) IBOutlet CenterHeaderItemView *fansView;
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
    
    
    self.avatarBtn.layer.cornerRadius = 32.5f;
    self.avatarBtn.clipsToBounds = YES;
    
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
    [self queryNotifyInfo];
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

- (void)setupAliveInfoWithDictionary:(NSDictionary *)dict {
    
    if (dict) {
        [LoginHandler saveUserInfoData:dict];
        
        NSInteger level = US.userLevel;
        if (level == kUserLevelBronze) {
            self.levelImageView.image = [UIImage imageNamed:@"tag_level1.png"];
        } else if (level == kUserLevelSilver) {
            self.levelImageView.image = [UIImage imageNamed:@"tag_level2.png"];
        } else if (level == kUserLevelGold) {
            self.levelImageView.image = [UIImage imageNamed:@"tag_level3.png"];
        } else {
            self.levelImageView.image = nil;
        }
    }
    
    if (US.isLogIn == YES) {
        [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal placeholderImage:TDCenterUserAvatar options:SDWebImageRefreshCached];
        
        self.nickNameLabel.text = US.nickName;
        self.sexImageView.image = US.sex?[UIImage imageNamed:@"ico_sex-man.png"]:[UIImage imageNamed:@"ico_sex-women.png"];
    } else {
        [self.avatarBtn setImage:TDCenterUserAvatar forState:UIControlStateNormal];
        self.nickNameLabel.text = @"登陆注册";
        self.levelImageView.image = nil;
    }
}

- (void)queryNotifyInfo {
    NetworkManager *manager = [[NetworkManager alloc] init];
    __weak CenterViewController *wself = self;
    
    [manager POST:API_UserGetNotify parameters:nil completion:^(id data, NSError *error){
        
        if (!error) {
            NSDictionary *dict = data;
            NSInteger dy = [dict[@"alive_num"] integerValue];
            NSInteger at = [dict[@"atten_num"] integerValue];
            NSInteger fan = [dict[@"fans_num"] integerValue];

            [wself.subscribeView setupNumber:dy];
            [wself.attentionView setupNumber:at];
            [wself.fansView setupNumber:fan];
        } else {
            
        }
        
    }];
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

- (IBAction)integralPressed:(id)sender {
    [self pushViewControllerWithClassName:@"IntegralViewController"];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 30)];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = [UIImage imageNamed:@"icon_arrow_light_grey.png"];
        cell.accessoryView = imageView;
    }
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
