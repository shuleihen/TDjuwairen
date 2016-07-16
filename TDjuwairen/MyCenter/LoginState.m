//
//  LoginState.m
//  juwairen
//
//  Created by tuanda on 16/5/19.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "LoginState.h"

static LoginState *addObject=nil;//设置静态实例，初始化
@implementation LoginState

+(LoginState *)addInstance //检查示例是否为空 否则创建
{
    @synchronized (self) {//同步
        if (addObject==nil) {
            addObject=[[self alloc]init];//没有，允许创建
        }
    }
    return addObject;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self) {
        if (addObject==nil) {
            addObject=[super allocWithZone:zone];
        }
        return addObject;
    }
    return nil;
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(id)init
{
    @synchronized(self) {
        self =[super init];
    }
    return self;
}

@end
