//
//  SurveySubjectModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SurveySubjectModel.h"

@implementation SurveySubjectModel
- (id)initWithDict:(NSDictionary *)dic {
    if (self = [super init]) {
        self.subjectId = [NSString stringWithFormat:@"%d",[dic[@"subject_id"] intValue]];
        self.subjectTitle = dic[@"subject_title"];
        self.isCanCancel = [dic[@"is_cancel"] boolValue];
        self.isAtten = [dic[@"has_atten"] boolValue];
    }
    return self;
}
@end
