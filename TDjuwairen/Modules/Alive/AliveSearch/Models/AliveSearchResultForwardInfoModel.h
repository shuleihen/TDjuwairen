//
//  AliveSearchResultForwardInfoModel.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/6/1.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliveSearchResultForwardInfoModel : NSObject
/// 用户昵称
@property (copy, nonatomic) NSString *userNickName;
///
@property (copy, nonatomic) NSString *aliveTitle;
///
@property (copy, nonatomic) NSString *aliveImg;
///
@property (copy, nonatomic) NSString *aliveType;
///
@property (copy, nonatomic) NSString *aliveId;
///
@property (copy, nonatomic) NSString *aliveMasterId;
///
@property (copy, nonatomic) NSString *aliveComTag;
///
@property (copy, nonatomic) NSString *forwardUrl;
/// 公司代码
@property (copy, nonatomic) NSString *company_code;

/// 调研是否需要解锁
@property (assign, nonatomic) BOOL isLock;

- (id)initWithTopicForwardInfoDict:(NSDictionary *)dict;
@end
