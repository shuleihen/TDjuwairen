//
//  LoginStateManager.m
//  juwairen
//
//  Created by tuanda on 16/5/19.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "LoginStateManager.h"

@implementation LoginStateManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static LoginStateManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LoginStateManager alloc] init];
    });
    return sharedInstance;
}

- (id)init 
{
    if (self = [super init]) {
    // 初始化数据
    }

    return self;
}

@end
