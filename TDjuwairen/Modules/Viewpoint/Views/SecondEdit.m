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
        self.imgArr = @[@"tab_jiacu.png",
                        @"tab_xieti.png",
                        @"tab_xiahuaxian.png",
                        @"tab_yingyong.png",
                        ];
        self.selectImgArr = @[@"tab_jiacu_pre.png",
                              @"tab_xieti_pre.png",
                              @"tab_xiahuaxian_pre.png",
                              @"tab_yinyong_pre.png",
                              ];
        for (int i = 0; i<self.imgArr.count; i++) {
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/9*i, 5, kScreenWidth/9, 30)];
            [btn setImage:[UIImage imageNamed:self.imgArr[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:self.selectImgArr[i]] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            
            [self addSubview:btn];
        }
        
        UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(kScreenWidth/9*4, 5, kScreenWidth/9*4, 30)];
        slider.minimumValue = 14;
        slider.maximumValue = 22;
        slider.value = 16;
        [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:slider];
        
        self.fontLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/9*8, 5, kScreenWidth/9, 30)];
        self.fontLab.font = [UIFont systemFontOfSize:16];
        self.fontLab.textAlignment = NSTextAlignmentCenter;
        self.fontLab.text = @"16";//默认16号字
        [self addSubview:self.fontLab];
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

- (void)sliderAction:(UISlider *)slider{
    if ([self.delegate respondsToSelector:@selector(sliderAction:)]) {
        [self.delegate sliderAction:slider];
    }
}


- (void)clickSecBtn:(LeftRightBtn *)sender{
    if ([self respondsToSelector:@selector(clickSecBtn:)]) {
        [self.delegate clickSecBtn:sender];
    }
}

@end
