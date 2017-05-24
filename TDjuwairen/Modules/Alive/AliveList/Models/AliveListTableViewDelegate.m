//
//  AliveListTableViewDelegate.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListTableViewDelegate.h"
#import "AliveListTableViewCell.h"
#import "AliveListBottomTableViewCell.h"
#import "AliveListModel.h"
#import "AliveRoomViewController.h"
#import "AliveDetailViewController.h"
#import "ShareHandler.h"
#import "NetworkManager.h"
#import "AliveCommentViewController.h"
#import "UIButton+LikeAnimation.h"
#import "AliveListCellData.h"
#import "AlivePublishViewController.h"
#import "AliveListSectionHeaderView.h"
#import "MBProgressHUD.h"
#import "SurveyDetailWebViewController.h"
#import "StockDetailViewController.h"

#define kAliveListCellToolHeight 37
#define kAliveListSectionHeaderHeight   30

@interface AliveListTableViewDelegate ()
<UITableViewDelegate, UITableViewDataSource,
AliveListTableCellDelegate, AliveListBottomTableCellDelegate,
AliveListSectionHeaderDelegate>

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) NSArray *itemList;

@end

@implementation AliveListTableViewDelegate
- (id)initWithTableView:(UITableView *)tableView withViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        tableView.delegate = self;
        tableView.dataSource = self;
        
        self.avatarPressedEnabled = YES;
        self.tableView = tableView;
        self.viewController = viewController;
        
        [self.tableView registerClass:[AliveListTableViewCell class] forCellReuseIdentifier:@"AliveListTableViewCellID"];
        
        UINib *nib1 = [UINib nibWithNibName:@"AliveListBottomTableViewCell" bundle:nil];
        [self.tableView registerNib:nib1 forCellReuseIdentifier:@"AliveListBottomTableViewCellID"];

    }
    
    return self;
}

- (void)insertAtHeaderWithArray:(NSArray *)array {
    NSMutableArray *cellArray = [NSMutableArray arrayWithCapacity:(array.count+self.itemList.count)];
    for (AliveListModel *model in array) {
        AliveListCellData *cellData = [[AliveListCellData alloc] initWithAliveModel:model];
        cellData.isShowDetail = NO;
        [cellData setup];
        [cellArray addObject:cellData];
    }
    
    [cellArray addObjectsFromArray:self.itemList];
    [self.tableView beginUpdates];
    self.itemList = cellArray;
    [self.tableView reloadData];
    [self.tableView endUpdates];
}

- (void)setupAliveListArray:(NSArray *)array {
    NSMutableArray *cellArray = [NSMutableArray arrayWithCapacity:array.count];
    for (AliveListModel *model in array) {
        AliveListCellData *cellData = [[AliveListCellData alloc] initWithAliveModel:model];
        cellData.isShowDetail = NO;
        [cellData setup];
        [cellArray addObject:cellData];
    }
    
    self.itemList = cellArray;
}

- (CGFloat)contentHeight {
    CGFloat height = 0;
    
    for (AliveListCellData *model in self.itemList) {
        if (self.isMyRoom) {
            height += (model.cellHeight + kAliveListCellToolHeight + kAliveListSectionHeaderHeight + 10);
        } else {
            height += (model.cellHeight + kAliveListCellToolHeight + 10);
        }
    }
    
    return height;
}

#pragma mark - AliveListTableCellDelegate

- (void)aliveListTableCell:(AliveListTableViewCell *)cell avatarPressed:(id)sender {
    if (!self.avatarPressedEnabled) {
        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        AliveListCellData *cellData = self.itemList[indexPath.section];
        
        AliveRoomViewController *vc = [[AliveRoomViewController alloc] initWithMasterId:cellData.aliveModel.masterId];
        vc.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

- (void)aliveListTableCell:(AliveListTableViewCell *)cell forwardAvatarPressed:(id)sender {
    if (!self.avatarPressedEnabled) {
        return;
    }
    
    AliveListCellData *cellData = cell.cellData;
    
    if (cellData.aliveModel.forwardModel.aliveType == kAliveHot ||
         cellData.aliveModel.forwardModel.aliveType == kAliveSurvey) {
        return;
    }
    
    AliveRoomViewController *vc = [[AliveRoomViewController alloc] initWithMasterId:cellData.aliveModel.forwardModel.masterId];
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)aliveListTableCell:(AliveListTableViewCell *)cell arrowPressed:(id)sender {
    AliveListCellData *cellData = cell.cellData;
    AliveListModel *listModel = cellData.aliveModel;
    /**
     
     10、用户本人点击【∨】从下向上弹出按钮【删除】和【取消】，点击【删除】删除动态，点击【取消】取消操作
     11、用户点击非本人动态的【∨】从下向上弹出按钮【关注（取消关注）】，点击【关注】关注该用户，点击【取消关注】取消关注
     */
    
    NSString *str = @"";
    if ([listModel.masterId isEqualToString:US.userId]) {
        // 是用户分人的动态
        str = @"删除";
        [self deleteDynamicWithAliveListModel:cellData andCellTag:cell.tag];
    }else {
    
// 判断用户是否关注过该主播
        str = @"关注";
        UIAlertController *alertVC = [[UIAlertController alloc] init];
        UIAlertAction *actionDone = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"AliveList-Models-AliveListTableViewDelegate.m");
        }];
        [alertVC addAction:actionDone];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:actionCancel];
        
        [self.viewController presentViewController:alertVC animated:YES completion:^{}];
    }
    
}


- (void)aliveListTableCell:(AliveListTableViewCell *)cell forwardMsgPressed:(id)sender {
    if (!self.avatarPressedEnabled) {
        return;
    }
    
    AliveListCellData *cellData = cell.cellData;
    AliveListForwardModel *model = cellData.aliveModel.forwardModel;

    
    if (model.aliveType == kAliveNormal ||
        model.aliveType == kAlivePosts) {
        AliveDetailViewController *vc = [[AliveDetailViewController alloc] init];
        vc.alive_ID = model.aliveId;
        vc.alive_type = (model.aliveType==1)?@"1":@"2";
        vc.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    } else if (model.aliveType == kAliveSurvey ||
               model.aliveType == kAliveHot) {
        if (model.isLocked) {
            StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
            vc.stockCode = model.stockCode;
            vc.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        } else {
            NSInteger tag = 0;
            if (model.aliveType == kAliveSurvey) {
                tag = 0;
            } else if(model.aliveType == kAliveSurvey) {
                tag = 3;
            }
            
            SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
            vc.contentId = model.aliveId;
            vc.stockCode = model.stockCode;
            vc.stockName = model.aliveTags.firstObject;
            vc.tag = tag;
            vc.url = model.forwardUrl;
            vc.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
    }
    
}


#pragma mark - AliveListBottomTableCellDelegate 

- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell sharePressed:(id)sender;
{
    
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.viewController.navigationController pushViewController:login animated:YES];
        return;
    }
    
    
    __weak AliveListTableViewDelegate *wself = self;
    
    void (^shareBlock)(BOOL state) = ^(BOOL state) {
        if (state) {
            [cell.shareBtn setTitle:[NSString stringWithFormat:@"%ld",(long)(cell.cellModel.shareNum+1)] forState:UIControlStateNormal];
        }
    };
    
    [ShareHandler shareWithTitle:SafeValue(cell.cellModel.aliveTitle) image:cell.cellModel.aliveImgs url:SafeValue(cell.cellModel.shareUrl) selectedBlock:^(NSInteger index){
        if (index == 0) {
            // 转发
            AlivePublishViewController *vc = [[AlivePublishViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.hidesBottomBarWhenPushed = YES;
            
            vc.publishType = kAlivePublishForward;
            vc.aliveListModel = cell.cellModel;
            vc.shareBlock = shareBlock;
            [wself.viewController.navigationController pushViewController:vc animated:YES];
        }
    } shareState:^(BOOL state) {
        if (state) {
            [cell.shareBtn setTitle:[NSString stringWithFormat:@"%ld",(long)(cell.cellModel.shareNum+1)] forState:UIControlStateNormal];
            NetworkManager *manager = [[NetworkManager alloc] init];
            NSDictionary *dict = @{@"item_id":SafeValue(cell.cellModel.aliveId),@"type" :@(cell.cellModel.aliveType)};
            
            [manager POST:API_AliveAddShare parameters:dict completion:^(id data, NSError *error) {
                
            }];
        }
    }];
}
- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell commentPressed:(id)sender;
{
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.viewController.navigationController pushViewController:login animated:YES];
        return;
    }
    
    AliveCommentViewController * commVc = [AliveCommentViewController new];
    commVc.alive_ID = SafeValue(cell.cellModel.aliveId);
    commVc.alive_type = [NSString stringWithFormat:@"%ld",(long)cell.cellModel.aliveType];
    commVc.hidesBottomBarWhenPushed = YES;
    
    commVc.commentBlock = ^(){
        [cell.commentBtn setTitle:[NSString stringWithFormat:@"%ld",(long)(cell.cellModel.commentNum+1)] forState:UIControlStateNormal];
    };
    [self.viewController.navigationController pushViewController:commVc animated:YES];
}

- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell likePressed:(id)sender;
{
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.viewController.navigationController pushViewController:login animated:YES];
        return;
    }
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{@"alive_id":cell.cellModel.aliveId,@"alive_type" :@(cell.cellModel.aliveType)};
    
    UIButton *btn = sender;
    if (btn.selected) {
        [manager POST:API_AliveCancelLike parameters:dict completion:^(id data, NSError *error) {
            
            if (!error) {
                cell.cellModel.likeNum--;
                [cell.likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)cell.cellModel.likeNum] forState:UIControlStateNormal];
                cell.likeBtn.selected = NO;
                [cell.likeBtn addLikeAnimation];
            }else{
                MBAlert(@"用户已取消点赞")
            }
        }];
    }else{
        [manager POST:API_AliveAddLike parameters:dict completion:^(id data, NSError *error) {
            
            if (!error) {
                cell.cellModel.likeNum++;
                [cell.likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)cell.cellModel.likeNum] forState:UIControlStateNormal];
                cell.likeBtn.selected = YES;
                [cell.likeBtn addLikeAnimation];
            }else{
                MBAlert(@"用户已点赞")
            }
        }];
    }
   
}

#pragma mark - AliveListSectionHeaderDelegate
- (void)alivelistSectionHeaderView:(AliveListSectionHeaderView *)headerView deletePressed:(id)sender {
    if (headerView.section > self.itemList.count) {
        return;
    }
        AliveListCellData *cellData = self.itemList[headerView.section];
    [self deleteDynamicWithAliveListModel:cellData andCellTag:headerView.section];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.itemList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AliveListCellData *cellData = self.itemList[indexPath.section];
        return cellData.cellHeight;
    } else {
        return kAliveListCellToolHeight;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AliveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveListTableViewCellID"];
        cell.tag = indexPath.section;
        cell.delegate = self;
        
        return cell;
    } else {
        AliveListBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveListBottomTableViewCellID"];
        cell.delegate = self;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    AliveListCellData *cellData = self.itemList[indexPath.section];
    AliveListModel *model = cellData.aliveModel;
    
    if (indexPath.row == 0) {
        AliveListTableViewCell *scell = (AliveListTableViewCell *)cell;
        [scell setupAliveListCellData:cellData];
    } else {
        AliveListBottomTableViewCell *scell = (AliveListBottomTableViewCell *)cell;
        [scell setupAliveModel:model];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AliveListCellData *cellData = self.itemList[indexPath.section];
    AliveListModel *model = cellData.aliveModel;
    
    if (model.aliveId.length <= 0) {
        return;
    }
    AliveDetailViewController *vc = [[AliveDetailViewController alloc] init];
    vc.alive_ID = model.aliveId;
    vc.alive_type = (model.aliveType==1)?@"1":@"2";
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isMyRoom) {
        return 30.0f;
    }
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isMyRoom) {
        AliveListSectionHeaderView *header = [[AliveListSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        header.delegate = self;
        header.section = section;
        return header;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}



#pragma mark - 删除动态
- (void)deleteDynamicWithAliveListModel:(AliveListCellData *)cellData andCellTag:(NSInteger)cellSection  {
    AliveListModel *aliveModel = cellData.aliveModel;
    
    NSDictionary *dict = @{@"alive_id": aliveModel.aliveId,@"alive_type" :@(aliveModel.aliveType)};
    
    __weak AliveListTableViewDelegate *wself = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除该条动态吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.viewController.navigationController.view animated:YES];
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        [manager POST:API_AliveDeleteRoomAlive parameters:dict completion:^(id data, NSError *error) {
            
            if (!error) {
                [hud hide:YES];
                
                NSMutableArray *array = [NSMutableArray arrayWithArray:wself.itemList];
                [array removeObject:cellData];
                
                wself.itemList = array;
                
                [self.tableView beginUpdates];
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:cellSection] withRowAnimation:UITableViewRowAnimationNone];
                
                if (wself.reloadView) {
                    wself.reloadView();
                }
                [self.tableView endUpdates];
            }else{
                hud.labelText = @"删除失败";
                [hud hide:YES afterDelay:0.7];
            }
        }];
    }];
    
    [alert addAction:done];
    [alert addAction:cancel];
    [self.viewController presentViewController:alert animated:YES completion:nil];

}


@end
