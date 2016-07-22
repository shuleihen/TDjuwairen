//
//  ButtonView.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ButtonView.h"

@implementation ButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //
        self.backgroundColor = [UIColor whiteColor];
        self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-17)/2, 15, 17, 17)];
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, 20)];
        self.label.font = [UIFont systemFontOfSize:15];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.imageview];
        [self addSubview:self.label];
        
    }
    return self;
}

@end
