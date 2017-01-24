//
//  ExchangeModel.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExchangeModel : NSObject

@property (nonatomic, copy) NSString *prize_app_img;

@property (nonatomic, copy) NSString *prize_name;

@property (nonatomic, copy) NSString *prize_level;

@property (nonatomic, copy) NSString *prize_keynum;

@property (nonatomic, assign) bool is_exchange;

+ (ExchangeModel *)getInstanceWithDic:(NSDictionary *)dic;

@end
