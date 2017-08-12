//
//  StockPoolSubscibeModel.m
//  TDjuwairen
//
//  Created by deng shu on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolSubscibeModel.h"

@implementation StockPoolSubscibeModel
- (instancetype)initWithDict:(NSDictionary *)dict {

    if(self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
