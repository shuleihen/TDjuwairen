//
//  SurveyDeepModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@property (nonatomic, assign) NSInteger deepPayType;
@property (nonatomic, copy) NSString *cover;

- (id)initWithDict:(NSDictionary *)dict;
@end
