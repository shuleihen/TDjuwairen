//
//  VideoDetailBottomToolView.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "VideoDetailBottomToolView.h"

@implementation VideoDetailBottomToolView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 7, kScreenWidth-24-30-10, 30)];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _commentBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_commentBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#666666"] forState:UIControlStateNormal];
        [_commentBtn setTitle:@"快来发表评论吧" forState:UIControlStateNormal];
        _commentBtn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f8f8f8"];
        _commentBtn.layer.borderWidth = TDPixel;
        _commentBtn.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#DFDFDF"].CGColor;
        [self addSubview:_commentBtn];
        
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-12-30, 7, 30, 30)];
        [_shareBtn setImage:[UIImage imageNamed:@"tab_share.png"] forState:UIControlStateNormal];
        [self addSubview:_shareBtn];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}



@end
