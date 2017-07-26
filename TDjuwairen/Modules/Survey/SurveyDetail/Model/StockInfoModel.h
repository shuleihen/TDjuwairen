//
//  StockInfoModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockInfoModel : NSObject
@property (nonatomic, strong) NSString *stockId;
@property (nonatomic, strong) NSString *stockName;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSNumber *joinGradeNum;
@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, strong) NSString *allCompanyNum;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, assign) NSInteger keyNum;

- (id)initWithDict:(NSDictionary *)dict;
@end
