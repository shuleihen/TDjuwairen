//
//  SurveySubjectModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveySubjectModel : NSObject
@property (nonatomic, strong) NSString *subjectId;
@property (nonatomic, strong) NSString *subjectTitle;

- (SurveySubjectModel *)initWithDict:(NSDictionary *)dic;
@end
