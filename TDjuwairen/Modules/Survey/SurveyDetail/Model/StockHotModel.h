//
//  StockHotModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/18.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockHotModel : NSObject
@property (nonatomic, strong) NSString *hotId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic, assign) BOOL isVisited;

- (id)initWithDict:(NSDictionary *)dict;
@end
