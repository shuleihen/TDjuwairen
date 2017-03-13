//
//  AliveCitySettingViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveCitySettingViewController.h"
#import "HexColors.h"
#import "NotificationDef.h"

@interface AliveCitySettingViewController ()

@end

@implementation AliveCitySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.title = @"城市选择";
    
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ChineseSubdivisions" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    
    if (self.level == 0) {
        self.items = array;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveCitySettingCellID"];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AliveCitySettingCellID"];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *dict = self.items[indexPath.row];
    cell.textLabel.text = [[dict allKeys] firstObject];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.level == 0) {
        NSDictionary *dict = self.items[indexPath.row];
        NSString *title = [[dict allKeys] firstObject];
        
        NSArray *array = [[dict allValues] firstObject];
        
        AliveCitySettingViewController *vc = [[AliveCitySettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.level = 2;
        vc.parent = title;
        vc.items = array;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSDictionary *dict = self.items[indexPath.row];
        NSString *title = [[dict allKeys] firstObject];
        
        if ([title isEqualToString:self.parent]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateAliveCityNotification object:title];
        } else {
            NSString *string = [NSString stringWithFormat:@"%@ %@",self.parent,title];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateAliveCityNotification object:string];
        }
        
    }
}
@end
