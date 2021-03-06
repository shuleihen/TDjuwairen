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
@property (nonatomic, copy) NSString *deepPayTip;
@property (nonatomic, assign) NSInteger deepPayType;
@property (nonatomic, assign) BOOL isVisited;

// 自选列表标题类型：1表示调研；2表示热点，3表示暂无,4表示公告
@property (nonatomic, assign) NSInteger surveyTitleType;
@property (nonatomic, assign) BOOL isNewAlive;

- (id)initWithDictionary:(NSDictionary *)dict;
- (id)initWithOptionalDictionary:(NSDictionary *)dict;
@end
