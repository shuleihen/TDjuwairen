//
//  SurDetailSelBtnView.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurDetailSelBtnView.h"

@implementation SurDetailSelBtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        for (int i = 0; i<6; i++) {
            NSArray *norArr = @[@"btn_shidi_nor",
                                @"btn_duihua_nor",
                                @"btn_niuxiong_nor",
                                @"btn_redian_nor",
                                @"btn_chanpin_nor",
                                @"btn_wenda_nor"];
            
            NSArray *selArr = @[@"btn_shidi_select",
                                @"btn_duihua_select",
                                @"btn_niuxiong_select",
                                @"btn_redian_select",
                                @"btn_chanpin_select",
                                @"btn_wenda_select"];
            
            NSArray *titArr = @[@"实地篇",@"对话录",@"牛熊说",@"热点篇",@"产品篇",@"问答篇"];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/6*i, 0, kScreenWidth/6, 60)];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:titArr[i] forState:UIControlStateNormal];
            [btn setTitle:titArr[i] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            
            [btn setImage:[UIImage imageNamed:norArr[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:selArr[i]] forState:UIControlStateSelected];

            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.bounds.size.height+8,-btn.imageView.bounds.size.width, 0.0,0.0)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, btn.titleLabel.bounds.size.height+8, -btn.titleLabel.bounds.size.width)];
        
            [btn addTarget:self action:@selector(selectWithDetail:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)selectWithDetail:(UIButton *)sender{
    self.selBtn.selected = NO;
    sender.selected = YES;
    self.selBtn = sender;
    if ([self.delegate respondsToSelector:@selector(selectWithDetail:)]) {
        [self.delegate selectWithDetail:sender];
    }
}

@end
