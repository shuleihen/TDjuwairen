//
//  TDCommentTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDCommentCellData.h"

@interface TDCommentTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *commentTimeLabel;
@property (nonatomic, strong) UIButton *replyBtn;
@property (nonatomic, copy) void (^replyBlock)(NSString *);

@property (nonatomic, strong) TDCommentCellData *commentCellData;
@end
