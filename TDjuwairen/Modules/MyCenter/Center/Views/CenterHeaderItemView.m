//
//  CenterHeaderItemView.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "CenterHeaderItemView.h"

@implementation CenterHeaderItemView


- (void)setupNumber:(NSInteger)number {
    NSString *numberString = [NSString stringWithFormat:@"%ld",(long)number];
    self.numberLabel.text = numberString;
}

@end
