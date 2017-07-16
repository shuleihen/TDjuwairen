//
//  PSIndividualUserListModel.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/31.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSIndividualUserListModel : NSObject
@property (copy, nonatomic) NSString *userinfo_facemin;
@property (copy, nonatomic) NSString *user_nickname;
@property (strong, nonatomic) NSNumber *item_points;
@property (assign, nonatomic) BOOL is_winner;
@property (assign, nonatomic) BOOL is_self;
// 是否为最接近当前价格
@property (assign, nonatomic) BOOL is_points_closet;
// true表示竞猜的价格比当天开盘价高
@property (assign, nonatomic) BOOL is_up;

// 逻辑字段
@property (assign, nonatomic) BOOL showItemPoints;

@property (nonatomic, assign) NSInteger rank;
@property (assign, nonatomic) BOOL isStarter;
@property (assign, nonatomic) NSInteger winKeyNum;
@property (nonatomic, copy) NSString *addTime;

- (id)initWithDictionary:(NSDictionary *)dict;
- (id)initWithDetailDictionary:(NSDictionary *)dict;
@end
