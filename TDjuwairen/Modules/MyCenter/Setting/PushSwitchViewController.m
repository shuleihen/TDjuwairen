//
//  PushSwitchViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/9/13.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PushSwitchViewController.h"
#import "LoginState.h"

@interface PushSwitchViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) LoginState *loginstate;

@property (nonatomic,strong) NSArray *titleArr;

@end

@implementation PushSwitchViewController

- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"回复提醒",@"推送通知"];
    }
    return _titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginstate = [LoginState sharedInstance];
    UIApplication *app = [UIApplication sharedApplication];
    NSLog(@"%@",[app currentUserNotificationSettings]);
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone) {
        self.loginstate.isPush = NO;
        self.loginstate.isReply = NO;
    }
    else
    {
        self.loginstate.isPush = YES;
        self.loginstate.isReply = YES;
    }
    
    [self setupWithNavigation];
    [self setupWithTableView];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{
    self.title = @"消息推送";
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UISwitch *myswitch = [[UISwitch alloc]initWithFrame:CGRectZero];
        cell.accessoryView = myswitch;
        [myswitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        if (indexPath.row == 0) {
            myswitch.on = self.loginstate.isReply;
        }
        if (indexPath.row == 1) {
            myswitch.on = self.loginstate.isPush;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}

- (void)switchAction:(UISwitch *)myswitch{
    UITableViewCell *cell = (UITableViewCell *)[myswitch superview];
    NSIndexPath* index=[self.tableview indexPathForCell:cell];
    if (index.row == 0) {
        //
        if (myswitch.on == NO) {
            self.loginstate.isPush = NO;
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
            [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeNone categories:nil];
        }
        else
        {
            self.loginstate.isPush = YES;
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|
             UIUserNotificationTypeBadge|
             UIUserNotificationTypeSound
                                              categories:nil];
        }
    }
    else
    {
        if (myswitch.on == NO) {
            self.loginstate.isPush = NO;
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
            [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeNone categories:nil];
        }
        else
        {
            self.loginstate.isPush = YES;
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|
                                                         UIUserNotificationTypeBadge|
                                                         UIUserNotificationTypeSound
                                              categories:nil];
        }
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
