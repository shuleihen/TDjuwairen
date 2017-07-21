//
//  TDAdvertModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/18.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kADTypeSurvey   =1, // 调研
    kADTypeVideo    =2, // 视频详情
    kADTypeShendu   =3, // 深度详情
    kADTypeStock    =4, // 公司主页
    kADTypeH5       =5, // h5页面
    kADTypeVideoList    =6, // 视频列表
    kADTypeShenduList   =7, // 深度列表
    kADTypeRecharge     =8, // 充值
} ADType;

@interface TDAdvertModel : NSObject
@property (nonatomic, assign) NSInteger adType;
@property (nonatomic, copy) NSString *adUrl;
@property (nonatomic, copy) NSString *adImageUrl;
@property (nonatomic, copy) NSString *adTitle;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
