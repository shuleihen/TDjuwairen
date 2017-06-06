//
//  StockSurveyAnnounceModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/4/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockAnnounceModel : NSObject
@property (nonatomic, strong) NSString *announceId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *dateTime;

- (id)initWithDict:(NSDictionary *)dict;
@end
