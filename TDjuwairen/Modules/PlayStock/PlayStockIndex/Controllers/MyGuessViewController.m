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
#import "IndexStockRecordModel.h"
#import "MyGuessCell.h"
#import "AddAddressViewController.h"
#import "IndividualStockRecordModel.h"
#import "MJRefresh.h"

@interface MyGuessViewController ()
@property (strong, nonatomic) NSMutableArray *items;
@property (assign, nonatomic) NSInteger currentPage;
@end

@implementation MyGuessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的竞猜";
    UINib *nib = [UINib nibWithNibName:@"MyGuessCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MyGuessCellID"];
    
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.guessListType == MyGuessIndividualListType) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshActions)];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
        
        self.tableView.rowHeight = 155.0f;
    } else {
        self.tableView.rowHeight = 132.0f;
    }
    
    self.currentPage = 1;
    [self queryMyGuess];
}


- (void)refreshActions {
    self.currentPage = 1;
    [self queryMyGuess];
}


- (void)loadMoreActions {
    [self queryMyGuess];
    
}


- (void)queryMyGuess {
    
    __weak MyGuessViewController *wself = self;
    
    NSDictionary *dict = @{};
    NSString *urlStr = API_GameMyGuess;
    
    if (self.guessListType == MyGuessIndividualListType) {
        urlStr = API_GameMyIndividualGuess;
        dict = @{@"page":@(self.currentPage)};
    }else {
        if (US.isLogIn) {
            NSAssert(US.userId, @"用户Id不能为空");
            dict = @{@"user_id": US.userId};
        }
    }
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:urlStr parameters:dict completion:^(id data, NSError *error){
        if (!error) {
            
            NSArray *array = data;
            if ([array count]) {
                NSMutableArray *guessList = [NSMutableArray arrayWithCapacity:[array count]];
            
                if (self.guessListType == MyGuessIndividualListType) {
                    if (_currentPage == 1) {
                        if ([wself.items respondsToSelector:@selector(removeAllObjects)]) {
                            [wself.items removeAllObjects];
                        }
                        guessList = [NSMutableArray arrayWithCapacity:[array count]];
                    } else {
                        guessList = [NSMutableArray arrayWithArray:wself.items];
                    }
                    
                    for (NSDictionary *dict in array) {
                        IndividualStockRecordModel *model = [[IndividualStockRecordModel alloc] initWithDictionary:dict];
                        [guessList addObject:model];
                    }
                    
                  wself.items = [NSMutableArray arrayWithArray:guessList];
                
                  wself.currentPage++;
                    
                } else {
                    for (NSDictionary *dict in array) {
                        IndexStockRecordModel *model = [[IndexStockRecordModel alloc] initWithDict:dict];
                        [guessList addObject:model];
                    }
                    wself.items = [NSMutableArray arrayWithArray:guessList];
                }
            }
            
            if (self.guessListType == MyGuessIndividualListType) {
                [wself.tableView.mj_header endRefreshing];
                
                if (array.count != 20) {
                    [wself.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [wself.tableView.mj_footer endRefreshing];
                }
            }
            
        }else {
        
            if (self.guessListType == MyGuessIndividualListType) {
                [wself.tableView.mj_header endRefreshing];
                [wself.tableView.mj_footer endRefreshing];
            }
            
        }
        
        [wself.tableView reloadData];
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
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyGuessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyGuessCellID"];
    
    if (self.guessListType == MyGuessIndexListType) {
        IndexStockRecordModel *guess = self.items[indexPath.section];
        [cell setupIndexGuessModel:guess];
    } else {
        IndividualStockRecordModel *guess = self.items[indexPath.section];
        [cell setupIndividualGuessModel:guess];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
     领取奖励功能屏蔽掉
    IndexStockRecordModel *guess = self.items[indexPath.section];
    
    AddAddressViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"AddAddressViewController"];
    vc.guessId = guess.guessId;
    [self.navigationController pushViewController:vc animated:YES];
     */
}
@end
