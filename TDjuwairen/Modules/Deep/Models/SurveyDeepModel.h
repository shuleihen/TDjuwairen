//
//  SurveyDeepModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kDeepPayFreeForMember   =1,
    kDeepPayJustForMember   =2,
    kDeepPayForAll          =3,
} DeepPayType;

@interface SurveyDeepModel : NSObject
@property (nonatomic, copy) NSString *surveyId;
@property (nonatomic, copy) NSString *surveyTitle;
@property (nonatomic, assign) NSInteger surveyType;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *stockCode;
@property (nonatomic, assign) BOOL isUnlock;
@property (nonatomic, assign) BOOL isVisited;
@property (nonatomic, assign) NSInteger unlockKeyNum;
@property (nonatomic, copy) NSString *deepPayTip;
// 1表示会员免费，普通用户需钥匙支付，2表示只能会员查看， 3表示必须支付钥匙才能查看
@property (nonatomic, assign) NSInteger deepPayType;
@property (nonatomic, copy) NSString *cover;

- (id)initWithDict:(NSDictionary *)dict;
@end
