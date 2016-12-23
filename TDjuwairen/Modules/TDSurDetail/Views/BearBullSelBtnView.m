//
//  BearBullSelBtnView.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/9.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#define bullColor [HXColor hx_colorWithHexRGBAString:@"#E83C3D"]
#define bearColor [HXColor hx_colorWithHexRGBAString:@"#1BCE8D"]

#import "BearBullSelBtnView.h"

#import "Masonry.h"
#import "HexColors.h"

@implementation BearBullSelBtnView

- (instancetype)initWithFrame:(CGRect)frame andRatio:(CGFloat)bullRadio
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupWithUIWithBearRadio:bullRadio];
    }
    return self;
}

- (void)setupWithUIWithBearRadio:(CGFloat)bullRadio{
    CGFloat bearRadio = 1 - bullRadio;
    
    NSString *bull = [NSString stringWithFormat:@" 牛说(%.0f%@)",bullRadio * 100,@"%"];
    NSString *bear = [NSString stringWithFormat:@" 熊说(%.0f%@)",bearRadio * 100,@"%"];
    
    self.bullBtn = [[UIButton alloc] init];
    [self.bullBtn setImage:[UIImage imageNamed:@"icon_bull.png"] forState:UIControlStateNormal];
    [self.bullBtn setTitle:bull forState:UIControlStateNormal];
    [self.bullBtn setTitleColor:bullColor forState:UIControlStateNormal];
    self.bullBtn.tag = 1;
    
    self.bearBtn = [[UIButton alloc] init];
    [self.bearBtn setImage:[UIImage imageNamed:@"icon_bear.png"] forState:UIControlStateNormal];
    [self.bearBtn setTitle:bear forState:UIControlStateNormal];
    [self.bearBtn setTitleColor:bearColor forState:UIControlStateNormal];
    self.bearBtn.tag = 0;
    
    [self addSubview:self.bullBtn];
    [self addSubview:self.bearBtn];
    
    [self.bullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(-1);
        make.bottom.equalTo(self).with.offset(0);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    
    [self.bearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(1);
        make.bottom.equalTo(self).with.offset(0);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    
    [self.bullBtn addTarget:self action:@selector(selBearBull:) forControlEvents:UIControlEventTouchUpInside];
    [self.bearBtn addTarget:self action:@selector(selBearBull:)forControlEvents:UIControlEventTouchUpInside];
}

- (void)selBearBull:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(selBearBull:)]) {
        [self.delegate selBearBull:sender];
    }
}

@end
