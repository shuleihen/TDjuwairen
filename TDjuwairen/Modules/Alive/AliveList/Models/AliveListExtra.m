//
//  AliveListExtra.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/1.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListExtra.h"

@implementation AliveListExtra
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.companyName = dict[@"company_name"];
        self.companyCode = dict[@"company_code"];
        self.isUnlock = [dict[@"is_unlock"] boolValue];
        self.surveyType = [dict[@"survey_type"] integerValue];
        self.unlockKeyNum = [dict[@"unlock_keynum"] integerValue];
        self.surveyDesc = dict[@"survey_desc"];
        self.surveyUrl = dict[@"forward_url"];
    }
    
    return self;
}
@end
