//
//  StockSurveyModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SurveyTypeDefine.h"

@interface StockSurveyModel : NSObject
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic, strong) NSString *surveyId;
@property (nonatomic, assign) SurveyType surveyType;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *companyCode;


- (id)initWithDict:(NSDictionary *)dict;
@end
