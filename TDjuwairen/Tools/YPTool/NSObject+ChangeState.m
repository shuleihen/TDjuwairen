//
//  NSObject+ChangeState.m
//  LiChuan
//

//  Copyright (c) 2015年 zhanshu. All rights reserved.
//

#import "NSObject+ChangeState.h"
#import "HexColors.h"
@implementation NSObject (ChangeState)
-(NSString*)safeString
{
    if ([self isKindOfClass:[NSNull class]] || self==nil) {
        return @"";
    }else
        return (NSString*)self;
}
-(NSString *)changeToZero
{
    if ([self isKindOfClass:[NSNull class]]) {
        return @"0";
    }else
        return (NSString*)self;
}
-(NSString *)changeToZeroB
{
    if ([self isKindOfClass:[NSNull class]]) {
        return @"0%";
    }else
        return (NSString*)self;
}
void AddLineAtBottom (UIView *addView) {
    CALayer *layer = [CALayer new];
    layer.bounds = CGRectMake(0, addView.frame.size.height-1, kScreenWidth, .5);
    layer.position = CGPointMake(kScreenWidth/2, addView.frame.size.height-1);
    layer.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#272a31"].CGColor;
    [addView.layer addSublayer:layer];
}
@end
