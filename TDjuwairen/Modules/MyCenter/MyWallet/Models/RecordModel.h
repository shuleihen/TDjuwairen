//
//  RecordModel.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject

@property (nonatomic,strong) NSString *record_id;

@property (nonatomic,strong) NSString *record_item;

@property (nonatomic,strong) NSString *record_itemid;

@property (nonatomic,strong) NSString *record_keynum;

@property (nonatomic,strong) NSString *record_time;

@property (nonatomic,strong) NSString *record_type;

+ (RecordModel *)getInstanceWithDic:(NSDictionary *)dic;

@end
