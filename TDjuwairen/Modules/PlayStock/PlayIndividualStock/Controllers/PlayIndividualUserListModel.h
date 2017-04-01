//
//  PlayIndividualUserListModel.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/31.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayIndividualUserListModel : NSObject
/// 是否为获胜者
@property (assign, nonatomic) BOOL is_winner;
/// 是否为最接近当前价格
@property (copy, nonatomic) NSString *is_points_closet;
///  用户头像
@property (copy, nonatomic) NSString *userinfo_facemin;
/// 用户昵称
@property (copy, nonatomic) NSString *user_nickname;
/// true表示竞猜的价格比当天开盘价高
@property (copy, nonatomic) NSString *is_up;
/// 是否为当前用户
@property (copy, nonatomic) NSString *is_self;
/// 竞猜的价格
@property (copy, nonatomic) NSString *item_points;

@property (assign, nonatomic) BOOL showItemPoints;


- (id)initWithDictionary:(NSDictionary *)dict;

@end
