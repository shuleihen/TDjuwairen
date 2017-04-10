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
#import "AddAddressViewController.h"
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
    self.tableView.rowHeight = 132.0f;
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.guessListType == MyGuessIndividualListType) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshActions)];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
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
    NetworkManager *ma = [[NetworkManager alloc] init];
    
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
    
    
    __weak MyGuessViewController *wself = self;
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
                        MyGuessModel *model = [[MyGuessModel alloc] initWithIndividualDict:dict];
                        [guessList addObject:model];
                    }
                    
                  wself.items = [NSMutableArray arrayWithArray:guessList];
                
                    _currentPage++;
                    
                }else {
                    
                    for (NSDictionary *dict in array) {
                        MyGuessModel *model = [[MyGuessModel alloc] initWithDict:dict];
                        [guessList addObject:model];
                    }
                    wself.items = [NSMutableArray arrayWithArray:guessList];
                    
                }
                
                
            }
            
            if (self.guessListType == MyGuessIndividualListType) {
                [wself.tableView.mj_header endRefreshing];
                [wself.tableView.mj_footer endRefreshing];
            }
            [wself.tableView reloadData];
        }else {
        
            if (self.guessListType == MyGuessIndividualListType) {
                [wself.tableView.mj_header endRefreshing];
                [wself.tableView.mj_footer endRefreshing];
            }
            
        }
    }];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyGuessModel *guess = self.items[indexPath.section];
    
    AddAddressViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"AddAddressViewController"];
    vc.guessId = guess.guessId;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
