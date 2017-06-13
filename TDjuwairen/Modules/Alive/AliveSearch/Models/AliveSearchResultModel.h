//
//  AliveSearchResultModel.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/31.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AliveSearchResultForwardInfoModel.h"

@interface AliveSearchResultModel : NSObject
/** 用户字段 */

/// 用户ID
@property (copy, nonatomic) NSString *userID;
/// 用户头像
@property (copy, nonatomic) NSString *userIcon;
/// 用户昵称
@property (copy, nonatomic) NSString *userNickName;
/// 用户是否已关注
@property (assign, nonatomic) BOOL isAttend;

/** 股票字段 */
/// 公司名
@property (copy, nonatomic) NSString *company_name;
/// 公司代码
@property (copy, nonatomic) NSString *company_code;
/// 是否为自选股
@property (assign, nonatomic) BOOL isMyStock;

/** 调研字段 */
/// 调研ID
@property (copy, nonatomic) NSString *survey_id;
/// 调研添加日期
@property (copy, nonatomic) NSString *surveyAddtime;
/// 调研标题
@property (copy, nonatomic) NSString *survey_title;
/// 调研类型
@property (copy, nonatomic) NSString *survey_type;
/// 调研解锁钥匙数量
@property (copy, nonatomic) NSString *unlockKeynum;
/// 调研是否需要解锁
@property (assign, nonatomic) BOOL isUnlock;


/** 话题 贴单字段 */
///
@property (copy, nonatomic) NSString *aliveTime;
///
@property (strong, nonatomic) NSArray *aliveImg;
///
@property (copy, nonatomic) NSString *aliveType;
///
@property (copy, nonatomic) NSString *aliveId;
///
@property (copy, nonatomic) NSString *aliveTitle;
///
@property (copy, nonatomic) NSString *aliveMasterId;
///
@property (copy, nonatomic) NSString *aliveShareUrl;
///
@property (copy, nonatomic) NSString *aliveComTag;
///
@property (assign, nonatomic) BOOL isForward;
///
@property (strong, nonatomic) AliveSearchResultForwardInfoModel *forward_info;
///
@property (assign, nonatomic) BOOL isOfficial;
///
@property (assign, nonatomic) BOOL isSelf;



/// common
@property (copy, nonatomic) NSString *searchTextStr;



/// 用户列表
- (id)initWithUserListDict:(NSDictionary *)dict;
/// 股票列表
- (id)initWithStockListDict:(NSDictionary *)dict;
/// 调研列表
- (id)initWithSurveyListDict:(NSDictionary *)dict;
///// 话题 贴单列表
//- (id)initWithTopicListDict:(NSDictionary *)dict;
///// 观点列表
//- (id)initWithViewPointListDict:(NSDictionary *)dict;




@end
