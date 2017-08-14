//
//  WalletRecordModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntegralRecordModel : NSObject
@property (nonatomic, strong) NSString *recordId;
@property (nonatomic, strong) NSString *moth;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger integral;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
