//
//  YXTitleButton.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "YXSearchButton.h"
#import "HexColors.h"

@implementation YXSearchButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = 3.0f;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 11, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 0);
    
//    self.frame = CGRectMake(58, 7, [UIScreen mainScreen].bounds.size.width-105, 30);
    
    [self setImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateHighlighted];
    
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self setTitle:@"关键字/股票代码" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#999999"] forState:UIControlStateNormal];
}
@end
