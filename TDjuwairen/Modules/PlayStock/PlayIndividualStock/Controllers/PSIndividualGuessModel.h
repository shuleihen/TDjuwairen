//
//  PSIndividualGuessModel.h
//  TDjuwairen
//
//  Created by deng shu on 2017/3/29.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSIndividualGuessModel : NSObject

@property (nonatomic, assign) NSInteger guess_season;
@property (nonatomic, strong) NSNumber *guess_comment_count;
@property (nonatomic, copy) NSString *userinfo_facemin;
@property (nonatomic, copy) NSString *user_nickname;
@property (nonatomic, copy) NSString *guess_date;
@property (nonatomic, assign) long long guess_endTime;
@property (nonatomic, strong) NSNumber *user_keynum;
@property (nonatomic, strong) NSArray *guess_message;
@property (nonatomic, assign) NSInteger next_day;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
