//
//  CenterViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "CenterViewController.h"
#import "LoginState.h"
#import "LoginViewController.h"
#import "UIButton+WebCache.h"
#import "NSString+Util.h"
#import "AliveMasterListViewController.h"
#import "NetworkManager.h"
#import "CenterItemView.h"
#import "AliveRoomViewController.h"

@interface CenterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, strong) NSArray *classesArray;
@property (nonatomic, strong) IBOutlet CenterItemView *dynamicView;
@property (nonatomic, strong) IBOutlet CenterItemView *attentionView;
@property (nonatomic, strong) IBOutlet CenterItemView *fansView;
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
    
    self.avatarBtn.layer.cornerRadius = 40.0f;
    self.avatarBtn.clipsToBounds = YES;
    self.avatarBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarBtn.layer.borderWidth = 1.0f;
    
    self.classesArray = @[@[],
                          @[@"MyWalletViewController",@"CollectionViewController"],
                          @[@"PushMessageViewController",@"CommentsViewController"],
                          @[@"AboutMineViewController"],
                          @[@"SettingUpViewController"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self queryUserInfo];
    [self setupUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
            
        }
        
    }];
}

- (void)setupUserInfo {
    if (US.isLogIn == YES) {
        NSString *bigface = [US.headImage userBigAvatar];
        [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:bigface] forState:UIControlStateNormal placeholderImage:TDDefaultUserAvatar options:SDWebImageRefreshCached];
        
        self.nickNameLabel.text = US.nickName;
    } else {
        [self.avatarBtn setImage:TDDefaultUserAvatar forState:UIControlStateNormal];
        self.nickNameLabel.text = @"登陆注册";
    }
}

- (void)setupAliveInfoWithDictionary:(NSDictionary *)dict {
    if (dict) {
        NSInteger dy = [dict[@"alive_num"] integerValue];
        NSInteger at = [dict[@"atten_num"] integerValue];
        NSInteger fan = [dict[@"fans_num"] integerValue];
        
        [self.dynamicView setupNumber:dy];
        [self.attentionView setupNumber:at];
        [self.fansView setupNumber:fan];
    }
}

#pragma mark - Action
- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)avatarPressed:(id)sender {
    if (US.isLogIn == NO) {
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:login animated:YES];
    } else {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"MyInfoSetting" bundle:nil] instantiateInitialViewController];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)liveDynamicPressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    } else {
        AliveRoomViewController *vc = [[AliveRoomViewController alloc] init];
        vc.masterId = US.userId;
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
        aliveMasterListVC.listType = AliveAttentionList;
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
        aliveMasterListVC.listType = AliveFansList;
        [self.navigationController pushViewController:aliveMasterListVC animated:YES];
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
    
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    } else {
        UIViewController *vc = [[NSClassFromString(className) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
