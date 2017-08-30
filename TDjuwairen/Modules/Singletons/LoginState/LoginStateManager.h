//
//  LoginStateManager.h
//  juwairen
//
//  Created by tuanda on 16/5/19.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import <Foundation/Foundation.h>

#define US [LoginStateManager sharedInstance]

// 下个版本 0表示普通用户，1表示黄金会员，2表示青铜会员 ，3表示白银会员
typedef enum : NSUInteger {
    kUserLevelNormal    =0,
    kUserLevelGold      =1,
    kUserLevelBronze    =2,
    kUserLevelSilver    =3,
    
} UserLevelType;

// 0表示没有设置，1表示女，2表示男
typedef enum : NSUInteger {
    kUserSexNone        =0,
    kUserSexWoman       =1,
    kUserSexMan         =2,
} UserSexType;

@interface LoginStateManager : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *headImage;
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *post;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *personal;
@property (nonatomic, assign) NSInteger userLevel;
@property (nonatomic, assign) NSInteger sex;

@property (nonatomic,assign) int user_balance;


@property (nonatomic, assign) BOOL isLogIn;

@property (nonatomic,assign) BOOL isReply;
@property (nonatomic, assign) BOOL isPush;

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSString *)sexString;

+ (instancetype)sharedInstance;
@end
