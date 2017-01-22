//
//  NiuxiongSectionHeaderView.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "NiuxiongSectionHeaderView.h"
#import "HexColors.h"

@interface NiuxiongSectionHeaderView ()
@property (nonatomic, strong) UIButton *niuBtn;
@property (nonatomic, strong) UIButton *xiongBtn;
@property (nonatomic, strong) UIView *indicator;
@end

@implementation NiuxiongSectionHeaderView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _niuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _niuBtn.frame = CGRectMake(0, 10, kScreenWidth/2, 30);
        _niuBtn.tag = 1;
        _niuBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _niuBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_niuBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#e83c3d"] forState:UIControlStateNormal];
        [_niuBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#e83c3d"] forState:UIControlStateHighlighted];
        [_niuBtn setImage:[UIImage imageNamed:@"icon_bull.png"] forState:UIControlStateNormal];
        [_niuBtn setImage:[UIImage imageNamed:@"icon_bull.png"] forState:UIControlStateHighlighted];
        [_niuBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_niuBtn];
        
        _xiongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _xiongBtn.frame = CGRectMake(kScreenWidth/2, 10, kScreenWidth/2, 30);
        _xiongBtn.tag = 2;
        _xiongBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _xiongBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_xiongBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#1bce8d"] forState:UIControlStateNormal];
        [_xiongBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#1bce8d"] forState:UIControlStateHighlighted];
        [_xiongBtn setImage:[UIImage imageNamed:@"icon_bear.png"] forState:UIControlStateNormal];
        [_xiongBtn setImage:[UIImage imageNamed:@"icon_bear.png"] forState:UIControlStateHighlighted];
        [_xiongBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_xiongBtn];

        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreenWidth, 1)];
        sep.backgroundColor = TDSeparatorColor;
        [self addSubview:sep];
        
        _indicator = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreenWidth/2, 1)];
        _indicator.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#e83c3d"];
        [self addSubview:_indicator];
    }
    return self;
}

- (void)buttonPressed:(UIButton *)sender {
    
    if (self.buttonBlock) {
        self.buttonBlock(sender.tag);
    }
}

- (void)setIsNiu:(BOOL)isNiu {
    _isNiu = isNiu;
    
    if (isNiu) {
        self.indicator.frame = CGRectMake(0, 49, kScreenWidth/2, 1);
        self.indicator.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#e83c3d"];
    } else {
        self.indicator.frame = CGRectMake(kScreenWidth/2, 49, kScreenWidth/2, 1);
        self.indicator.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#1bce8d"];
    }
}

- (void)setupXiong:(NSInteger)xiongCount niu:(NSInteger)niuCount {
    
    NSString *niuTitle;
    NSString *xiongTitle;
    
    if (xiongCount <= 0) {
        xiongTitle = @"0%";
    } else {
        xiongTitle = [NSString stringWithFormat:@"熊说(%.0lf%%)",(float)xiongCount/(xiongCount+niuCount)*100];
    }
    
    if (niuCount <= 0) {
        niuTitle = @"0%";
    } else {
        niuTitle = [NSString stringWithFormat:@"牛说(%.0lf%%)",(float)niuCount/(xiongCount+niuCount)*100];
    }
    
    [self.niuBtn setTitle:niuTitle forState:UIControlStateNormal];
    [self.niuBtn setTitle:niuTitle forState:UIControlStateHighlighted];
    [self.xiongBtn setTitle:xiongTitle forState:UIControlStateNormal];
    [self.xiongBtn setTitle:xiongTitle forState:UIControlStateHighlighted];
}
@end
