//
//  AliveListSectionHeaderView.m
//  TDjuwairen
//
//  Created by zdy on 2017/4/26.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListSectionHeaderView.h"
#import "HexColors.h"

@implementation AliveListSectionHeaderView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, (frame.size.height-20)/2, 40, 20)];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        label.text = @"公开";
        [self addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-12-20, (frame.size.height-20)/2, 20, 20)];
        [button setImage:[UIImage imageNamed:@"icon_arrow_down.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deletePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TDPixel)];
        sep.backgroundColor = TDSeparatorColor;
        [self addSubview:sep];
    }
    
    return self;
}


- (void)deletePressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(alivelistSectionHeaderView:deletePressed:)]) {
        [self.delegate alivelistSectionHeaderView:self deletePressed:sender];
    }
}
@end
