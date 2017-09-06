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
#import "StockPoolSubscribeController.h"
#import "CenterTableViewCell.h"
#import "TDWebViewHandler.h"
#import "AboutMineViewController.h"
#import "SettingViewController.h"
#import "SystemMessageViewController.h"

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
@property (weak, nonatomic) IBOutlet UIView *headerItemContainView;
@property (weak, nonatomic) IBOutlet UILabel *userPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *userKeyLabel;
@property (nonatomic, assign) NSInteger userLevelExpireDay;
@property (weak, nonatomic) IBOutlet UIButton *guessRateBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;

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
    self.settingBtn.hidden = !US.isLogIn;
    self.guessRateBtn.hidden = YES;
    self.loginLabel.hidden = YES;
    self.sexImageView.image = nil;
    
    if (US.isLogIn) {
        self.nickNameLabel.text = US.nickName;
    } else {
        self.nickNameLabel.text = @"";
    }
    
    [self.subscribeView setupNumber:0];
    [self.attentionView setupNumber:0];
    [self.fansView setupNumber:0];
    self.userPointsLabel.text = @"0";
    self.userKeyLabel.text = @"0";
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor hx_colorWithHexRGBAString:@"#2662D0"].CGColor,(__bridge id)[UIColor hx_colorWithHexRGBAString:@"#1BAFE7"].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, kScreenWidth, 180);
    self.gradientLayer = gradientLayer;
    [self.headerView.layer insertSublayer:gradientLayer atIndex:0];
    
    // 投影
    self.headerItemContainView.layer.shadowColor = [UIColor hx_colorWithHexRGBAString:@"#E8E8E8"].CGColor;
    self.headerItemContainView.layer.shadowOffset = CGSizeMake(0, 5);
    
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
    
    [manager GET:API_GetUserInfo parameters:nil completion:^(id data, NSError *error){
        
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
    } else {
        [self.subscribeView setupNumber:0];
        [self.attentionView setupNumber:0];
        [self.fansView setupNumber:0];
        self.userPointsLabel.text = @"0";
        self.userKeyLabel.text = @"0";
    }
    
    if (US.isLogIn == YES) {
        [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal placeholderImage:TDCenterUserAvatar options:SDWebImageRefreshCached];
        
        self.nickNameLabel.text = US.nickName;
        self.sexImageView.image = (US.sex==kUserSexMan)?[UIImage imageNamed:@"ico_sex-man.png"]:[UIImage imageNamed:@"ico_sex-women.png"];
        self.loginLabel.hidden = YES;
    } else {
        [self.avatarBtn setImage:TDCenterUserAvatar forState:UIControlStateNormal];
        self.nickNameLabel.text = @"";
        self.levelImageView.image = nil;
        self.sexImageView.image = nil;
        self.loginLabel.hidden = NO;
    }
    
    self.settingBtn.hidden = !US.isLogIn;
    self.guessRateBtn.hidden = !US.isLogIn;
}

- (void)queryNotifyInfo {
    NetworkManager *manager = [[NetworkManager alloc] init];
    __weak CenterViewController *wself = self;
    
    [manager POST:API_UserGetNotify parameters:nil completion:^(id data, NSError *error){
        
        [wself setupNotifiInfoWithDictionary:data];
    }];
}

- (void)setupNotifiInfoWithDictionary:(NSDictionary *)dict {
    if (dict == nil) {
        return;
    }
    
    NSInteger dy = [dict[@"stockpool_sub_num"] integerValue];
    NSInteger at = [dict[@"atten_num"] integerValue];
    NSInteger fan = [dict[@"fans_num"] integerValue];
    NSInteger userinfo_points = [dict[@"userinfo_points"] integerValue];
    NSInteger user_keynum = [dict[@"user_keynum"] integerValue];
    NSInteger expireDay = [dict[@"vip_expire_day"] integerValue];
    float guess_rate = [dict[@"guess_rate"] floatValue];
    
    [self.subscribeView setupNumber:dy];
    [self.attentionView setupNumber:at];
    [self.fansView setupNumber:fan];
    self.userPointsLabel.text = [NSString stringWithFormat:@"%ld",(long)userinfo_points];
    self.userKeyLabel.text = [NSString stringWithFormat:@"%ld",(long)user_keynum];
    
    self.userLevelExpireDay = expireDay;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    
    NSString *string = [NSString stringWithFormat:@"%.1lf",guess_rate];
    [self.guessRateBtn setTitle:string forState:UIControlStateNormal];
}

#pragma mark - Action

- (IBAction)avatarPressed:(id)sender {
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

- (IBAction)subscribePressed:(id)sender {
    if (US.isLogIn == NO) {
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
        
    }else {
        StockPoolSubscribeController *mySubcriptionVC = [[StockPoolSubscribeController alloc] init];
        mySubcriptionVC.vcType = kMCSPSubscibeVCCurrentType;
        mySubcriptionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mySubcriptionVC animated:YES];
    }
}

- (IBAction)walletPressed:(id)sender {
    [self pushH5WebViewController:API_H5UserWalletList];
}

- (IBAction)integralPressed:(id)sender {
    [self pushH5WebViewController:API_H5UserPointsList];
}

- (IBAction)settingPressed:(id)sender {
    SettingViewController *vc = [[SettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
    
    CenterTableViewCell *centerCell;
    if ([cell isKindOfClass:[CenterTableViewCell class]]) {
        centerCell = (CenterTableViewCell *)cell;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        // 会员中心
        centerCell.iconImageView.image = [UIImage imageNamed:@"ico_membership.png"];
        centerCell.titleLabel.text = @"会员中心";
        
        if (self.userLevelExpireDay != 0) {
            centerCell.detailLabel.text = [NSString stringWithFormat:@"过期%ld天", (long)self.userLevelExpireDay];
            centerCell.detailLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#FF5D5D"];
        } else {
            centerCell.detailLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#CCCCCC"];
            if (US.userLevel == kUserLevelNormal) {
                centerCell.detailLabel.text = @"成为会员享受更多特权";
            } else if (US.userLevel == kUserLevelBronze) {
                centerCell.detailLabel.text = @"青铜会员";
            } else if (US.userLevel == kUserLevelSilver) {
                centerCell.detailLabel.text = @"白银会员";
            } else if (US.userLevel == kUserLevelGold) {
                centerCell.detailLabel.text = @"黄金会员";
            }
        }
        
        
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        // 任务中心
        centerCell.iconImageView.image = [UIImage imageNamed:@"ico_mission.png"];
        centerCell.titleLabel.text = @"任务中心";
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        // 我的收藏
        centerCell.iconImageView.image = [UIImage imageNamed:@"icon_collection.png"];
        centerCell.titleLabel.text = @"我的收藏";
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        // 系统消息
        centerCell.iconImageView.image = [UIImage imageNamed:@"ico_system.png"];
        centerCell.titleLabel.text = @"系统消息";
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        // 关于我们
        centerCell.iconImageView.image = [UIImage imageNamed:@"ico_aboutus.png"];
        centerCell.titleLabel.text = @"关于我们";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 &&
        indexPath.row == 0) {
        // 会员中心
        [self pushH5WebViewController:API_H5UserVipCenter];
    } else if (indexPath.section == 1 &&
               indexPath.row == 1) {
        // 任务中心
        [self pushH5WebViewController:API_H5UserMission];
    } else if (indexPath.section == 2 &&
               indexPath.row == 0) {
        // 系统消息
        SystemMessageViewController *vc = [[SystemMessageViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 2 &&
               indexPath.row == 1) {
        // 关于我们
        AboutMineViewController *vc = [[AboutMineViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSArray *array = self.classesArray[indexPath.section];
        NSString *className = array[indexPath.row];
        
        [self pushViewControllerWithClassName:className];
    }
}

- (void)pushH5WebViewController:(NSString *)h5String {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    } else {
        [TDWebViewHandler openURL:h5String withUserMark:YES inNav:self.navigationController];
    }
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
