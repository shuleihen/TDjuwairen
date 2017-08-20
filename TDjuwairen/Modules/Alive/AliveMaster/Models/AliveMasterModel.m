//
//  AliveMasterModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveMasterModel.h"

@implementation AliveMasterModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.masterId = dict[@"master_id"];
        self.masterNickName = dict[@"user_nickname"];
        self.avatar = dict[@"user_facesmall"];
        self.attenNum = dict[@"userinfo_atten_num"];
        self.level = [dict[@"user_level"] integerValue];
        self.isAtten = [dict[@"has_atten"] boolValue];
        self.roomIntro = dict[@"userinfo_info"];
        self.userinfo_sex = dict[@"userinfo_sex"];
        
    }
    return self;
}



- (UIImage *)userInfoSexImage {
    NSString *str = @"";
    if ([self.userinfo_sex isEqualToString:@"2"]) {
        str = @"ico_sex-women";
    }else if ([self.userinfo_sex isEqualToString:@"1"]) {
        str = @"ico_sex-man";
    }else {
        
        return nil;
    }
    UIImage *img = [UIImage imageNamed:str];
    return img;
}

- (UIImage *)userLevelImage {
    NSString *str = @"";
    switch (self.level) {
        case 1:
            str = @"tag_level3";
            break;
        case 2:
            str = @"tag_level1";
            break;
        case 3:
            str = @"tag_level2";
            break;
            
        default:
            return nil;
            break;
    }

    UIImage *img = [UIImage imageNamed:str];
    return img;
    
}
@end
