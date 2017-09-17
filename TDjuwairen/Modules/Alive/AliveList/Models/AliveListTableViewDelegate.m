//
//  AliveListTableViewDelegate.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListTableViewDelegate.h"
#import "AliveListTableViewCell.h"
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
#import "ACActionSheet.h"
#import "AliveVideoListTableViewCell.h"
#import "StockUnlockManager.h"
#import "ViewpointDetailViewController.h"
#import "VideoDetailViewController.h"
#import "AliveListAdTableViewCell.h"
#import "AliveListHotTableViewCell.h"
#import "TDWebViewHandler.h"
#import "PlayStockDetailViewController.h"
#import "UIViewController+Login.h"
#import "StockPoolListViewController.h"


@interface AliveListTableViewDelegate ()
<UITableViewDelegate, UITableViewDataSource,
AliveListTableCellDelegate, StockUnlockManagerDelegate>
@property (nonatomic, strong) StockUnlockManager *unlockManager;
@end

@implementation AliveListTableViewDelegate
- (id)initWithTableView:(UITableView *)tableView withViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.tableView = tableView;
        self.viewController = viewController;
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.avatarPressedEnabled = YES;
        
        [self.tableView registerClass:[AliveListTableViewCell class] forCellReuseIdentifier:@"AliveListTableViewCellID"];
        
        UINib *nib = [UINib nibWithNibName:@"AliveVideoListTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"AliveVideoListTableViewCellID"];
        UINib *nib2 = [UINib nibWithNibName:@"AliveListAdTableViewCell" bundle:nil];
        [self.tableView registerNib:nib2 forCellReuseIdentifier:@"AliveListAdTableViewCellID"];
        UINib *nib3 = [UINib nibWithNibName:@"AliveListHotTableViewCell" bundle:nil];
        [self.tableView registerNib:nib3 forCellReuseIdentifier:@"AliveListHotTableViewCellID"];
        
        self.unlockManager = [[StockUnlockManager alloc] init];
        self.unlockManager.delegate = self;

        self.canEdit = NO;
        self.isShowBottomView = YES;
        self.isAliveDetail = NO;
    }
    
    return self;
}


- (void)setupAliveListArray:(NSArray *)array {
    NSMutableArray *cellArray = [NSMutableArray arrayWithCapacity:array.count];
    for (AliveListModel *model in array) {
        AliveListCellData *cellData = [AliveListCellData cellDataWithAliveModel:model];
        
        if (cellData) {
            cellData.isShowDetailMessage = self.isAliveDetail;
            cellData.isShowBottomView = self.isShowBottomView;
            [cellData setup];
            [cellArray addObject:cellData];
        }
    }
    
    self.itemList = cellArray;
}

- (CGFloat)contentHeight {
    CGFloat height = 0;
    
    for (AliveListCellData *model in self.itemList) {
        height += (model.cellHeight + 10);
    }
    
    return height;
}


#pragma mark - StockUnlockManagerDelegate
- (void)unlockManager:(StockUnlockManager *)manager withSurveyId:(NSString *)surveyId {
    for (AliveListCellData *model in self.itemList) {
        if ([model.aliveModel.aliveId isEqualToString:surveyId] &&
            [model.aliveModel.extra isKindOfClass:[AliveListExtra class]]) {
            AliveListExtra *extra = model.aliveModel.extra;
            extra.isUnlock = YES;
            break;
        }
    }
    
    [self.tableView reloadData];
}

- (void)unlockManager:(StockUnlockManager *)manager withDeepId:(NSString *)deepId {
    for (AliveListCellData *model in self.itemList) {
        if ([model.aliveModel.extra isKindOfClass:[AliveListExtra class]]) {
            AliveListExtra *extra = model.aliveModel.extra;
            if ([deepId isEqualToString:model.aliveModel.aliveId]) {
                extra.isUnlock = YES;
                break;
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - AliveListTableCellDelegate
- (void)aliveListTableCell:(AliveListTableViewCell *)cell userPressedWithUserId:(NSString *)userId {
    if (!self.avatarPressedEnabled) {
        return;
    }
    
    AliveRoomViewController *vc = [[AliveRoomViewController alloc] initWithMasterId:userId];
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
        
    } else if (listModel.isAttend == YES) {
        ACActionSheet *sheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消关注" otherButtonTitles:nil actionSheetBlock:^(NSInteger index){
            if (index == 0) {
                [self attenOrCancelWithAliveListModel:cellData withIndexPath:indexPath];
            }
        }];
        [sheet show];
        
    } else if (listModel.isAttend == NO){
        ACActionSheet *sheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"添加关注" otherButtonTitles:nil actionSheetBlock:^(NSInteger index){
            if (index == 0) {
                [self attenOrCancelWithAliveListModel:cellData withIndexPath:indexPath];
            }
        }];
        [sheet show];
    }
    
}


- (void)aliveListTableCell:(AliveListTableViewCell *)cell forwardMsgPressed:(id)sender {

    AliveListModel *model = cell.cellData.aliveModel.forwardModel.forwardList.lastObject;
    [self didSelectedWithAliveModel:model withUnlock:NO];
}

- (void)aliveListTableCell:(AliveListTableViewCell *)cell sharePressed:(id)sender {
    
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.viewController.navigationController pushViewController:login animated:YES];
        return;
    }
    
    __weak AliveListTableViewDelegate *wself = self;
    UIButton *shareBtn = (UIButton *)sender;
    AliveListModel *cellModel = cell.cellData.aliveModel;
    
    void (^shareBlock)(BOOL state) = ^(BOOL state) {
        if (state) {
            [shareBtn setTitle:[NSString stringWithFormat:@"%ld",(long)(cellModel.shareNum+1)] forState:UIControlStateNormal];
        }
    };
    
    AlivePublishModel *publishModel = [[AlivePublishModel alloc] init];
    publishModel.forwardId = cellModel.aliveId;
    publishModel.forwardType = cellModel.aliveType;
    publishModel.image = cellModel.aliveImgs.firstObject;
    publishModel.title = [NSString stringWithFormat:@"@%@", cellModel.masterNickName];
    publishModel.masterNickName = cellModel.masterNickName;
    publishModel.detail = cellModel.aliveTitle;
    
    AlivePublishType publishType = kAlivePublishForward;
    
    NSString *shareTitle = [NSString stringWithFormat:@"%@的转发", cellModel.masterNickName];
    NSString *shareDetail = cellModel.aliveTitle;
    
    [ShareHandler shareWithTitle:shareTitle detail:shareDetail images:cellModel.aliveImgs url:SafeValue(cellModel.shareUrl) selectedBlock:^(NSInteger index){
        if (index == 0) {
            // 转发
            AlivePublishViewController *vc = [[AlivePublishViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.hidesBottomBarWhenPushed = YES;
            
            vc.publishType = publishType;
            vc.publishModel = publishModel;
            vc.shareBlock = shareBlock;
            [wself.viewController.navigationController pushViewController:vc animated:YES];
        }
    } shareState:^(BOOL state) {
        if (state) {
            [shareBtn setTitle:[NSString stringWithFormat:@"%ld",(long)(cellModel.shareNum+1)] forState:UIControlStateNormal];
            NetworkManager *manager = [[NetworkManager alloc] init];
            NSDictionary *dict = @{@"item_id":SafeValue(cellModel.aliveId),@"type" :@(cellModel.aliveType)};
            
            [manager POST:API_AliveAddShare parameters:dict completion:^(id data, NSError *error) {
                
            }];
        }
    }];
}

- (void)aliveListTableCell:(AliveListTableViewCell *)cell commentPressed:(id)sender;
{
    if (!US.isLogIn) {
        [self.viewController pushLoginViewController];
        return;
    }
    
    UIButton *commentBtn = (UIButton *)sender;
    AliveListModel *cellModel = cell.cellData.aliveModel;
    
    AliveCommentViewController * commVc = [AliveCommentViewController new];
    commVc.alive_ID = SafeValue(cellModel.aliveId);
    commVc.alive_type = [NSString stringWithFormat:@"%ld",(long)cellModel.aliveType];
    commVc.hidesBottomBarWhenPushed = YES;
    
    commVc.commentBlock = ^(){
        [commentBtn setTitle:[NSString stringWithFormat:@"%ld",(long)(cellModel.commentNum+1)] forState:UIControlStateNormal];
    };
    [self.viewController.navigationController pushViewController:commVc animated:YES];
}

- (void)aliveListTableCell:(AliveListTableViewCell *)cell likePressed:(id)sender;
{
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.viewController.navigationController pushViewController:login animated:YES];
        return;
    }
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    UIButton *likeBtn = sender;
    AliveListModel *cellModel = cell.cellData.aliveModel;
    NSDictionary *dict = @{@"alive_id":cellModel.aliveId,@"alive_type" :@(cellModel.aliveType)};
    
    if (likeBtn.selected) {
        
        [manager POST:API_AliveCancelLike parameters:dict completion:^(id data, NSError *error) {
            
            if (!error) {
                cellModel.likeNum--;
                [likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)cellModel.likeNum] forState:UIControlStateNormal];
                likeBtn.selected = NO;
                [likeBtn addLikeAnimation];
            }else{
                MBAlert(@"用户已取消点赞")
            }
        }];
    }else{
        
        [manager POST:API_AliveAddLike parameters:dict completion:^(id data, NSError *error) {
            
            if (!error) {
                cellModel.likeNum++;
                [likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)cellModel.likeNum] forState:UIControlStateNormal];
                likeBtn.selected = YES;
                [likeBtn addLikeAnimation];
            }else{
                MBAlert(@"用户已点赞")
            }
        }];
    }
   
}

- (void)aliveListTableCell:(AliveListTableViewCell *)cell stockPressedWithStockCode:(NSString *)stockCode {
    
    StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
    vc.stockCode = stockCode;
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)aliveListTableCell:(AliveListTableViewCell *)cell playStockPressed:(id)sender {
    AliveListModel *cellModel = cell.cellData.aliveModel;
    AliveListPlayStockExtra *extra = cellModel.extra;
    
    PlayStockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayStockDetailViewController"];
    vc.guessId = extra.guessId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)aliveListTableCellIndexPath:(NSIndexPath *)indexPath closePressed:(id)sender {
    [self deleteADWithIndexPath:indexPath];
}

- (void)aliveListTableCell:(AliveListTableViewCell *)cell stockPoolPressed:(id)sender {
    AliveListModel *cellModel = cell.cellData.aliveModel;
    AliveListStockPoolExtra *extra = cellModel.extra;
    
    StockPoolListViewController *vc = [[StockPoolListViewController alloc] init];
    vc.userId = extra.stockPoolId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)aliveListTableCell:(AliveListTableViewCell *)cell stockPoolDetailPressed:(id)sender {
    
}
#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.itemList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AliveListCellData *cellData = self.itemList[indexPath.section];
    AliveListModel *model = cellData.aliveModel;
    
    if (model.aliveType == kAliveSurvey ||
        model.aliveType == kAliveDeep ||
        model.aliveType == kAliveVideo) {
        AliveVideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveVideoListTableViewCellID"];
        
        return cell;
    } else if (model.aliveType == kAliveAd) {
        // 广告
        AliveListAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveListAdTableViewCellID"];
        cell.delegate = self;
        cell.indexPath = indexPath;
        
        return cell;
    } else if (model.aliveType == kAliveHot) {
        // 热点
        AliveListHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveListHotTableViewCellID"];
        
        return cell;
    } else {
        AliveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveListTableViewCellID"];
        cell.tag = indexPath.section;
        cell.delegate = self;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    AliveListCellData *cellData = self.itemList[indexPath.section];
    AliveListModel *model = cellData.aliveModel;
    
    if (model.aliveType == kAliveSurvey ||
        model.aliveType == kAliveDeep ||
        model.aliveType == kAliveVideo) {
        AliveVideoListTableViewCell *scell = (AliveVideoListTableViewCell *)cell;
        [scell setupAliveModel:model];
    } else if (model.aliveType == kAliveHot) {
        AliveListHotTableViewCell *scell = (AliveListHotTableViewCell *)cell;
        [scell setupAliveModel:model];
    } else if (model.aliveType == kAliveAd) {
        AliveListAdTableViewCell *scell = (AliveListAdTableViewCell *)cell;
        [scell setupAliveModel:model];
    } else  {
        AliveListTableViewCell *scell = (AliveListTableViewCell *)cell;
        [scell setupAliveListCellData:cellData];
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isAliveDetail) {
        // 直播详情页面，不响应
        return;
    }
    
    AliveListCellData *cellData = self.itemList[indexPath.section];
    AliveListModel *model = cellData.aliveModel;
    
    [self didSelectedWithAliveModel:model withUnlock:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AliveListCellData *cellData = self.itemList[indexPath.section];
    return cellData.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        return NO;
    }
    return self.canEdit;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否取消收藏" message:@"\n取消收藏，将不在列表中显示\n" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self cancelEditWithIndexPath:indexPath];
    }];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self deleteCollectionWithIndexPath:indexPath];
    }];
    [alert addAction:cancel];
    [alert addAction:done];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

- (void)cancelEditWithIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark - Collection
- (void)deleteADWithIndexPath:(NSIndexPath *)indexPath {
    
    AliveListCellData *model = self.itemList[indexPath.section];
    NSDictionary *dict = @{@"alive_id": model.aliveModel.aliveId};
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_AliveClosedAD parameters:dict completion:^(id data, NSError *error){
        [self deleteSuccessedWithIndexPath:indexPath];
    }];
}

#pragma mark - Close AD
- (void)deleteCollectionWithIndexPath:(NSIndexPath *)indexPath {
    
    AliveListCellData *model = self.itemList[indexPath.section];
    NSDictionary *dict = @{@"collect_id": model.aliveModel.collectedId};
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    hud.label.text = @"取消收藏";
    [manager POST:API_CancelCollection parameters:dict completion:^(id data, NSError *error){
        if (!error) {
            [hud hideAnimated:YES];
            [self deleteSuccessedWithIndexPath:indexPath];
        } else {
            hud.label.text = @"取消收藏失败";
            [hud hideAnimated:YES afterDelay:0.8];
        }
        
    }];
}

- (void)deleteSuccessedWithIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.itemList];
    [array removeObjectAtIndex:indexPath.section];
    self.itemList = array;
    
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
}

#pragma mark - Action

- (void)didSelectedWithAliveModel:(AliveListModel *)model withUnlock:(BOOL)unlock{
    if (!model) {
        NSAssert(NO, @"点击的直播数据为空");
        return;
    }
    
    if (model.aliveType == kAliveNormal ||
        model.aliveType == kAlivePosts ||
        model.aliveType == kAliveStockHolder ||
        model.aliveType == kAlivePlayStock ||
        model.aliveType == kAliveStockPool ||
        model.aliveType == kAliveStockPoolRecord ||
        model.aliveType == kAliveVisitCard) {
        // 图文、推单、玩票、股票池、名片
        AliveDetailViewController *vc = [[AliveDetailViewController alloc] init];
        vc.aliveID = model.aliveId;
        vc.aliveType = model.aliveType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    } else if (model.aliveType == kAliveHot) {
        // 热点
        AliveListExtra *extra = model.extra;
        SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
        vc.contentId = model.aliveId;
        vc.stockCode = extra.companyCode;
        vc.stockName = extra.companyName;
        vc.surveyType = kSurveyTypeHot;
        vc.url = extra.surveyUrl;
        vc.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    } else if (model.aliveType == kAliveSurvey) {
        // 调研
        AliveListExtra *extra = model.extra;
        if (!extra.isUnlock) {
            if (unlock) {
                [self.unlockManager unlockSurvey:model.aliveId withSurveyType:extra.surveyType withSureyTitle:extra.surveyDesc withController:self.viewController];
            } else {
                StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
                vc.stockCode = extra.companyCode;
                vc.hidesBottomBarWhenPushed = YES;
                [self.viewController.navigationController pushViewController:vc animated:YES];
            }
        } else {
            SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
            vc.contentId = model.aliveId;
            vc.stockCode = extra.companyCode;
            vc.stockName = extra.companyName;
            vc.surveyType = extra.surveyType;
            vc.url = extra.surveyUrl;
            vc.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
    } else if (model.aliveType == kAliveAd) {
        // 广告
        AliveListAdExtra *extra = model.extra;
        [TDWebViewHandler openURL:extra.linkUrl inNav:self.viewController.navigationController];
    } else if (model.aliveType == kAliveViewpoint) {
        // 观点
        ViewpointDetailViewController *vc = [[ViewpointDetailViewController alloc] initWithAliveId:model.aliveId aliveType:model.aliveType];
        vc.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    } else if (model.aliveType == kAliveVideo) {
        // 视频
        AliveListExtra *extra = model.extra;
        if (!extra.isUnlock) {
            if (unlock) {
                [self.unlockManager unlockSurvey:model.aliveId withSurveyType:extra.surveyType withSureyTitle:extra.surveyDesc withController:self.viewController];
            } else {
                StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
                vc.stockCode = extra.companyCode;
                vc.hidesBottomBarWhenPushed = YES;
                [self.viewController.navigationController pushViewController:vc animated:YES];
            }
        } else {
            VideoDetailViewController *vc = [[VideoDetailViewController alloc] initWithVideoId:model.aliveId];
            vc.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
    } else if (model.aliveType == kAliveDeep) {
        // 深度
        AliveListExtra *extra = model.extra;
        if (!extra.isUnlock) {
            [self.unlockManager unlockDeep:model.aliveId withController:self.viewController];
        } else {
            SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
            vc.contentId = model.aliveId;
            vc.stockCode = extra.companyCode;
            vc.stockName = extra.companyName;
            vc.surveyType = extra.surveyType;
            vc.url = extra.surveyUrl;
            vc.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
    } else {
        NSAssert(NO, @"点击的直播类型不支持");
    }
}

- (void)deleteDynamicWithAliveListModel:(AliveListCellData *)cellData withIndexPath:(NSIndexPath *)indexPath {
    AliveListModel *aliveModel = cellData.aliveModel;
    
    NSDictionary *dict = @{@"alive_id": aliveModel.aliveId,@"alive_type" :@(aliveModel.aliveType)};
    
    __weak AliveListTableViewDelegate *wself = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.viewController.navigationController.view animated:YES];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_AliveDeleteRoomAlive parameters:dict completion:^(id data, NSError *error) {
        
        if (!error) {
            [hud hideAnimated:YES];
            
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
            hud.label.text = @"删除失败";
            [hud hideAnimated:YES afterDelay:0.7];
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
            [hud hideAnimated:YES];
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
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kAddAttenNotification object:nil userInfo:@{@"masterID":listModel.masterId,@"listType":@(self.listType),@"addAttend":notiStr}];
                
                [self.tableView reloadData];
                if (self.reloadView) {
                    self.reloadView();
                }
            }
        } else {
            hud.label.text = errorStr;
            [hud hideAnimated:YES afterDelay:0.7];
        }
        
    }];
    
}



@end
