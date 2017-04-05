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

@interface AliveListModel : NSObject
@property (nonatomic, assign) BOOL isForward;
@property (nonatomic, copy) NSString *aliveId;
@property (nonatomic, assign) AliveType aliveType;
@property (nonatomic, copy) NSString *aliveTitle;
@property (nonatomic, strong) NSArray *aliveImgs;
@property (nonatomic, copy) NSString *aliveTime;
@property (nonatomic, copy) NSString *masterId;
@property (nonatomic, copy) NSString *masterNickName;
@property (nonatomic, copy) NSString *masterAvatar;
@property (nonatomic, assign) NSInteger commentNum;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, assign) NSInteger shareNum;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, strong) NSArray *aliveTags;   // 标签数组
@property (nonatomic, strong) AliveListForwardModel *forwardModel;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
