//
//  OptionalHeadView.m
//  TDjuwairen
//
//  Created by 团大 on 2016/12/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//
#define LabelHeight 45
#define btnWidth kScreenWidth/3*2/3
#define font15 [UIFont systemFontOfSize:15]

#import "OptionalHeadView.h"

@interface OptionalHeadView ()

@property (nonatomic,strong) UILabel *nameLab;

@end

@implementation OptionalHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth/3-15, LabelHeight)];
        self.nameLab.font = font15;
        self.nameLab.text = @"股票名称";
        self.nameLab.textColor = [UIColor hx_colorWithHexRGBAString:@"#646464"];
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.nameLab];
        
        NSArray *arr = @[@"最新",@"涨幅",@"涨跌"];
        
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/3 + i*kScreenWidth/9*2, 0, btnWidth, LabelHeight)];
            btn.titleLabel.font = font15;
            [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#646464"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#646464"] forState:UIControlStateHighlighted];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            /*
            if (i == 0) {
                [btn setImage:[UIImage imageNamed:@"btn_down"] forState:UIControlStateNormal];
            }
            
            CGFloat spacing = 5.0;

            CGSize imageSize = btn.imageView.frame.size;
            btn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);

            CGSize titleSize = btn.titleLabel.frame.size;
            btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
            */
            [self addSubview:btn];
        }
    }
    return self;
}


@end
