//
//  SurveyBottomToolView.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyBottomToolView.h"
#import "HexColors.h"

@interface SurveyBottomToolView ()
@property (nonatomic, strong) UIButton *button;
@end

@implementation SurveyBottomToolView
@synthesize  tag = _tag;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *sep = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        sep.image = [UIImage imageNamed:@"slipLine.png"];
        [self addSubview:sep];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font  = [UIFont systemFontOfSize:17.0f];
        _button.frame = CGRectMake(15, 10, kScreenWidth-30, 30);
        [_button setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#1b69b1"] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#1b69b1"] forState:UIControlStateHighlighted];
        [_button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self addSubview:_button];
    }
    
    return self;
}

- (void)setTag:(NSInteger)tag {
    _tag = tag;
    
    if (tag == 2) {
        // 熊牛
        [self.button setTitle:@"评论" forState:UIControlStateNormal];
        [self.button setTitle:@"评论" forState:UIControlStateHighlighted];
        [self.button setImage:[UIImage imageNamed:@"comment_blue.png"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"comment_blue.png"] forState:UIControlStateHighlighted];
    } else if (tag == 5) {
        // 问答
        [self.button setTitle:@"提问" forState:UIControlStateNormal];
        [self.button setTitle:@"提问" forState:UIControlStateHighlighted];
        [self.button setImage:[UIImage imageNamed:@"tiwen.png"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"tiwen.png"] forState:UIControlStateHighlighted];
    }
}

- (void)buttonPressed:(id)sender {
    if (self.buttonBlock) {
        self.buttonBlock(self.tag);
    }
}
@end
