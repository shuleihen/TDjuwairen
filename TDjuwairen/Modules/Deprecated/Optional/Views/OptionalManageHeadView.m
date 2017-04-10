//
//  OptionalManageHeadView.m
//  TDjuwairen
//
//  Created by 团大 on 2016/12/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//
#define LabelHeight 45
#define LabelWidth 80
#define font15 [UIFont systemFontOfSize:15]

#import "OptionalManageHeadView.h"

#import "UIdaynightModel.h"

@implementation OptionalManageHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIdaynightModel *daynightModel = [UIdaynightModel sharedInstance];
        self.backgroundColor = daynightModel.navigationColor;
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, LabelWidth, LabelHeight)];
        nameLab.font = font15;
        nameLab.text = @"股票名称";
        nameLab.textColor = daynightModel.titleColor;
        nameLab.textAlignment = NSTextAlignmentLeft;
    
        CGFloat space = kScreenWidth/25*3;
        UILabel *topLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-80-15-space-80, 0, LabelWidth, LabelHeight)];
        topLab.font = font15;
        topLab.text = @"置顶";
        topLab.textColor = daynightModel.titleColor;
        topLab.textAlignment = NSTextAlignmentRight;
        
        UILabel *sortingLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-80-15, 0, LabelWidth, LabelHeight)];
        sortingLab.font = font15;
        sortingLab.text = @"拖动顺序";
        sortingLab.textColor = daynightModel.titleColor;
        sortingLab.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:nameLab];
        [self addSubview:topLab];
        [self addSubview:sortingLab];
    }
    return self;
}

@end
