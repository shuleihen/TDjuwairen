//
//  PhoneNumHold.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/25.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PhoneNumHold.h"
#import "NSString+Ext.h"

@implementation PhoneNumHold

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, frame.size.width-30, 200)];
        NSString *text = @"该手机号码已被注册,如果这是您本人的，可点击确定继续发送。完成信息补全后，我们将注销被占用的账号，并将数据转移至当前账号。如果有问题请联系客服。";
        
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        label.font = font;
        label.numberOfLines = 0;
        CGSize titlesize = CGSizeMake(frame.size.width-30, 20000.0f);
        titlesize = [text calculateSize:titlesize font:font];
        label.text = text;
        [label setFrame:CGRectMake(15, 15, frame.size.width-30, titlesize.height)];
        
        UIButton *sure = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-15-40-10-40, frame.size.height-15-20, 40, 20)];
        [sure setTitle:@"确定" forState:UIControlStateNormal];
        [sure setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateNormal];
        [sure addTarget:self action:@selector(phoneSure:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *clean = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-15-40, frame.size.height-15-20, 40, 20)];
        [clean setTitle:@"取消" forState:UIControlStateNormal];
        [clean setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [clean addTarget:self action:@selector(phoneClean:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:label];
        [self addSubview:sure];
        [self addSubview:clean];

    }
    return self;
}

- (void)phoneSure:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(phoneSure:)]) {
        [self.delegate phoneSure:sender];
    }
}

- (void)phoneClean:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(phoneClean:)]) {
        [self.delegate phoneClean:sender];
    }
}

@end