//
//  StockPoolListToolView.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolListToolView.h"

@implementation StockPoolListToolView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, TDPixel)];
        sep.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#cccccc"];
        [self addSubview:sep];
        
        UIButton *setting = [[UIButton alloc] init];
        [setting setImage:[UIImage imageNamed:@"sp_setting.png"] forState:UIControlStateNormal];
        setting.frame = CGRectMake(15, (frame.size.height-30)/2, 30, 30);
        [setting addTarget:self action:@selector(settingPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:setting];
        
        UIButton *draft = [[UIButton alloc] init];
        [draft setImage:[UIImage imageNamed:@"sp_drafts.png"] forState:UIControlStateNormal];
        draft.frame = CGRectMake(60, (frame.size.height-30)/2, 30, 30);
        [draft addTarget:self action:@selector(draftPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:draft];
        
        UIButton *add = [[UIButton alloc] init];
        [add setImage:[UIImage imageNamed:@"tab_release.png"] forState:UIControlStateNormal];
        add.frame = CGRectMake((frame.size.width-44)/2, (frame.size.height-44)/2, 44, 44);
        [add addTarget:self action:@selector(publishPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:add];
        
        UIButton *attention = [[UIButton alloc] init];
        [attention setImage:[UIImage imageNamed:@"sp_user.png"] forState:UIControlStateNormal];
        attention.frame = CGRectMake(frame.size.width-45, (frame.size.height-30)/2, 30, 30);
        [attention addTarget:self action:@selector(attentionPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:attention];
    }
    return self;
}

- (void)settingPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingPressed:)]) {
        [self.delegate settingPressed:sender];
    }
}

- (void)draftPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(draftPressed:)]) {
        [self.delegate draftPressed:sender];
    }
}

- (void)publishPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(publishPressed:)]) {
        [self.delegate publishPressed:sender];
    }
}

- (void)attentionPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(attentionPressed:)]) {
        [self.delegate attentionPressed:sender];
    }
}
@end
