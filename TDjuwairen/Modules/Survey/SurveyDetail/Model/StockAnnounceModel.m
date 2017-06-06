//
//  StockSurveyAnnounceModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/4/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockAnnounceModel.h"

@implementation StockAnnounceModel
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.source = dict[@"pdf_url"];
        self.title = dict[@"announce_title"];
        self.announceId = dict[@"announce_id"];
        self.dateTime = dict[@"announce_addtime"];
    }
    return self;
}
@end
