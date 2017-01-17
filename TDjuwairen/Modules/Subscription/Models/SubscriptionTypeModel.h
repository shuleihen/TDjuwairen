//
//  SubscriptionTypeModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscriptionTypeModel : NSObject
@property (nonatomic, assign) NSInteger subType;
@property (nonatomic, assign) NSInteger keyNum;
@property (nonatomic, strong) NSString *subDesc;

- (id)initWithDict:(NSDictionary *)dict;
@end
