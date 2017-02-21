//
//  StockSurveyModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kSurveyTagSpot      =0,
    kSurveyTagDialogue  =1,
    kSurveyTagNiuXiong  =2,
    kSurveyTagHot       =3,
    kSurveyTagVido      =4
} SurveyTag;

@interface StockSurveyModel : NSObject
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic, strong) NSString *surveyId;
@property (nonatomic, assign) NSInteger surveyTag;

- (id)initWithDict:(NSDictionary *)dict;
@end
