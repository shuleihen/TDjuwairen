//
//  SelOrderBtnView.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SelOrderBtnView.h"

#import "HexColors.h"

@implementation SelOrderBtnView

- (instancetype)initWithFrame:(CGRect)frame withArr:(NSArray *)arr
{
    if (self = [super initWithFrame:frame]) {
        self.btnsArr = [NSMutableArray array];
        
        [self createWithArr:arr];
    }
    return self;
}

- (void) createWithArr:(NSArray *)arr{
    for (int i = 0 ; i <arr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i* (kScreenWidth/arr.count), 0, kScreenWidth/arr.count, 44)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[HXColor hx_colorWithHexRGBAString:@"#646464"] forState:UIControlStateNormal];
        [btn setTitleColor:[HXColor hx_colorWithHexRGBAString:@"#1B69B1"] forState:UIControlStateSelected];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.selected = YES;
            self.selectBtn = btn;
        }
        [self.btnsArr addObject:btn];
        [self addSubview:btn];
    }
}

- (void)clickBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(selectOrder:)]){
        [self.delegate selectOrder:sender];
    }
}

@end
