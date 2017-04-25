//
//  StockSurveyModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kSurveyTypeSpot      =1,
    kSurveyTypeDialogue  =2,
    kSurveyTypeShengdu   =5,
    kSurveyTypeComment   =6,
    kSurveyTypeVido      =11
} SurveyType;

@interface StockSurveyModel : NSObject
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic, strong) NSString *surveyId;
// 1为实地、2为对话、5为深度、6为评论，11表示视频
@property (nonatomic, assign) NSInteger surveyType;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *companyCode;


- (id)initWithDict:(NSDictionary *)dict;
@end
