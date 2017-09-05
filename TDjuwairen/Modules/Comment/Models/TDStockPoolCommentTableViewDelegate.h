//
//  TDStockPoolCommentTableViewDelegate.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDCommentTableViewDelegate.h"
#import "TDTopicTableViewCell.h"

// 1表示股票池评论，2表示留言板，3表示指数竞猜评论，4表示个股竞猜评论

typedef enum : NSUInteger {
    kCommentStockPool = 1,
    kCommentAliveRoom = 2,
    kCommentPlayStock = 3,
    kCommentIndividualPS    =4,
} TDCommentType;

typedef void(^ReloadTableViewBlock)(CGFloat tableViewH,BOOL noData);
@interface TDStockPoolCommentTableViewDelegate : TDCommentTableViewDelegate

@property (nonatomic, assign) TDCommentType commentType;
@property (nonatomic, strong) NSString *masterId;
@property (nonatomic, weak) UITableView *contentTableView;
@property (nonatomic, copy) ReloadTableViewBlock reloadBlock;

@end
