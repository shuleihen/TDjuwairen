//
//  AliveTypeDefine.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#ifndef AliveTypeDefine_h
#define AliveTypeDefine_h

typedef enum : NSUInteger {
    kMainListRecommend,
    kMainListAttention,
} MainListType;

// 直播列表类型
typedef enum : NSUInteger {
    kAliveListRecommend  =0, // 推荐
    kAliveListAttention  =1, // 关注
    kAliveListStockHolder=2, // 股东大会
    kAliveListViewpoint  =3, // 观点
    kAliveListVideo      =4, // 视频
    kAlvieListPost       =5, // 推单
    kAliveListStockPool  =6, // 股票池
    kAlvieListHot        =7, // 热点
} AliveListType;

// 发布类型：1.发布话题，2.发布推单类型，3.发布股东大会，4.分享调研 ，5.分享视频 ，6.分享热点 ，7.分享深度调研 ，8.分享股票池 ，9.分享股票池记录 ，10.分享个人主页 ，11.分享观点，12.转发
typedef enum : NSInteger {
    kAlivePublishNormal     =1,
    kAlivePublishPosts      =2,
    kAlivePublishStockHolder=3,
    kAlivePublishSurvey     =4,
    kAlivePublishVideo      =5,
    kAlivePublishHot        =6,
    kAlivePublishDeep       =7,
    kAlivePublishStockPool  =8,
    kAlivePublishStockPoolDetail    =9,
    kAlivePublishVisitCard  =10,
    kAlivePublishViewpoint  =11,
    kAlivePublishForward    =12
} AlivePublishType;

// 直播间列表类型，0：全部，1：跟单，2：股票池，3：留言板
typedef enum : NSInteger {
    kAliveRoomListAll      =0,
    kAliveRoomListPosts    =1,
    kAliveRoomListStockPool=2,
    kAliveRoomListComment  =3
} AliveRoomListType;

// 直播动态类型，1：图文，2：推单，3：调研，4：热点，5：观点，6：视频，7：玩票，8：广告，9：深度调研,10：股票池，11：股票池记录，12：股东大会，13：个人主页
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
    kAliveStockPool =10,
    kAliveStockPoolRecord   =11,
    kAliveStockHolder   =12,
    kAliveVisitCard     =14,
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
    kAliveSearchSubPasteType     =4, // 推单搜索
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
