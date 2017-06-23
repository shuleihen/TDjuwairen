//
//  AliveDetailSegmentControl.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveDetailSegmentView.h"
#import "HexColors.h"

#define kAliveDetailSegmentWidth 70

@implementation AliveDetailSegmentView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *one = [self segmentBtn];
        one.tag = 100;
        one.frame = CGRectMake(12, 0, kAliveDetailSegmentWidth, CGRectGetHeight(frame));
        [one setTitle:@"评论" forState:UIControlStateNormal];
        [self addSubview:one];
        
        UIButton *two = [self segmentBtn];
        two.tag = 101;
        two.frame = CGRectMake(12+kAliveDetailSegmentWidth+10, 0, kAliveDetailSegmentWidth, CGRectGetHeight(frame));
        [two setTitle:@"点赞" forState:UIControlStateNormal];
        [self addSubview:two];
        
        UIButton *three = [self segmentBtn];
        three.tag = 102;
        three.frame = CGRectMake(frame.size.width-kAliveDetailSegmentWidth-12, 0, kAliveDetailSegmentWidth, CGRectGetHeight(frame));
        [three setTitle:@"分享" forState:UIControlStateNormal];
        [self addSubview:three];
        
        UIView *sep1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, TDPixel)];
        sep1.backgroundColor = TDSeparatorColor;
        [self addSubview:sep1];
        
        UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-TDPixel, frame.size.width, TDPixel)];
        sep2.backgroundColor = TDSeparatorColor;
        [self addSubview:sep2];
        
        one.selected = YES;
        
        _arrow = [[UIView alloc] initWithFrame:CGRectMake(12, frame.size.height-3, kAliveDetailSegmentWidth, 3)];
        _arrow.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#3371E2"];
        [self addSubview:_arrow];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UIButton *)segmentBtn {
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#999999"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#3371E2"] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#3371E2"] forState:UIControlStateSelected];
    
    [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}


- (void)buttonPressed:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    
    UIButton *one = [self viewWithTag:100];
    UIButton *two = [self viewWithTag:101];
    UIButton *three = [self viewWithTag:102];
    
    one.selected = (index==0);
    two.selected = (index==1);
    three.selected = (index==2);
    
    if (index == 0) {
        [UIView animateWithDuration:0.4 animations:^{
            self.arrow.frame = CGRectMake(12, CGRectGetHeight(self.frame)-3, kAliveDetailSegmentWidth, 3);
        }];
        
    } else if (index == 1) {
        [UIView animateWithDuration:0.4 animations:^{
            self.arrow.frame = CGRectMake(12+kAliveDetailSegmentWidth+10, CGRectGetHeight(self.frame)-3, kAliveDetailSegmentWidth, 3);
        }];
    } else if (index == 2) {
        [UIView animateWithDuration:0.4 animations:^{
            self.arrow.frame = CGRectMake(CGRectGetWidth(self.frame)-kAliveDetailSegmentWidth-12, CGRectGetHeight(self.frame)-3, kAliveDetailSegmentWidth, 3);
        }];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithIndex:)]) {
        [self.delegate didSelectedWithIndex:index];
    }
}
@end
