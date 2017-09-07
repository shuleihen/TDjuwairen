//
//  NSString+Util.m
//  baiwandian
//
//  Created by zdy on 15/10/8.
//  Copyright © 2015年 xinyunlian. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Util)

- (NSString *)userBigAvatar {
    NSString *bigface = [self stringByReplacingOccurrencesOfString:@"_70" withString:@"_200"];
    return bigface;
}

- (NSString *)stockCode {
    // 去掉 上证sh，创业 sz
    NSString *code = [self stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
    return code;
}

- (NSString *)queryStockCode {
    if (self.length < 1) {
        return self;
    }
    
    NSString *code = [self substringWithRange:NSMakeRange(0, 1)];
    
    NSString *companyCode ;
    if ([code isEqualToString:@"6"]) {
        companyCode = [NSString stringWithFormat:@"sh%@",self];
    }
    else
    {
        companyCode = [NSString stringWithFormat:@"sz%@",self];
    }
    return companyCode;
}

- (NSString *)md5
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    __autoreleasing NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

- (NSString *)URLEncode
{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[self mutableCopy], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8));
}

- (NSData*)hexToBytes
{
    __autoreleasing NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= self.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

- (NSString *)truncateByWordWithLimit:(NSInteger)limit
{
    
    if (self.length <= limit - 1) {
        return self;
    }
    
    return [[self substringToIndex:limit - 1] stringByAppendingString:@"..."];
}

- (NSString *)cutStringWithLimit:(NSInteger)limit {
    if (self.length <= limit) {
        return self;
    }
    
    return [self substringToIndex:limit];
}
- (NSUInteger)getBytesLength
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self lengthOfBytesUsingEncoding:enc];
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isValidateStockCode {
    if (self.length == 0) {
        return NO;
    }
    
    NSString *phoneRegex = @"^[0-9]{6}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (BOOL)isValidateMobile
{
    if (self.length == 0) {
        return NO;
    }
    
    NSString *phoneRegex = @"^1[3458]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (BOOL)isValidateNumber
{
    NSString *regex = @"^[0123456789.]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
    
}

- (BOOL)isValidateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidateNickName
{
    // 有中英文、数字、"_"、"-"
    NSString *regex = @"[\u4e00-\u9fa5]*[a-zA-Z0-9]*[_-]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isValidatePassword {
    // 英文和数字 6-20
    NSString *regex = @"[a-zA-Z0-9]{6,20}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

+ (NSString *)stringWithTimeInterval:(int64_t)timeInterval
{
    return [NSString stringWithTimeInterval:timeInterval withFormat:@"YYYY-MM-dd"];
}

+ (NSString *)stringWithTimeInterval:(int64_t)timeInterval withFormat:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

+ (NSString *)intervalNowDateWithDateInterval:(NSTimeInterval)endTime {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval cha = ((endTime-now)>0)?(endTime-now):0;
    
    NSString *sen = [NSString stringWithFormat:@"%02d", (int)cha%60];
    NSString *min = [NSString stringWithFormat:@"%02d", (int)cha/60%60];
    NSString *house = [NSString stringWithFormat:@"%02d", (int)cha/3600];
    
    return [NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
}
@end
