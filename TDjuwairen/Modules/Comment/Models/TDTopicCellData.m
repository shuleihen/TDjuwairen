//
//  TDTopicCellData.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDTopicCellData.h"

@implementation TDTopicCellData
- (void)setTopicModel:(TDTopicModel *)topicModel {
    _topicModel = topicModel;
    
    CGSize size = [topicModel.topicTitle boundingRectWithSize:CGSizeMake(kScreenWidth-64-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil].size;
    self.topickTitleFrame = CGRectMake(64, 38, size.width, size.height+2);
    
    CGFloat height = 0;
    for (TDCommentCellData *cell in topicModel.comments) {
        height += cell.cellHeight;
    }
    self.topickCommentTableViewRect = CGRectMake(64, CGRectGetMaxY(self.topickTitleFrame) + 28, kScreenWidth-64-12, height);
    self.cellHeight = CGRectGetMaxY(self.topickCommentTableViewRect) + 10;
}
@end
