//
//  LoginState.h
//  juwairen
//
//  Created by tuanda on 16/5/19.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginState : NSObject
//用户id
@property (nonatomic, copy) NSString *userId;
//用户名
@property (nonatomic, copy) NSString *userName;
//头像
@property (nonatomic, copy) NSString *headImage;
//手机号
@property (nonatomic, copy) NSString *userPhone;
//昵称
@property (nonatomic, copy) NSString *nickName;
//公司
@property (nonatomic, copy) NSString *company;
//职务
@property (nonatomic, copy) NSString *post;
//个人简介
@property (nonatomic, copy) NSString *personal;
@property (nonatomic, assign) BOOL isLogIn;

+(LoginState *)addInstance;

@end
