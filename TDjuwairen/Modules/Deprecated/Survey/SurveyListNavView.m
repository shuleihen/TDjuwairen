//
//  SurveyListNavView.m
//  TDjuwairen
//
//  Created by 团大 on 16/10/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyListNavView.h"

@implementation SurveyListNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.headImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 27, 30, 30)];
        self.headImgBtn.layer.cornerRadius = 15;
        self.headImgBtn.clipsToBounds = YES;
        
        CGFloat searchWidth = kScreenWidth-(15+15+30)*2;
        self.searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(15+30+15, 27, searchWidth, 30)];
        self.searchBtn.layer.cornerRadius = 5;//圆角
        self.searchBtn.layer.borderWidth = 0.5;//线宽
        [self.searchBtn setTitle:@"关键字/股票代码" forState:UIControlStateNormal];
        [self.searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.searchBtn setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
        [self.searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -(searchWidth/2-30), 0, 0)];
        [self.searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(searchWidth/2-30)+15, 0, 0)];
        
        self.messageBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-15-30, 27, 30, 30)];
        
        [self addSubview:self.headImgBtn];
        [self addSubview:self.searchBtn];
        [self addSubview:self.messageBtn];
    }
    return self;
}

@end
