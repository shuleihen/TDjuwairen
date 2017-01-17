//
//  SubscriptionModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscriptionModel : NSObject
@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *way;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *subTitle;

- (id)initWithDict:(NSDictionary *)dict;
@end
