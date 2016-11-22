//
//  OrderModel.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property (nonatomic,copy) NSString *order_id;
@property (nonatomic,copy) NSString *order_paytypeid;
@property (nonatomic,copy) NSString *order_title;
@property (nonatomic,copy) NSString *order_ptime;
@property (nonatomic,copy) NSString *order_amount;   //金额
@property (nonatomic,copy) NSString *order_paystatus;
@property (nonatomic,copy) NSString *order_detail;
@property (nonatomic,copy) NSString *order_sn;
@property (nonatomic,copy) NSString *order_goodsid;    //数量  为0是表示为VIP
@property (nonatomic,copy) NSString *order_goodstypeid;

+ (OrderModel *)getInstanceFromDic:(NSDictionary *)dic;

@end
