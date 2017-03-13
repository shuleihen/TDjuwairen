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
#import "AliveRoomViewController.h"
#import "AliveDetailViewController.h"

@interface AliveListTableViewDelegate ()
<UITableViewDelegate, UITableViewDataSource, AliveListTableCellDelegate, AliveListBottomTableCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) NSArray *itemList;
@end

@implementation AliveListTableViewDelegate
- (id)initWithTableView:(UITableView *)tableView withViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        tableView.delegate = self;
        tableView.dataSource = self;
        
        self.tableView = tableView;
        self.viewController = viewController;
        
        UINib *nib = [UINib nibWithNibName:@"AliveListTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"AliveListTableViewCellID"];
        
        UINib *nib1 = [UINib nibWithNibName:@"AliveListBottomTableViewCell" bundle:nil];
        [self.tableView registerNib:nib1 forCellReuseIdentifier:@"AliveListBottomTableViewCellID"];
       
//        [self.tableView addObserver:viewController forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
//        [_tableView addObserver:self.viewController forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

    }
    
    return self;
}

- (void)reloadWithArray:(NSArray *)array {
    self.itemList = array;
    [self.tableView reloadData];
}


#pragma mark - AliveListTableCellDelegate

- (void)aliveListTableCell:(AliveListTableViewCell *)cell avatarPressed:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        AliveListModel *model = self.itemList[indexPath.section];
        
        AliveRoomViewController *vc = [[AliveRoomViewController alloc] init];
        vc.masterId = model.masterId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - AliveListBottomTableCellDelegate 

- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell sharePressed:(id)sender {
    
}

- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell commentPressed:(id)sender {
    
}

- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell likePressed:(id)sender {
    
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
        AliveListModel *model = self.itemList[indexPath.section];
        return [AliveListTableViewCell heightWithAliveModel:model];
    } else {
        return 37;
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
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    AliveListModel *model = self.itemList[indexPath.section];
    
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
    
    AliveListModel *model = self.itemList[indexPath.section];
    if (model.aliveId.length <= 0) {
        return;
    }
    AliveDetailViewController *vc = [[AliveDetailViewController alloc] init];
    vc.alive_ID = model.aliveId;
    vc.alive_type = model.aliveType==1?@"1":@"2";
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
    
    
}

//- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
//    
//    if (observer == _tableView && [keyPath isEqualToString:@"contentSize"]) {
//        if (self.hBlock) {
//            self.hBlock(self.tableView.contentSize.height);
//        }
//    }
//}


//- (void)dealloc {
//
//    [self.tableView removeObserver:self.viewController forKeyPath:@"contentSize"];
//}

@end
