//
//  TDAdvertModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/18.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDAdvertModel.h"

@implementation TDAdvertModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.adType = [dict[@"ad_link_type"] integerValue];
        self.adUrl = dict[@"ad_link"];
        self.adImageUrl = dict[@"ad_imgurl"];
        self.adTitle = dict[@"ad_title"];
    }
    return self;
}
@end
