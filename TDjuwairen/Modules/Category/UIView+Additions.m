//
//  NSObject+Additions.m
//  TDjuwairen
//
//  Created by deng shu on 2017/3/15.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)


-(UIViewController *)viewController
{
    UIResponder *next=[self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)next;
        }
        next=[next nextResponder];
    } while (next!=nil);
    return nil;
    
}
@end
