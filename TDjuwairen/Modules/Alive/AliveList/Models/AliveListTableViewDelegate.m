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
#import "MBProgressHUD.h"
#import "SurveyDetailWebViewController.h"
#import "StockDetailViewController.h"
#import "DetailPageViewController.h"
#import "ACActionSheet.h"
#import "AliveVideoListTableViewCell.h"
#import "StockUnlockManager.h"

#define kAliveListCellToolHeight 37
#define kAliveListSectionHeaderHeight   30

@interface AliveListTableViewDelegate ()
<UITableViewDelegate, UITableViewDataSource,
AliveListTableCellDelegate, AliveListBottomTableCellDelegate, StockUnlockManagerDelegate>
@property (nonatomic, strong) StockUnlockManager *unlockManager;
@end

@implementation AliveListTableViewDelegate
- (id)initWithTableView:(UITableView *)tableView withViewController:(UIViewController *)viewController {
    if (self = [super initWithTableView:tableView withViewController:viewController]) {
        tableView.delegate = self;
        tableView.dataSource = self;
        
        self.avatarPressedEnabled = YES;
        
        [self.tableView registerClass:[AliveListTableViewCell class] forCellReuseIdentifier:@"AliveListTableViewCellID"];
        
        UINib *nib1 = [UINib nibWithNibName:@"AliveListBottomTableViewCell" bundle:nil];
        [self.tableView registerNib:nib1 forCellReuseIdentifier:@"AliveListBottomTableViewCellID"];
        
        UINib *nib = [UINib nibWithNibName:@"AliveVideoListTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"AliveVideoListTableViewCellID"];
        
        self.unlockManager = [[StockUnlockManager alloc] init];
        self.unlockManager.delegate = self;

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


#pragma mark - StockUnlockManagerDelegate
- (void)unlockManager:(StockUnlockManager *)manager withStockCode:(NSString *)stockCode {
    for (AliveListCellData *model in self.itemList) {
        if ([model.aliveModel.extra.companyCode isEqualToString:stockCode]) {
            model.aliveModel.extra.isUnlock = YES;
        }
    }
    
    [self.tableView reloadData];
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
    
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.viewController.navigationController pushViewController:login animated:YES];
        return;
    }
    
    AliveListCellData *cellData = cell.cellData;
    AliveListModel *listModel = cellData.aliveModel;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (listModel.isSelf == YES) {
        ACActionSheet *sheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil actionSheetBlock:^(NSInteger index){
            if (index == 0) {
                [self deleteDynamicWithAliveListModel:cellData withIndexPath:indexPath];
            }
        }];
        [sheet show];
        
    }else if (listModel.isAttend == YES) {
        ACActionSheet *sheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消关注" otherButtonTitles:nil actionSheetBlock:^(NSInteger index){
            if (index == 0) {
                [self attenOrCancelWithAliveListModel:cellData withIndexPath:indexPath];
            }
        }];
        [sheet show];
        
    }else if (listModel.isAttend == NO){
        ACActionSheet *sheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"添加关注" otherButtonTitles:nil actionSheetBlock:^(NSInteger index){
            if (index == 0) {
                [self attenOrCancelWithAliveListModel:cellData withIndexPath:indexPath];
            }
        }];
        [sheet show];
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
    UIButton *btn = sender;
    NSDictionary *dict = @{@"alive_id":cell.cellModel.aliveId,@"alive_type" :@(cell.cellModel.aliveType)};
    
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.itemList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AliveListCellData *cellData = self.itemList[section];
    AliveListModel *model = cellData.aliveModel;
    if (model.aliveType == kAliveSurvey ||
        model.aliveType == kAliveHot ||
        model.aliveType == kAliveVideo) {
        return 1;
    }
    
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
    
    AliveListCellData *cellData = self.itemList[indexPath.section];
    AliveListModel *model = cellData.aliveModel;
    
    if (indexPath.row == 0) {
        if (model.aliveType == kAliveSurvey ||
            model.aliveType == kAliveHot ||
            model.aliveType == kAliveVideo) {
            AliveVideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveVideoListTableViewCellID"];
            
            return cell;
        } else {
            AliveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveListTableViewCellID"];
            cell.tag = indexPath.section;
            cell.delegate = self;
            
            return cell;
        }
        
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
        if (model.aliveType == kAliveSurvey ||
            model.aliveType == kAliveHot ||
            model.aliveType == kAliveVideo) {
            AliveVideoListTableViewCell *scell = (AliveVideoListTableViewCell *)cell;
            [scell setupAliveModel:model];
        } else {
            AliveListTableViewCell *scell = (AliveListTableViewCell *)cell;
            [scell setupAliveListCellData:cellData];
        }
        
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
    
    if (model.aliveType == kAliveViewpoint) {
        // 观点
        DetailPageViewController *detail = [[DetailPageViewController alloc]init];
        detail.view_id = model.aliveId;
        detail.pageMode = @"view";
        [detail setHidesBottomBarWhenPushed:YES];
        [self.viewController.navigationController pushViewController:detail animated:YES];
    } else if (model.aliveType == kAliveSurvey ||
               model.aliveType == kAliveHot ||
               model.aliveType == kAliveVideo) {
        if (model.extra.isUnlock) {
            
//            DetailPageViewController *vc = [[DetailPageViewController alloc] init];
//            vc.sharp_id = model.aliveId;
//            vc.pageMode = @"sharp";
//            [self.viewController.navigationController pushViewController:vc animated:YES];
        } else {
            if (!US.isLogIn) {
                LoginViewController *login = [[LoginViewController alloc] init];
                login.hidesBottomBarWhenPushed = YES;
                [self.viewController.navigationController pushViewController:login animated:YES];
                return;
            }
            
            [self.unlockManager unlockStock:model.extra.companyCode withStockName:model.extra.companyName withController:self.viewController];
        }
    } else {
        AliveDetailViewController *vc = [[AliveDetailViewController alloc] init];
        vc.alive_ID = model.aliveId;
        vc.alive_type = (model.aliveType==1)?@"1":@"2";
        vc.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}



#pragma mark - Action

- (void)deleteDynamicWithAliveListModel:(AliveListCellData *)cellData withIndexPath:(NSIndexPath *)indexPath {
    AliveListModel *aliveModel = cellData.aliveModel;
    
    NSDictionary *dict = @{@"alive_id": aliveModel.aliveId,@"alive_type" :@(aliveModel.aliveType)};
    
    __weak AliveListTableViewDelegate *wself = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.viewController.navigationController.view animated:YES];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_AliveDeleteRoomAlive parameters:dict completion:^(id data, NSError *error) {
        
        if (!error) {
            [hud hide:YES];
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:wself.itemList];
            [array removeObject:cellData];
            
            wself.itemList = array;
            
            [wself.tableView beginUpdates];
            if (indexPath) {
                [wself.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            
            if (wself.reloadView) {
                wself.reloadView();
            }
            [wself.tableView endUpdates];
        }else{
            hud.labelText = @"删除失败";
            [hud hide:YES afterDelay:0.7];
        }
    }];
}


- (void)attenOrCancelWithAliveListModel:(AliveListCellData *)cellData withIndexPath:(NSIndexPath *)indexPath {
    
    NSString *str = @"";
    NSString *errorStr = @"";
    NSString *notiStr = @"";
    AliveListModel *listModel = cellData.aliveModel;
    
    if (!listModel.isAttend) {
        str = API_AliveAddAttention;
        errorStr = @"添加关注失败";
        notiStr = @"1";
    }else {
        str = API_AliveDelAttention;
        errorStr = @"取消关注失败";
        notiStr = @"0";
    }
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewController.navigationController.view animated:YES];
    
    [manager POST:str parameters:@{@"user_id":listModel.masterId} completion:^(id data, NSError *error){
        
        if (!error) {
            [hud hide:YES];
            if (data && [data[@"status"] integerValue] == 1) {
                
                if (self.listType == kAliveListRecommend || self.listType == kAliveListViewpoint) {
                    /// 推荐列表 观点列表
                    
                    for (AliveListCellData *tempCellData in self.itemList) {
                        AliveListModel *tempModel= tempCellData.aliveModel;
                        if ([tempModel.masterId isEqualToString:listModel.masterId]) {
                            tempModel.isAttend = !tempModel.isAttend;
                        }
                    }
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:KnotifierGoAddAttend object:nil userInfo:@{@"masterID":listModel.masterId,@"listType":@(self.listType),@"addAttend":notiStr}];
                
                [self.tableView reloadData];
                if (self.reloadView) {
                    self.reloadView();
                }
            }
        } else {
            hud.labelText = errorStr;
            [hud hide:YES afterDelay:0.7];
        }
        
    }];
    
}



@end
