//
//  PlayStockHnadler.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/15.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PlayStockHnadler.h"
#import "PlayStockDefine.h"

@implementation PlayStockHnadler

+ (NSString *)seasonString:(NSInteger)season {
    NSString *string = @"";
    switch (season) {
        case kPSSeasonAM:
            string = @"上午场";
            break;
        case kPSSeasonPM:
            string = @"下午场";
            break;
        default:
            break;
    }
    
    return string;
}


@end
