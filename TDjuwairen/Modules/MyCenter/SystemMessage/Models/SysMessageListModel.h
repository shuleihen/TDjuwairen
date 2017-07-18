//
//  SysMessageListModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/18.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SysMessageListModel : NSObject
@property (nonatomic, copy) NSString *msgId;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, assign) NSInteger msgContentType; // 0表示文本，1表示图片
@property (nonatomic, assign) NSInteger msgType;    // 1表示活动，2表示钥匙奖励 ，3表示 用户反馈，4表示兑换奖品
@property (nonatomic, copy) NSString *msgTime;
@property (nonatomic, copy) NSString *msgTitle;
@property (nonatomic, copy) NSString *msgLink;
@property (nonatomic, assign) NSInteger msgLinkType;

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSString *)typeString;
@end
