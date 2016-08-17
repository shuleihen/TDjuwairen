//
//  EditZiti.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "EditZiti.h"

@implementation EditZiti

+ (EditZiti *)sharedInstance
{
    static EditZiti *model = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[self alloc]init];
        
    });
    return model;
}

@end
