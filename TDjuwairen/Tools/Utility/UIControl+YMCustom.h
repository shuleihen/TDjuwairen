//
//  UIControl+YMCustom.h
//  YMFitnessCustom
//
//  Created by deng shu on 2017/5/15.
//  Copyright © 2017年 yamon. All rights reserved.
//  按钮重复点击处理

#import <UIKit/UIKit.h>

@interface UIControl (YMCustom)

@property (nonatomic, assign) NSTimeInterval custom_acceptEventInterval;// 可以用这个给重复点击加间隔
@property (nonatomic,strong) void (^callBack)();//在不响应时可以提示用户点击过于频繁等操作
@end
