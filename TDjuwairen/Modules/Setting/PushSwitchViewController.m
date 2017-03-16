//
//  PushSwitchViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/9/13.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PushSwitchViewController.h"
#import "LoginState.h"
#import "LoginHandler.h"

@interface PushSwitchViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic, assign) BOOL isCanPush;
@end

@implementation PushSwitchViewController

- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"推送通知"];
    }
    return _titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWithNavigation];
    [self setupWithTableView];
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
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"PushSettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UISwitch *myswitch = [[UISwitch alloc]initWithFrame:CGRectZero];
        
        [myswitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        BOOL isClosePush = [[NSUserDefaults standardUserDefaults] boolForKey:@"isClosePush"];
        myswitch.on = !isClosePush;
        
        cell.accessoryView = myswitch;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleArr[indexPath.row];
    
    return cell;
}

- (void)switchAction:(UISwitch *)myswitch{
    
    if (myswitch.on == NO) {
        [LoginHandler closeRemotePush];
    } else {
        [LoginHandler openRemotePush];
    }
}

@end
