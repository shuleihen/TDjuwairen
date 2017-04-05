//
//  AliveMessageModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AliveTypeDefine.h"


@interface AliveMessageModel : NSObject
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *aliveId;

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *avatar;
// 消息类型：1表示图文评论，2表示贴单评论，3表示图文点赞，4表示贴单点赞，5表示图文分享，6表示贴单分享
@property (nonatomic, assign) NSInteger messageType;
@property (nonatomic, copy) NSString *messageContent;
// 动态类型：1表示图文，2表示贴单
@property (nonatomic, assign) AliveType aliveType;
// 动态内容类型：0表示文本，1表示图片
@property (nonatomic, assign) NSInteger aliveContentType;
@property (nonatomic, copy) NSString *aliveContent;
@property (nonatomic, copy) NSString *time;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
