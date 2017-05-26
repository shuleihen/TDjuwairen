//
//  StockShareView.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockShareView.h"
#import "HexColors.h"
#import "UIButton+Align.h"

@interface StockShareView ()
@property (nonatomic, strong) UIView *panelView;
@end

@implementation StockShareView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        self.panelView.frame = CGRectMake(0, -81, kScreenWidth, 81);
        [self addSubview:self.panelView];
    }
    return self;
}

- (UIView *)panelView {
    if (!_panelView) {
        _panelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 81)];
        _panelView.backgroundColor = [UIColor whiteColor];
        
        CGFloat margin = (kScreenWidth-46*3)/4;
        UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
        share.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [share setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#666666"] forState:UIControlStateNormal];
        [share setImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
        [share setTitle:@"分享" forState:UIControlStateNormal];
        share.frame = CGRectMake(margin, 15, 46, 52);
        [share addTarget:self action:@selector(sharePressed:) forControlEvents:UIControlEventTouchUpInside];
        [share align:BAVerticalImage withSpacing:5];
        [_panelView addSubview:share];
        
        
        UIButton *collection = [UIButton buttonWithType:UIButtonTypeCustom];
        collection.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [collection setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#666666"] forState:UIControlStateNormal];
        [collection setImage:[UIImage imageNamed:@"stock_collection.png"] forState:UIControlStateNormal];
        [collection setTitle:@"收藏" forState:UIControlStateNormal];
        collection.frame = CGRectMake(CGRectGetMaxX(share.frame)+margin, 15, 46, 52);
        [collection addTarget:self action:@selector(collectionPressed:) forControlEvents:UIControlEventTouchUpInside];
        [collection align:BAVerticalImage withSpacing:5];
        [_panelView addSubview:collection];
        
        
        UIButton *feedback = [UIButton buttonWithType:UIButtonTypeCustom];
        feedback.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [feedback setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#666666"] forState:UIControlStateNormal];
        [feedback setImage:[UIImage imageNamed:@"icon_feedback.png"] forState:UIControlStateNormal];
        [feedback setTitle:@"反馈" forState:UIControlStateNormal];
        feedback.frame = CGRectMake(CGRectGetMaxX(collection.frame)+margin, 15, 46, 52);
        [feedback addTarget:self action:@selector(feedbackPressed:) forControlEvents:UIControlEventTouchUpInside];
        [feedback align:BAVerticalImage withSpacing:5];
        [_panelView addSubview:feedback];
    }
    return _panelView;
}

- (void)showInContainView:(UIView *)containView {
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7];
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);

    [containView addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.panelView.frame = CGRectMake(0, 0, kScreenWidth, 81);
    } completion:^(BOOL finish){
    
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.panelView.frame = CGRectMake(0, -81, kScreenWidth, 81);
    } completion:^(BOOL finish){
        self.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    }];
}

- (void)sharePressed:(id)sender {
    [self hide];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharePressed)]) {
        [self.delegate sharePressed];
    }
}

- (void)collectionPressed:(id)sender {
    [self hide];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharePressed)]) {
        [self.delegate collectionPressed];
    }
    
}

- (void)feedbackPressed:(id)sender {
    [self hide];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedbackPressed)]) {
        [self.delegate feedbackPressed];
    }
}
@end
