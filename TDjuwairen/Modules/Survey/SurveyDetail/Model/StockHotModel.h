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

@property (nonatomic, assign) BOOL isCollection;
@property (nonatomic, strong) NSString *collectedId;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *companyCode;

- (id)initWithDict:(NSDictionary *)dict;
- (id)initWithCollectionDict:(NSDictionary *)dict;
@end
