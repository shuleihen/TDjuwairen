//
//  StockUnlockModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/2.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockUnlockModel : NSObject
@property (nonatomic, copy) NSString *stockCode;
@property (nonatomic, copy) NSString *stockName;
@property (nonatomic, copy) NSString *vipDesc;
@property (nonatomic, assign) BOOL isUnlock;
@property (nonatomic, assign) NSInteger userKeyNum;
@property (nonatomic, assign) NSInteger unlockKeyNum;
@property (nonatomic, copy) NSString *deepId;
@property (nonatomic, assign) NSInteger deepPayType;
@property (nonatomic, copy) NSString *deepPayTip;
@end
