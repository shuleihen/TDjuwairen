//
//  TimeHotComView.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/8.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "TimeHotComView.h"

@implementation TimeHotComView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //
        [self create];
        
    }
    return self;
}

- (void)create{
    self.timeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    self.timeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.timeBtn setTitle:@"时间" forState:UIControlStateNormal];
    [self.timeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    
    self.hotBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, 50, 44)];
    self.hotBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.hotBtn setTitle:@"热门" forState:UIControlStateNormal];
    [self.hotBtn addTarget:self action:@selector(selectHot:) forControlEvents:UIControlEventTouchUpInside];
    
    self.louzhu = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-15-80-40, 0, 40, 44)];
    [self.louzhu setImage:[UIImage imageNamed:@"btn_select.png"] forState:UIControlStateNormal];
    [self.louzhu setImage:[UIImage imageNamed:@"btn_select_pre.png"] forState:UIControlStateSelected];
    self.louzhu.selected = NO;//默认为不看楼主
    [self.louzhu addTarget:self action:@selector(justLouzhu:) forControlEvents:UIControlEventTouchUpInside];
    
    self.just = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-15-80, 0, 80, 44)];
    [self.just setTitle:@"只看作者" forState:UIControlStateNormal];
    self.just.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.just addTarget:self action:@selector(justLouzhu:) forControlEvents:UIControlEventTouchUpInside];
    
    self.line = [[UILabel alloc]initWithFrame:CGRectMake(0, 42, kScreenWidth, 1)];
    self.line.layer.borderWidth = 1;
    
    [self addSubview:self.timeBtn];
    [self addSubview:self.hotBtn];
    [self addSubview:self.louzhu];
    [self addSubview:self.just];
    [self addSubview:self.line];
}

- (void)justLouzhu:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(justLouzhu:)]) {
        [self.delegate justLouzhu:sender];
    }
}

- (void)selectTime:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(selectTime:)]) {
        [self.delegate selectTime:sender];
    }
}

- (void)selectHot:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(selectHot:)]) {
        [self.delegate selectHot:sender];
    }
}

@end
