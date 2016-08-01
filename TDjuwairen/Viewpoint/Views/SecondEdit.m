//
//  SecondEdit.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/1.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#define space

#import "SecondEdit.h"

@interface SecondEdit ()

@property (nonatomic,strong) NSArray *imgArr;
@property (nonatomic,strong) NSArray *selectImgArr;

@end

@implementation SecondEdit

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imgArr = @[@"tab_jiacu@3x.png",
                        @"tab_xieti@3x.png",
                        @"tab_xiahuaxian@3x.png",
                        @"tab_yingyong@3x.png",
                        @"tab_h1@3x.png",
                        @"tab_h2@3x.png",
                        @"tab_h3@3x.png",
                        @"tab_h4@3x.png",
                        @"tab_h5@3x.png"
                        ];
        self.selectImgArr = @[@"tab_jiacu_pre@3x.png",
                              @"tab_xieti_pre@3x.png",
                              @"tab_xiahuaxian_pre@3x.png",
                              @"tab_yinyong_pre@3x.png",
                              @"tab_h1_pre@3x.png",
                              @"tab_h2_pre@3x.png",
                              @"tab_h3_pre@3x.png",
                              @"tab_h4_pre@3x.png",
                              @"tab_h5_pre@3x.png"
                              ];
        for (int i = 0; i<self.imgArr.count; i++) {
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/self.imgArr.count*i, 5, kScreenWidth/self.imgArr.count, 30)];
            [btn setImage:[UIImage imageNamed:self.imgArr[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:self.selectImgArr[i]] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            
            [self addSubview:btn];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andImgArr:(NSArray *)imgArr andTextArr:(NSArray *)textArr
{
    if (self = [super initWithFrame:frame]) {
        for (int i = 0; i<imgArr.count; i++) {
            LeftRightBtn *btn = [[LeftRightBtn alloc]initWithFrame:CGRectMake(kScreenWidth/imgArr.count*i, 5, kScreenWidth/imgArr.count, 40) withImg:imgArr[i] andText:textArr[i]];
            [btn addTarget:self action:@selector(clickSecBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)selectFont:(UIButton *)sender{
    if (sender.tag > 2) {
        self.selectBtn.selected = NO;
        sender.selected = YES;
        self.selectBtn = sender;
    }
    else
    {
        if (sender.selected == YES) {
            sender.selected = NO;
        }
        else
        {
            sender.selected = YES;
        }
    }
    if ([self respondsToSelector:@selector(selectFont:)]) {
        [self.delegate selectFont:sender];
    }
}

- (void)clickSecBtn:(LeftRightBtn *)sender{
    if ([self respondsToSelector:@selector(clickSecBtn:)]) {
        [self.delegate clickSecBtn:sender];
    }
}

@end
