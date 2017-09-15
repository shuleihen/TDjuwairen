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
#import "AlivePublishViewController.h"
#import "ShareHandler.h"

@interface AliveDetailViewController ()
@property (nonatomic, strong) AliveListTableViewDelegate *tableViewDelegate;
@property (nonatomic, strong) AliveListModel *aliveModel;
@end

@implementation AliveDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableViewDelegate = [[AliveListTableViewDelegate alloc] initWithTableView:self.tableView withViewController:self];
    self.tableViewDelegate.isShowBottomView = NO;
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

- (void)sharePressed {
    AlivePublishModel *publishModel = [[AlivePublishModel alloc] init];
    publishModel.forwardId = self.aliveModel.aliveId;
    publishModel.forwardType = self.aliveModel.aliveType;
    publishModel.image = self.aliveModel.aliveImgs.firstObject;
    publishModel.detail = self.aliveModel.aliveTitle;
    publishModel.masterNickName = self.aliveModel.masterNickName;
    
    NSString *type = @"话题";
    if (self.aliveType == kAlivePosts) {
        type = @"推单";
    }
    
    NSString *shareTitle = [NSString stringWithFormat:@"%@的%@",self.aliveModel.masterNickName,type];
    
    NSString *shareDetail = self.aliveModel.aliveTitle;
    
    AlivePublishType publishType = kAlivePublishViewpoint;
    
    
    __weak typeof(self)weakSelf = self;
    
    void (^shareBlock)(BOOL state) = ^(BOOL state) {
        if (state) {
            // 转发服务器会将分享数加1
            [[NSNotificationCenter defaultCenter] postNotificationName:kAddLikeNotification object:nil userInfo:@{@"notiType":@"fenxiang"}];
        }
    };
    
    [ShareHandler shareWithTitle:shareTitle
                          detail:shareDetail
                           image:self.aliveModel.aliveImgs.firstObject
                             url:self.aliveModel.shareUrl
                   selectedBlock:^(NSInteger index){
        if (index == 0) {
            // 转发
            AlivePublishViewController *vc = [[AlivePublishViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.hidesBottomBarWhenPushed = YES;
            
            vc.publishType = publishType;
            vc.publishModel = publishModel;
            vc.shareBlock = shareBlock;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }  shareState:^(BOOL state) {
        if (state) {
            NetworkManager *manager = [[NetworkManager alloc] init];
            NSDictionary *dict = @{@"item_id":weakSelf.aliveID,@"type":@(weakSelf.aliveType)};
            
            [manager POST:API_AliveAddShare parameters:dict completion:^(id data, NSError *error) {
                if (!error) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kAddLikeNotification object:nil userInfo:@{@"notiType":@"fenxiang"}];
                }
            }];
        }
    }];
}
@end
