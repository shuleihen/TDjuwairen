//
//  LoginStateManager.m
//  juwairen
//
//  Created by tuanda on 16/5/19.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "LoginStateManager.h"

@implementation LoginStateManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static LoginStateManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LoginStateManager alloc] init];
    });
    return sharedInstance;
}

- (id)init 
{
    if (self = [super init]) {
    // 初始化数据
    }

    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [self init]) {
        self.sex = [dict[@"userinfo_sex"] integerValue];
        self.city = dict[@"userinfo_address"];
        self.userId = dict[@"user_id"];
        self.userName = dict[@"user_name"];
        self.personal = dict[@"userinfo_info"];
        self.headImage = dict[@"userinfo_facesmall"];
        self.nickName = dict[@"user_nickname"];
        self.userPhone = dict[@"userinfo_phone"];
        self.userLevel = [dict[@"user_level"] integerValue];
        
    }
    return self;
}

- (NSString *)sexString {
    NSString *string;
    switch (self.sex) {
        case kUserSexNone:
            string = @"未设置";
            break;
        case kUserSexMan:
            string = @"男";
            break;
        case kUserSexWoman:
            string = @"女";
            break;
        default:
            break;
    }
    return string;
}

@end
