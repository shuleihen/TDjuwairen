//
//  PSIndividualGuessModel.m
//  TDjuwairen
//
//  Created by deng shu on 2017/3/29.
//  Copyright © 2017年 团大网络科技. All rights reserved.

/**
 
 {
 "msg": "success",
 "code": "200",
 "data": {
 "guess_season": 1,
 "guess_comment_count": "182",
 "userinfo_facemin": "",
 "user_nickname": "",
 "guess_date": "2017-03-28",
 "user_keynum": 0
 }
 }
 */

#import "PSIndividualGuessModel.h"

@implementation PSIndividualGuessModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
                self.guess_season = dict[@"guess_season"];
                self.guess_comment_count = dict[@"guess_comment_count"];
                self.userinfo_facemin = dict[@"userinfo_facemin"];
                self.user_nickname = dict[@"user_nickname"];
                self.guess_date = dict[@"guess_date"];
                self.user_keynum = dict[@"user_keynum"];
        
    }
    
    return self;
}
@end
