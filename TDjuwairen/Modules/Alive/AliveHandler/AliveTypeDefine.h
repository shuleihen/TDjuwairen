//
//  AliveTypeDefine.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#ifndef AliveTypeDefine_h
#define AliveTypeDefine_h

// 直播列表类型
typedef enum : NSUInteger {
    kAliveListRecommend  =0, // 推荐
    kAliveListAttention  =1, // 关注
    kAliveListViewpoint  =2, // 观点
    kAliveListVideo      =3, // 视频
    kAlvieListPost       =4, // 推单
} AliveListType;

// 直播发布页面类型，1：图文，2：跟单，3：转发, 4：调研详情页面分享，5：玩票分享到直播
typedef enum : NSInteger {
    kAlivePublishNormal     =1,
    kAlivePublishPosts      =2,
    kAlivePublishForward    =3,
    kAlivePublishShare      =4,
    kAlivePublishSharePlayStock =5,
} AlivePublishType;

// 直播间列表类型，0：全部，1：跟单
typedef enum : NSInteger {
    kAliveRoomListAll      =0,
    kAliveRoomListPosts    =1
} AliveRoomListType;

// 直播动态类型，1：图文，2：贴单，3：调研，4：热点，5：观点，6：视频，7：玩票，8：广告，9：深度调研
typedef enum : NSInteger {
    kAliveNormal    =1,
    kAlivePosts     =2,
    kAliveSurvey    =3,
    kAliveHot       =4,
    kAliveViewpoint =5,
    kAliveVideo     =6,
    kAlivePlayStock =7,
    kAliveAd        =8,
    kAliveDeep      =9,
} AliveType;

// 直播内容类型，0：文本，1：图片
typedef enum : NSInteger {
    kAliveContentTxt    =0,
    kAliveContentImg    =1
} AliveContentType;

// 直播消息类型
typedef enum : NSInteger {
    kMessageTypeAliveNormalComment  =1,
    kMessageTypeAlivePostsComment   =2,
    kMessageTypeAliveNormalLike     =3,
    kMessageTypeAlivePostsLike      =4,
    kMessageTypeAliveNormalShare    =5,
    kMessageTypeAlivePostsShare     =6
} AliveMessageType;

// 直播搜索类型
typedef enum : NSUInteger {
    kAliveSearchSubUserType      =0, // 用户搜索
    kAliveSearchSubStockType     =1, // 股票搜索
    kAliveSearchSubSurveyType    =2, // 调研搜索
    kAliveSearchSubTopicType     =3, // 话题搜索
    kAliveSearchSubPasteType     =4, // 贴单搜索
    kAliveSearchSubViewPointType =5  // 观点搜索
} AliveSearchSubType;

// 主播列表类型
typedef enum : NSUInteger {
    kAliveMasterList     =0, // 播主列表
    kAliveAttentionList  =1, // 关注列表
    kAliveFansList       =2, // 粉丝列表
    kAliveDianZanList    =3, // 点赞列表
    kAliveShareList      =4  // 分享列表
} AliveMasterListType;

#endif /* AliveTypeDefine_h */
