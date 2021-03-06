//
//  SPEditRecordModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/15.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kSPEidtCellNormal,
    kSPEidtCellEidt,
    kSPEidtCellAdd,
} SPEidtCellType;

typedef enum : NSUInteger {
    kSPEidtRecordTypeNormal =0,
    SPEidtRecordTypeAdd     =1,
    SPEidtRecordTypeReduce  =2,
    SPEidtRecordTypeSell    =3,
    SPEidtRecordTypeBuy     =4,
} SPEidtRecordType;

@interface SPEditRecordModel : NSObject
@property (nonatomic, strong) NSString *stockName;
@property (nonatomic, strong) NSString *stockCode;
// 操作：0表示持有（不变）1表示增持、2表示减持 3表示卖出 4表示买入
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *ratio;

// 页面逻辑数据
@property (nonatomic, assign) NSInteger cellType;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
