//
//  SurveyModel.h
//  TDjuwairen
//
//  Created by zdy on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyModel : NSObject
@property (nonatomic, assign) NSInteger surveyType;
@property (nonatomic, copy) NSString *surveyId;
@property (nonatomic, copy) NSString *surveyTitle;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyCode;  // 股票代码不包含前缀
@property (nonatomic, copy) NSString *stockCode;    // 包含前缀 sz，sh
@property (nonatomic, copy) NSString *surveyCover;
@property (nonatomic, copy) NSString *surveyUrl;
@property (nonatomic, copy) NSString *addTime;

+ (SurveyModel *)getInstanceWithDictionary:(NSDictionary *)dic;
@end
