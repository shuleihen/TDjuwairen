//
//  TDStockPoolCommentTableViewDelegate.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDCommentTableViewDelegate.h"
#import "TDTopicTableViewCell.h"

@interface TDStockPoolCommentTableViewDelegate : TDCommentTableViewDelegate

@property (nonatomic, strong) NSString *masterId;
@property (nonatomic, weak) UITableView *contentTableView;
@end
