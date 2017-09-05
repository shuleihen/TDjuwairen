//
//  TDStockPoolCommentTableViewDelegate.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDStockPoolCommentTableViewDelegate.h"
#import "NetworkManager.h"
#import "TDTopicModel.h"
#import "TDCommentModel.h"
#import "TDTopicCellData.h"
#import "TDCommentCellData.h"
#import "TDTopicTableViewCell.h"
#import "TDCommentPublishViewController.h"


@interface TDStockPoolCommentTableViewDelegate ()
<UITableViewDelegate, UITableViewDataSource,TDTopicTableViewCellDelegate, TDCommentPublishDelegate>
@end

@implementation TDStockPoolCommentTableViewDelegate

- (id)initWithTableView:(UITableView *)tableView controller:(UIViewController *)controller {
    if (self = [super initWithTableView:tableView controller:controller]) {
        tableView.delegate = self;
        tableView.dataSource = self;
    }
    return self;
}

- (void)loadDataWithPage:(NSInteger)page {
    if (self.masterId.length == 0) {
        return;
    }
    
    __weak TDStockPoolCommentTableViewDelegate *wself = self;
    NSDictionary *dict = @{@"item_type":@(self.commentType),@"item_id":self.masterId?:@"",@"page":@(self.page)};
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_AliveGetCommentList parameters:dict completion:^(id data, NSError *error){
        
        if (!error && data) {
            CGFloat height = 0.0;
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[data count]];
            for (NSDictionary *dict in data) {
                
                TDTopicModel *topic = [[TDTopicModel alloc] init];
                topic.topicId = dict[@"comment_id"];
                topic.topicTitle = dict[@"comment_text"];
                topic.topicTime = dict[@"comment_ptime"];
                topic.userAvatar = dict[@"userinfo_facemin"];
                topic.userNickName = dict[@"user_nickname"];
                
                NSArray *replyList = dict[@"reply_list"];
                NSMutableArray *replys = [NSMutableArray arrayWithCapacity:replyList.count];
                
                for (NSDictionary *pdict in replyList) {
                    TDCommentModel *comment = [[TDCommentModel alloc] init];
                    comment.commentId = pdict[@"comment_id"];
                    comment.content = pdict[@"comment_text"];
                    comment.time = pdict[@"comment_ptime"];
                    comment.avatar = pdict[@"userinfo_facemin"];
                    comment.nickName = pdict[@"user_nickname"];
                    comment.replayToUserNickName = pdict[@"reply_to_usernickname"];
                    
                    TDCommentCellData *commentCellData = [[TDCommentCellData alloc] init];
                    commentCellData.commentModel = comment;
                    [replys addObject:commentCellData];
                }
                
                topic.comments = replys;
                
                TDTopicCellData *topicCellData = [[TDTopicCellData alloc] init];
                topicCellData.topicModel = topic;
                [array addObject:topicCellData];
                
                height += topicCellData.cellHeight;
            }
            
            wself.tableView.frame = CGRectMake(0, wself.tableView.frame.origin.y, kScreenWidth, height);
            wself.contentTableView.tableFooterView = wself.tableView;
            if (wself.page == 1) {
                wself.items = [NSMutableArray arrayWithArray:array];
            }else {
                
                [wself.items addObjectsFromArray:array];
            }
            wself.page ++;
            if (self.reloadBlock) {
                self.reloadBlock(height, wself.items.count<=0);
            }
            
        }
        
        [wself.tableView reloadData];
    }];
}

- (void)commentPublishSuccessed {
    [self refreshData];
}

- (void)replyWithCommentId:(NSString *)commentId {
    TDCommentPublishViewController *vc = [[TDCommentPublishViewController alloc] init];
    vc.publishType = kCommentPublishStockPoolReplay;
    vc.delegate = self;
    vc.masterId = self.masterId;
    vc.commentId = commentId;
    [self.controller.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDTopicTableViewCellID"];
    if (cell == nil) {
        cell = [[TDTopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TDTopicTableViewCellID"];
        cell.delegate = self;
    }
    
    TDTopicCellData *topicCellData = self.items[indexPath.row];
    cell.topicCellData = topicCellData;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDTopicCellData *topicCellData = self.items[indexPath.row];
    return topicCellData.cellHeight;
}
@end
