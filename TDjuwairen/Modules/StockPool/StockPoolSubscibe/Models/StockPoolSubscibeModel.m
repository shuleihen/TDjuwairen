//
//  StockPoolSubscibeModel.m
//  TDjuwairen
//
//  Created by deng shu on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolSubscibeModel.h"

@implementation StockPoolSubscibeModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if(self = [super init]) {
        self.userinfo_sex = dict[@"userinfo_sex"];
        self.has_atten = [dict[@"has_atten"] boolValue];
        self.user_id = dict[@"user_id"];
        self.userinfo_info = dict[@"userinfo_info"];
        self.user_nickname = SafeValue(dict[@"user_nickname"]);
        self.userinfo_facemin = dict[@"userinfo_facemin"];
        self.expire_day = dict[@"expire_day"];
        self.user_level = dict[@"user_level"];
    }
    return self;
}


- (UIImage *)userInfoSexImage {
    NSString *str = @"";
    if ([self.userinfo_sex isEqualToString:@"1"]) {
        str = @"ico_sex-women";
    }else if ([self.userinfo_sex isEqualToString:@"0"]) {
        str = @"ico_sex-man";
    }else {
        
        return nil;
    }
    UIImage *img = [UIImage imageNamed:str];
    return img;
}

- (UIImage *)userLevelImage {
    NSString *str = @"";
    if ([self.userinfo_sex isEqualToString:@"1"]) {
        str = @"tag_level3";
    }else if ([self.userinfo_sex isEqualToString:@"2"]) {
        str = @"tag_level1";
    }else if ([self.userinfo_sex isEqualToString:@"3"]) {
        str = @"tag_level2";
    }else {
        
        return nil;
    }
    UIImage *img = [UIImage imageNamed:str];
    return img;

}
@end
