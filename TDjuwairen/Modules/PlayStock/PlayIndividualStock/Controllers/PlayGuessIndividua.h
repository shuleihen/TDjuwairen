//
//  PlayGuessIndividua.h
//  TDjuwairen
//
//  Created by deng shu on 2017/3/29.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayGuessIndividua : NSObject

@property (nonatomic, strong) NSNumber *guess_season;
@property (nonatomic, strong) NSNumber *guess_comment_count;
@property (nonatomic, copy) NSString *userinfo_facemin;
@property (nonatomic, copy) NSString *user_nickname;
@property (nonatomic, copy) NSString *guess_date;
@property (nonatomic, strong) NSNumber *user_keynum;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
