//
//  AliveListModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AliveTypeDefine.h"
#import "AliveListForwardModel.h"
#import "AliveListExtra.h"
#import "AliveListPlayStockExtra.h"
#import "AliveListAdExtra.h"
#import "AliveListPostExtra.h"
#import "AliveListStockPoolExtra.h"

@interface AliveListModel : NSObject

/// 动态ID
@property (nonatomic, copy) NSString *aliveId;
// 直播动态类型，1表示图文、2表示推单、3表示调研、4表示热点、5观点
@property (nonatomic, assign) AliveType aliveType;
/// 动态文本内容
@property (nonatomic, copy) NSString *aliveTitle;
/// 动态图片列表
@property (nonatomic, strong) NSArray *aliveImgs;
/// 动态时间
@property (nonatomic, copy) NSString *aliveTime;
/// 播主ID
@property (nonatomic, copy) NSString *masterId;
/// 播主昵称
@property (nonatomic, copy) NSString *masterNickName;
/// 播主头像
@property (nonatomic, copy) NSString *masterAvatar;
/// 动态评论数
@property (nonatomic, assign) NSInteger commentNum;
/// 当前用户是否点赞
@property (nonatomic, assign) BOOL isLike;
/// 点赞数
@property (nonatomic, assign) NSInteger likeNum;
/// 分享数
@property (nonatomic, assign) NSInteger shareNum;
/// 分享地址URL
@property (nonatomic, copy) NSString *shareUrl;
// 访问数量，暂时只有观点类型有
@property (nonatomic, assign) NSInteger visitNum;

/// 是否官方认证
@property (nonatomic, assign) BOOL isOfficial;
/// 是否关注了该用户
@property (assign, nonatomic) BOOL isAttend;
/// 该动态是否为当前用户
@property (assign, nonatomic) BOOL isSelf;

// 是否为转发动态
@property (nonatomic, assign) BOOL isForward;

// 转发直播内容
@property (nonatomic, strong) AliveListForwardModel *forwardModel;

// 直播额外信息
@property (nonatomic, strong) id extra;

// 收藏ID
@property (nonatomic, copy) NSString *collectedId;
@property (copy, nonatomic) NSString *searchTextStr;

@property (nonatomic, assign) BOOL isCollection;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
