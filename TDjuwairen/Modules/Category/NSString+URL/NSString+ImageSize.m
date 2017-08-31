//
//  NSString+ImageSize.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/31.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "NSString+ImageSize.h"

@implementation NSString (ImageSize)
- (CGSize)imageSize {
    
    NSURL *url = [NSURL URLWithString:self];
    if (url == nil) {
        return CGSizeZero;
    }
    
    NSString *query = url.query;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [query componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    
    NSString *value1 = [params objectForKey:@"w"];
    NSString *value2 = [params objectForKey:@"h"];
    if (!value1.length || !value2.length) {
        return CGSizeZero;
    }
    
    return CGSizeMake([value1 integerValue], [value2 integerValue]);
}
@end
