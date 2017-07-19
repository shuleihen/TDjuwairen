//
//  AliveListAdExtra.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListAdExtra.h"

@implementation AliveListAdExtra
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.linkUrl = dict[@"link_url"];
        self.linkType = [dict[@"link_type"] integerValue];
    }
    
    return self;
}
@end
