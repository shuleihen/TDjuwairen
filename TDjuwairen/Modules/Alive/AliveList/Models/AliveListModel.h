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

@interface AliveListModel : NSObject
// 是否为转发动态
@property (nonatomic, assign) BOOL isForward;
/// 动态ID
@property (nonatomic, copy) NSString *aliveId;
// 直播动态类型，1表示图文、2表示贴单、3表示调研、4表示热点、5观点
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
/// 贴单标签(数组)
@property (nonatomic, strong) NSArray *aliveTags;
@property (nonatomic, strong) NSArray *aliveStockTags;

@property (nonatomic, strong) AliveListForwardModel *forwardModel;
///  是否官方认证
@property (nonatomic, assign) BOOL isOfficial;
/// 是否关注了该用户
@property (assign, nonatomic) BOOL isAttend;
/// 该动态是否为当前用户
@property (assign, nonatomic) BOOL isSelf;
// 调研股票信息
@property (nonatomic, strong) AliveListExtra *extra;

// 收藏ID
@property (nonatomic, copy) NSString *collectedId;
@property (copy, nonatomic) NSString *searchTextStr;

@property (nonatomic, assign) BOOL isCollection;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
