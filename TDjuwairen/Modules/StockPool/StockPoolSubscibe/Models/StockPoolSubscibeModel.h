//
//  StockPoolSubscibeModel.h
//  TDjuwairen
//
//  Created by deng shu on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockPoolSubscibeModel : NSObject
/// 性别：0表示没有设置，1表示女，2表示男
@property (nonatomic, copy) NSString *userinfo_sex;
/// true表示已关注
@property (nonatomic, assign) BOOL has_atten;
/// 用户ID
@property (nonatomic, copy) NSString *user_id;
/// 签名
@property (nonatomic, copy) NSString *userinfo_info;
/// 昵称
@property (nonatomic, copy) NSString *user_nickname;
/// 用户头像
@property (nonatomic, copy) NSString *userinfo_facemin;
/// 过期或到期时间
@property (nonatomic, copy) NSString *expire_day;
/// 等级
@property (nonatomic, copy) NSString *user_level;

- (UIImage *)userInfoSexImage;

- (instancetype)initWithDict:(NSDictionary *)dict;


@end
