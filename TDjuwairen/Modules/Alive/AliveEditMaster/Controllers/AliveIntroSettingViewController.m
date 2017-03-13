//
//  AliveIntroSettingViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveIntroSettingViewController.h"
#import "UITextView+Placeholder.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "NotificationDef.h"

@interface AliveIntroSettingViewController ()<UITextViewDelegate, MBProgressHUDDelegate>

@end

@implementation AliveIntroSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.title = @"直播间介绍";
    
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(donePressed:)];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSBackgroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]}
                         forState:UIControlStateNormal];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSBackgroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#999999"]}
                         forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)donePressed:(id)sender {
    if (!self.intro.length) {
        return;
    }
    
    [self.view endEditing:YES];
    
    NSDictionary *dict = @{@"info": self.intro};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中";
    
    __weak AliveIntroSettingViewController *wself = self;
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_AliveUpdateRoomInfo parameters:dict completion:^(id data, NSError *error) {
        if (!error) {
            hud.labelText = @"提交成功";
            hud.delegate = wself;
            [hud hide:YES afterDelay:1];
        } else {
            hud.labelText = @"提交失败";
            [hud hide:YES afterDelay:1];
        }
    }];
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateAliveIntroNotification object:self.intro];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextView

- (void)textViewDidChange:(UITextView *)textView {
    self.intro = textView.text;
    self.navigationItem.rightBarButtonItem.enabled = self.intro.length;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString *string = textView.text;
    string = [string stringByReplacingCharactersInRange:range withString:string];
    
    if (text.length > 49) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveIntroCellID"];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AliveIntroCellID"];
        
        UITextView *textView = [[UITextView alloc] init];
        textView.delegate = self;
        textView.frame = CGRectMake(0, 0, kScreenWidth, 120);
        textView.font = [UIFont systemFontOfSize:15.0f];
        textView.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        textView.placeholder = @"很懒哦，一句介绍都木有";
        [cell.contentView addSubview:textView];
        
        textView.text = self.intro;
    }
    
    return cell;
}

@end
