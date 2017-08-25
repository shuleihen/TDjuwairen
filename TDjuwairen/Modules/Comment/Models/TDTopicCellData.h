//
//  TDTopicCellData.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDTopicModel.h"
#import "TDCommentCellData.h"

@interface TDTopicCellData : NSObject
@property (nonatomic, strong) TDTopicModel *topicModel;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGRect topickTitleFrame;
@property (nonatomic, assign) CGRect topickCommentTableViewRect;
@end
