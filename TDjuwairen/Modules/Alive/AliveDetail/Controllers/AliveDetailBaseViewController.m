//
//  AliveDetailBaseViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveDetailBaseViewController.h"
#import "AliveListBottomTableViewCell.h"
#import "ShareHandler.h"
#import "NetworkManager.h"
#import "UIButton+LikeAnimation.h"
#import "AlivePublishViewController.h"
#import "AliveCommentViewController.h"
#import "AliveDetailFooterViewController.h"

@interface AliveDetailBaseViewController ()<AliveListBottomTableCellDelegate>
@property (nonatomic, strong) AliveListBottomTableViewCell *toolView;
@property (nonatomic, strong) AliveDetailFooterViewController *footerViewController;
@end

@implementation AliveDetailBaseViewController
@synthesize footerViewController = _footerViewController;

- (id)initWithAliveId:(NSString *)aliveId aliveType:(AliveType)aliveType {
    if (self = [super init]) {
        self.aliveID = aliveId;
        self.aliveType = aliveType;
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    
    return _tableView;
}

- (AliveListBottomTableViewCell *)toolView {
    if (!_toolView) {
        _toolView = [[[NSBundle mainBundle] loadNibNamed:@"AliveListBottomTableViewCell" owner:self options:nil] firstObject];
        _toolView.frame = CGRectMake(0, kScreenHeight-64-44, kScreenWidth, 44);
        [_toolView setupForDetail];
        _toolView.delegate = self;
    }
    return _toolView;
}

- (void)setFooterViewController:(AliveDetailFooterViewController *)footerViewController {
    if (_footerViewController && _footerViewController != footerViewController) {
        [_footerViewController removeFromParentViewController];
    }
    
    [self addChildViewController:footerViewController];
    _footerViewController = footerViewController;
}

- (AliveDetailFooterViewController *)footerViewController {
    if (!_footerViewController) {
        _footerViewController = [[AliveDetailFooterViewController alloc] init];
        _footerViewController.masterId = self.masterID;
        _footerViewController.aliveID = self.aliveID;
        _footerViewController.aliveType = self.aliveType;
        
        
    }
    return _footerViewController;
}

- (void)setupIsLike:(BOOL)isLike withAnimation:(BOOL)animation {
    
    self.toolView.likeBtn.selected = isLike;
    
    if (animation) {
        [self.toolView.likeBtn addLikeAnimation];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TDViewBackgrouondColor;
    self.title = @"直播正文";
}

- (void)loadTabelView {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolView];
    
    [self addChildViewController:self.footerViewController];
    
    self.tableView.tableFooterView = self.footerViewController.view;
}

- (AliveListModel *)shareAliveListModel {
    return nil;
}

#pragma mark - AliveListBottomTableCellDelegate

- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell sharePressed:(id)sender {
    
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    
    AliveListModel *aliveModel = [self shareAliveListModel];
    if (!aliveModel) {
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    
    void (^shareBlock)(BOOL state) = ^(BOOL state) {
        if (state) {
            // 转发服务器会将分享数加1
            [[NSNotificationCenter defaultCenter] postNotificationName:KnotifierGoAddLike object:nil userInfo:@{@"notiType":@"fenxiang"}];
        }
    };
    
     [ShareHandler shareWithTitle:aliveModel.aliveTitle image:aliveModel.aliveImgs url:aliveModel.shareUrl selectedBlock:^(NSInteger index){
         if (index == 0) {
             // 转发
             AlivePublishViewController *vc = [[AlivePublishViewController alloc] initWithStyle:UITableViewStyleGrouped];
             vc.hidesBottomBarWhenPushed = YES;
             
             vc.publishType = kAlivePublishForward;
             vc.aliveListModel = aliveModel;
             vc.shareBlock = shareBlock;
             [weakSelf.navigationController pushViewController:vc animated:YES];
         }
     }  shareState:^(BOOL state) {
         if (state) {
             NetworkManager *manager = [[NetworkManager alloc] init];
             NSDictionary *dict = @{@"item_id":weakSelf.aliveID,@"type":@(weakSelf.aliveType)};
             
             [manager POST:API_AliveAddShare parameters:dict completion:^(id data, NSError *error) {
             if (!error) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:KnotifierGoAddLike object:nil userInfo:@{@"notiType":@"fenxiang"}];
             }
         }];
         }
     }];
}

- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell commentPressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    AliveCommentViewController *commVC = [AliveCommentViewController new];
    commVC.alive_ID = self.aliveID;
    commVC.alive_type = [NSString stringWithFormat:@"%d",(int)self.aliveType];
    [self.navigationController pushViewController:commVC animated:YES];
    
}

- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell likePressed:(id)sender {
    
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dict = @{@"alive_id":self.aliveID,@"alive_type":@(self.aliveType)};
    __weak typeof(self)wself = self;
    
    if (cell.likeBtn.selected) {
        [manager POST:API_AliveCancelLike parameters:dict completion:^(id data, NSError *error) {
            
            if (!error) {
                [wself setupIsLike:NO withAnimation:YES];

                [[NSNotificationCenter defaultCenter] postNotificationName:KnotifierGoAddLike object:nil userInfo:@{@"notiType":@"dianzan"}];
            }else{
                MBAlert(@"用户已取消点赞")
            }
        }];
    }else{
        
        [manager POST:API_AliveAddLike parameters:dict completion:^(id data, NSError *error) {
            
            if (!error) {
                [wself setupIsLike:YES withAnimation:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:KnotifierGoAddLike object:nil userInfo:@{@"notiType":@"dianzan"}];
            }else{
                MBAlert(@"用户已点赞")
            }
            
        }];
    }
}


@end
