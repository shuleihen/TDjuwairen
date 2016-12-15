//
//  UserSurveyModel.h
//  TDjuwairen
//
//  Created by 团大 on 2016/12/15.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSurveyModel : NSObject

@property (nonatomic,strong) NSString *company_name;

@property (nonatomic,strong) NSString *survey_title;

@property (nonatomic,strong) NSString *company_code;

@property (nonatomic,strong) NSString *survey_desc;

@property (nonatomic,strong) NSString *survey_authorid;

@property (nonatomic,strong) NSString *survey_addtime;

@property (nonatomic,strong) NSString *survey_id;

@property (nonatomic,strong) NSString *survey_cover;

+ (UserSurveyModel *)getInstanceWithDic:(NSDictionary *)dic;

@end
