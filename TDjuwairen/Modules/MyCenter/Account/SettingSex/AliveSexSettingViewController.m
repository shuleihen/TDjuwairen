//
//  AliveSexSettingViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveSexSettingViewController.h"
#import "NotificationDef.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"

@interface AliveSexSettingViewController ()<UITableViewDelegate>
@property (nonatomic, strong) NSArray *items;
@end

@implementation AliveSexSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"性别";
    
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    
    self.items = @[@"男",@"女"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveSexSettingCellID"];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AliveSexSettingCellID"];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
    }
    
    NSString *title = self.items[indexPath.row];
    cell.textLabel.text = title;
    
    if ([self.sex isEqualToString:title]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sex = nil;
    if (indexPath.row == 0) {
        sex = @"male";
    } else {
        sex = @"female";
    }

    [self updateSex:sex];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateAliveSexNotification object:sex];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateSex:(NSString *)sex {

    NSDictionary *dict = @{@"sex": sex?:@""};
    __weak AliveSexSettingViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_AliveUpdateUserSex parameters:dict completion:^(id data, NSError *error) {
        if (!error) {
            [wself.navigationController popViewControllerAnimated:YES];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"性别修改失败";
            [hud hideAnimated:YES afterDelay:0.8];
        }
    }];
}
@end
