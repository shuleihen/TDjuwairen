//
//  MyGuessViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MyGuessViewController.h"
#import "HexColors.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "MyGuessModel.h"
#import "MyGuessCell.h"

@interface MyGuessViewController ()
@property (copy, nonatomic) NSArray *items;
@end

@implementation MyGuessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UINib *nib = [UINib nibWithNibName:@"MyGuessCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MyGuessCellID"];
    self.tableView.rowHeight = 132.0f;
    self.tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#eeeeee"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = @"我的竞猜";
    [self queryMyGuess];
}

- (void)queryMyGuess {
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{};
    if (US.isLogIn) {
        NSAssert(US.userId, @"用户Id不能为空");
        dict = @{@"user_id": US.userId};
    }
    
    __weak MyGuessViewController *wself = self;
    [ma GET:API_GameMyGuess parameters:dict completion:^(id data, NSError *error){
        if (!error) {
 
            NSArray *array = data;
            if ([array count]) {
                NSMutableArray *guessList = [NSMutableArray arrayWithCapacity:[array count]];
                
                for (NSDictionary *dict in array) {
                    MyGuessModel *model = [[MyGuessModel alloc] initWithDict:dict];
                    [guessList addObject:model];
                }
                wself.items = guessList;
            }
            
            [wself.tableView reloadData];
        }
    }];

    /*
    MyGuessModel *one = [[MyGuessModel alloc] init];
    one.stockName = @"上证指数";
    one.season = 1;
    one.seasonString = @"上午场";
    one.buyPri = 3853.23;
    one.buyKeyNum = 6;
    one.status = 0;
    one.statusString = @"待开奖";
    one.addTime = @"2016.12.14 14:56";
    
    MyGuessModel *two = [[MyGuessModel alloc] init];
    two.stockName = @"上证指数";
    two.season = 1;
    two.seasonString = @"上午场";
    two.buyPri = 3853.23;
    two.endPri = 3855.21;
    two.isClosed = 1;
    two.buyKeyNum = 3;
    two.status = 2;
    two.statusString = @"获10把钥匙";
    two.addTime = @"2016.12.14 14:56";
    self.items = @[one,two];
    */
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyGuessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyGuessCellID"];
    
    MyGuessModel *guess = self.items[indexPath.section];
    [cell setupGuessInfo:guess];
    
    return cell;
}

@end
