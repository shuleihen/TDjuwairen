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


#define kAliveListCellToolHeight 37

@interface AliveListCellData : NSObject
@property (nonatomic, strong) AliveListModel *aliveModel;
@property (nonatomic, assign) CGFloat cellHeight;
@end

@implementation AliveListCellData


@end

@interface AliveListTableViewDelegate ()
<UITableViewDelegate, UITableViewDataSource, AliveListTableCellDelegate, AliveListBottomTableCellDelegate>

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
        
        UINib *nib = [UINib nibWithNibName:@"AliveListTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"AliveListTableViewCellID"];
        
        UINib *nib1 = [UINib nibWithNibName:@"AliveListBottomTableViewCell" bundle:nil];
        [self.tableView registerNib:nib1 forCellReuseIdentifier:@"AliveListBottomTableViewCellID"];

    }
    
    return self;
}

- (void)reloadWithArray:(NSArray *)array {
    
    NSMutableArray *cellArray = [NSMutableArray arrayWithCapacity:array.count];
    for (AliveListModel *model in array) {
        AliveListCellData *cellData = [[AliveListCellData alloc] init];
        cellData.aliveModel = model;
        cellData.cellHeight = [AliveListTableViewCell heightWithAliveModel:model];
        [cellArray addObject:cellData];
    }
    
    self.itemList = cellArray;
    [self.tableView reloadData];
}

- (CGFloat)contentHeight {
    CGFloat height = 0;
    
    for (AliveListCellData *model in self.itemList) {
        height += (model.cellHeight + kAliveListCellToolHeight + 10);
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

#pragma mark - AliveListBottomTableCellDelegate 

- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell sharePressed:(id)sender;
{
    [ShareHandler shareWithTitle:SafeValue(cell.cellModel.aliveTitle) image:cell.cellModel.aliveImgs url:SafeValue(cell.cellModel.shareUrl) shareState:^(BOOL state) {
        if (state) {
            [cell.shareBtn setTitle:[NSString stringWithFormat:@"%ld",cell.cellModel.shareNum+1] forState:UIControlStateNormal];
        }
    }];
}
- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell commentPressed:(id)sender;
{
    AliveCommentViewController * commVc = [AliveCommentViewController new];
    commVc.alive_ID = SafeValue(cell.cellModel.aliveId);
    commVc.alive_type = [NSString stringWithFormat:@"%ld",cell.cellModel.aliveType];
    commVc.hidesBottomBarWhenPushed = YES;
    
    commVc.commentBlock = ^(){
        [cell.commentBtn setTitle:[NSString stringWithFormat:@"%ld",cell.cellModel.commentNum+1] forState:UIControlStateNormal];
    };
    [self.viewController.navigationController pushViewController:commVc animated:YES];
}

- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell likePressed:(id)sender;
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{@"alive_id":cell.cellModel.aliveId,@"alive_type" :@(cell.cellModel.aliveType)};

    [manager POST:API_AliveAddLike parameters:dict completion:^(id data, NSError *error) {

        if (!error) {
        [cell.likeBtn setTitle:[NSString stringWithFormat:@"%ld",cell.cellModel.likeNum+1] forState:UIControlStateNormal];
            cell.likeBtn.selected = YES;
        }else{
            MBAlert(@"用户已点赞")
        }
    }];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AliveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveListTableViewCellID"];
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
        [scell setupAliveModel:model];
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

@end
