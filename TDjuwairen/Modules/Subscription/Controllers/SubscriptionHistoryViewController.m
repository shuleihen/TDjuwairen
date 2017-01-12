//
//  SubscriptionHistoryViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SubscriptionHistoryViewController.h"
#import "SubscriptionModel.h"
#import "SubscriptionHistoryListCell.h"
#import "NetworkManager.h"
#import "MJRefresh.h"

@interface SubscriptionHistoryViewController ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray *items;
@end

@implementation SubscriptionHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"往期购买";
    
    UINib *nib = [UINib nibWithNibName:@"SubscriptionHistoryListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SubscriptionHistoryListCellID"];
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = 132.0f;
    
    [self testData];
}

- (void)testData {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (int i=1; i<10; i++) {
        SubscriptionModel *one = [[SubscriptionModel alloc] init];
        one.dateTime = @"2016.12.14 14:56";
        one.userName = @"甘女士";
        one.title = @"周刊订阅（12个月）";
        one.userEmail = @"714550975@qq.com";
        one.type = 1;
        [array addObject:one];
    }
    
    
    self.items = array;
    [self.tableView reloadData];
}

- (void)getSurveyWithPage:(NSInteger)pageA {
    __weak SubscriptionHistoryViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@Survey/lists?page=%ld",API_HOST,(long)pageA];
    [manager GET:url parameters:nil completion:^(id data, NSError *error){
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubscriptionHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubscriptionHistoryListCellID"];
    
    SubscriptionModel *model = self.items[indexPath.section];
    [cell setupSubscriptionModel:model];
    
    return cell;
}

@end
