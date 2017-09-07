//
//  StockPoolDetailModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPEditRecordModel.h"

@interface StockPoolDetailModel : NSObject
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, assign) BOOL isMaster;
@property (nonatomic, copy) NSString *ratio;
@property (nonatomic, copy) NSString *masterId;
@property (nonatomic, strong) NSArray *positions;
@property (nonatomic, strong) NSString *shareIcon;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, assign) BOOL isNewRecord;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
