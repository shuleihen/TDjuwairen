//
//  AliveTypeDefine.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#ifndef AliveTypeDefine_h
#define AliveTypeDefine_h

// 直播发布页面类型，1：图文，2：跟单，3：转发
typedef enum : NSInteger {
    kAlivePublishNormal     =1,
    kAlivePublishPosts      =2,
    kAlivePublishForward    =3
} AlivePublishType;

// 直播间列表类型，0：全部，1：跟单
typedef enum : NSInteger {
    kAliveRoomListAll      =0,
    kAliveRoomListPosts    =1
} AliveRoomListType;

// 直播动态类型，1：图文，2：贴单
typedef enum : NSInteger {
    kAliveNormal    =1,
    kAlivePosts     =2
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

#endif /* AliveTypeDefine_h */
