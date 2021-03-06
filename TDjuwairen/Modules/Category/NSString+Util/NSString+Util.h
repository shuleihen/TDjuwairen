//
//  NSString+Util.h
//  baiwandian
//
//  Created by zdy on 15/10/8.
//  Copyright © 2015年 xinyunlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

- (NSString *)URLEncode;
- (NSData*)hexToBytes;
- (NSString *)cutStringWithLimit:(NSInteger)limit;
- (NSString *)truncateByWordWithLimit:(NSInteger)limit;
- (NSUInteger)getBytesLength;

- (NSString *)md5;
- (NSString *)trim;
- (NSString *)stockCode;
- (NSString *)queryStockCode;
- (NSString *)userBigAvatar;

- (BOOL)isValidateMobile;
- (BOOL)isValidateNumber;
- (BOOL)isValidateEmail;
- (BOOL)isValidateNickName;
- (BOOL)isValidatePassword;
- (BOOL)isValidateStockCode;

+ (NSString *)stringWithTimeInterval:(int64_t)timeInterval;
+ (NSString *)stringWithTimeInterval:(int64_t)timeInterval withFormat:(NSString *)format;
+ (NSString *)intervalNowDateWithDateInterval:(NSTimeInterval)endTime;

@end
