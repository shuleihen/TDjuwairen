//
//  AliveCommentViewController.h
//  TDjuwairen
//
//  Created by deng shu on 2017/3/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CommentVCNormalType = 0, /// 评论
    CommentVCStockPoolSettingType = 1, /// 股票池简介设置
    CommentVCPublishMessageBoard = 2,
} CommentVCType;

@interface AliveCommentViewController : UIViewController

typedef void(^RefreshCommentBlock)();

@property (nonatomic, copy) NSString *alive_ID;
@property (nonatomic, copy) NSString *alive_type;
@property (nonatomic, copy) RefreshCommentBlock commentBlock;

@property (assign, nonatomic) CommentVCType vcType;

@end
