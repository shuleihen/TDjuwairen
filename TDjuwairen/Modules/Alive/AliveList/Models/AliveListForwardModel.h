//
//  AliveListForwardModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/30.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AliveTypeDefine.h"

@interface AliveListForwardModel : NSObject
/// 转发动态ID或调研热点分享的ID
@property (nonatomic, copy) NSString *aliveId;
/// 直播转发或调研、热点分享封面
@property (nonatomic, copy) NSString *aliveImg;

@property (nonatomic, strong) NSArray *aliveImgs;

/// 1表示图文、2表示贴单、3表示调研、4表示热点
@property (nonatomic, assign) AliveType aliveType;
///
@property (nonatomic, copy) NSString *masterId;
/// 用户昵称
@property (nonatomic, copy) NSString *masterNickName;
/// 转发或调研热点分享的标题
@property (nonatomic, copy) NSString *aliveTitle;

@property (nonatomic, copy) NSString *aliveTime;
/// 标签名
@property (nonatomic, strong) NSArray *aliveTags;
/// 股票代码
@property (nonatomic, copy) NSString *stockCode;
/// 调研、热点分享时分享的url
@property (nonatomic, copy) NSString *forwardUrl;
/// 当为调研的分享时，该字段表示是否加锁
@property (nonatomic, assign) BOOL isLocked;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
