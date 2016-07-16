//
//  NSString+TimeInfo.h
//  TDjuwairen
//
//  Created by 团大 on 16/5/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeInfo)
//+(NSString *)setLabelsTime:(NSInteger)time;
+ (NSString *)prettyDateWithReference:(NSString  *)referenceStr;
@end
