//
//  LoginStateManager.h
//  juwairen
//
//  Created by tuanda on 16/5/19.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import <Foundation/Foundation.h>

#define US [LoginStateManager sharedInstance]

// 下个版本 0表示普通用户，1表示青铜会员，2表示白银会员 3表示黄金会员
typedef enum : NSUInteger {
    kUserLevelNormal    =0,
//    kUserLevelBronze    =1,
//    kUserLevelSilver    =2,
    kUserLevelGold      =1,
} UserLevelType;

@interface LoginStateManager : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *headImage;
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *post;
@property (nonatomic, copy) NSString *personal;
@property (nonatomic, assign) NSInteger userLevel;

@property (nonatomic,assign) int user_balance;


@property (nonatomic, assign) BOOL isLogIn;

@property (nonatomic,assign) BOOL isReply;
@property (nonatomic, assign) BOOL isPush;

+ (instancetype)sharedInstance;
@end
