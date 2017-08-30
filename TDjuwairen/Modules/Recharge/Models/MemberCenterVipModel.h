//
//  MemberCenterVipModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/29.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberCenterVipModel : NSObject
@property (nonatomic, copy) NSString *vipId;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSNumber *keyNum;
@property (nonatomic, copy) NSNumber *pointsNum;
@property (nonatomic, copy) NSNumber *price;
@property (nonatomic, copy) NSString *validTime;

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSString *)levelString;
@end
