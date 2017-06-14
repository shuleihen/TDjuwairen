//
//  SurveyListModel.h
//  TDjuwairen
//
//  Created by zdy on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SurveyTypeDefine.h"

@interface SurveyListModel : NSObject
//1为实地、2为对话、3为产品、4为热点、5为深度、6为评论，11为视频
@property (nonatomic, assign) SurveyType surveyType;
@property (nonatomic, copy) NSString *surveyId;
@property (nonatomic, copy) NSString *surveyTitle;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyCode;  // 股票代码不包含前缀
@property (nonatomic, copy) NSString *stockCode;    // 包含前缀 sz，sh　
@property (nonatomic, copy) NSString *surveyCover;
@property (nonatomic, copy) NSString *surveyUrl;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, assign) BOOL isUnlocked;
@property (nonatomic, assign) NSInteger unlockKeyNum;

// 是否访问过
@property (nonatomic, assign) BOOL isVisited;

+ (SurveyListModel *)getInstanceWithDictionary:(NSDictionary *)dic;
@end
