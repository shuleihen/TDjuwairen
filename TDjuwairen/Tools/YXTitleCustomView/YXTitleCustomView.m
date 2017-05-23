//
//  YXTitleCustomView.m
//  TDjuwairen
//
//  Created by zdy on 2017/5/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "YXTitleCustomView.h"

@implementation YXTitleCustomView


- (void)setFrame:(CGRect)frame {
    CGRect f = CGRectMake(0, frame.origin.y, kScreenWidth, frame.size.height);
    
    [super setFrame:f];
}

@end
