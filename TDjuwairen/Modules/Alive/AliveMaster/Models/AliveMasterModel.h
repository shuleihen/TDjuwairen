//
//  AliveMasterModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliveMasterModel : NSObject
/// 播主ID
@property (nonatomic, copy) NSString *masterId;
@property (nonatomic, copy) NSString *avatar;
/// 播主昵称
@property (nonatomic, copy) NSString *masterNickName;
@property (nonatomic, copy) NSString *roomIntro;
/// 粉丝数
@property (nonatomic, copy) NSString *attenNum;
/// 用户等级
@property (nonatomic, assign) NSInteger level;
/// 用户性别
@property (nonatomic, copy) NSString *userinfo_sex;
/// true 表示当前用户已关注
@property (nonatomic, assign) BOOL isAtten;

- (UIImage *)userInfoSexImage;
- (UIImage *)userLevelImage;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
