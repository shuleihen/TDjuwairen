//
//  LoginState.h
//  juwairen
//
//  Created by tuanda on 16/5/19.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import <Foundation/Foundation.h>

#define US [LoginState sharedInstance]

@interface LoginState : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *headImage;
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *post;
@property (nonatomic, copy) NSString *personal;
@property (nonatomic, assign) BOOL isLogIn;
@property (nonatomic, assign) BOOL isPush;

+ (instancetype)sharedInstance;
@end
