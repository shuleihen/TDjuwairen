//
//  AliveListBottomView.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListBottomView.h"
#import "UIButton+Align.h"

@implementation AliveListBottomView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat itemW = frame.size.width/3;
        CGFloat itemH = frame.size.height;
        
        _shareBtn = [self button];
        _shareBtn.frame = CGRectMake(0, 0, itemW, itemH);
        [_shareBtn setImage:[UIImage imageNamed:@"alive_share.png"] forState:UIControlStateNormal];
        [self addSubview:_shareBtn];
        
        _commentBtn = [self button];
        _commentBtn.frame = CGRectMake(itemW, 0, itemW, itemH);
        [_commentBtn setImage:[UIImage imageNamed:@"alive_comment.png"] forState:UIControlStateNormal];
        [self addSubview:_commentBtn];
        
        _likeBtn = [self button];
        _likeBtn.frame = CGRectMake(itemW*2, 0, itemW, itemH);
        [_likeBtn setImage:[UIImage imageNamed:@"alive_zan.png"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"alive_zan_pressed.png"] forState:UIControlStateSelected];
        [self addSubview:_likeBtn];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TDPixel)];
        sep.backgroundColor = TDSeparatorColor;
        [self addSubview:sep];
    }
    
    return self;
}

- (UIButton *)button {
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#999999"] forState:UIControlStateNormal];
    [btn align:BAHorizontalImage withSpacing:8];
    
    return btn;
}
@end
