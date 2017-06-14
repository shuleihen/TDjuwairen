//
//  AliveDetailViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveDetailViewController.h"
#import "AliveListTableViewDelegate.h"
#import "NetworkManager.h"
#import "UIViewController+Loading.h"
#import "AliveListModel.h"
#import "AliveDetailFooterViewController.h"

@interface AliveDetailViewController ()
@property (nonatomic, strong) AliveListTableViewDelegate *tableViewDelegate;
@property (nonatomic, strong) AliveListModel *aliveModel;
@end

@implementation AliveDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableViewDelegate = [[AliveListTableViewDelegate alloc] initWithTableView:self.tableView withViewController:self];
    self.tableViewDelegate.isShowToolBar = NO;
    self.tableViewDelegate.isAliveDetail = YES;
    
    [self loadAliveDetail];
}

- (void)loadAliveDetail {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(kScreenWidth/2, (kScreenHeight-64)/2);
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *dict = @{@"alive_id":self.aliveID,@"alive_type" : @(self.aliveType)};
    [ma GET:API_AliveGetAliveInfo parameters:dict completion:^(id data, NSError *error){
        
        [indicator stopAnimating];
        
        if (!error) {
            AliveListModel *model = [[AliveListModel alloc] initWithDictionary:data];
            [self reloadViewWithAliveModel:model];
        } else {
            
        }
    }];
}

- (void)reloadViewWithAliveModel:(AliveListModel *)model {
    self.aliveModel = model;

    TDShareModel *shareModel = [[TDShareModel alloc] init];
    shareModel.title = model.aliveTitle;
    shareModel.images = model.aliveImgs;
    shareModel.url = model.shareUrl;
    self.shareModel = shareModel;
    
    self.masterID = model.masterId;
    
    [self loadTabelView];
    
    [self.tableViewDelegate setupAliveListArray:@[model]];
    
    [self setupIsLike:model.isLike withAnimation:NO];
}

- (AliveListModel *)shareAliveListModel {
    return self.aliveModel;
}
@end
