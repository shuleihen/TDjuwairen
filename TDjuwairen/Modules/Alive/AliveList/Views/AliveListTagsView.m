//
//  AliveListTagsView.m
//  TDjuwairen
//
//  Created by zdy on 2017/4/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListTagsView.h"
#import "HexColors.h"
#import "UIButton+Align.h"

@implementation AliveListTagsView

- (void)setStockHolderName:(NSString *)stockHolderName {
    _stockHolderName = stockHolderName;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGSize size = [stockHolderName boundingRectWithSize:CGSizeMake(MAXFLOAT, 15.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil].size;
    
    UIButton *label = [[UIButton alloc] init];
    label.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [label setTitleColor:TDThemeColor forState:UIControlStateNormal];
    [label setTitle:stockHolderName forState:UIControlStateNormal];
    [label setImage:[UIImage imageNamed:@"alive_stock.png"] forState:UIControlStateNormal];
    label.tag = 0;
    [label addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:label];
    [label align:BAHorizontalImage withSpacing:10];
    
    label.frame = CGRectMake(0, 0, size.width+30, 24);

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10, 0, 103, 24)];
    [btn setImage:[UIImage imageNamed:@"alive_stockHolder.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"alive_stockHolder.png"] forState:UIControlStateDisabled];
    btn.enabled = NO;
    [self addSubview:btn];
    
}

- (void)setTags:(NSArray *)tags {
    _tags = tags;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (tags.count == 0) {
        return;
    }
    
    CGRect rect = self.bounds;
    
    CGFloat offx=0,offy=0;
    int i=0;
    for (NSString *tag in tags) {
        CGSize size = [tag boundingRectWithSize:CGSizeMake(MAXFLOAT, 15.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil].size;
        
        UIButton *label = [[UIButton alloc] init];
        label.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [label setTitleColor:TDThemeColor forState:UIControlStateNormal];
        [label setTitle:tag forState:UIControlStateNormal];
        [label setImage:[UIImage imageNamed:@"alive_stock.png"] forState:UIControlStateNormal];
        label.tag = i++;
        [label addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:label];
        [label align:BAHorizontalImage withSpacing:10];
        
        if ((offx + size.width+30) > rect.size.width) {
            offx =0;
            offy += 34;
        }
        
        label.frame = CGRectMake(offx, offy, size.width+30, 24);
        
        offx += (CGRectGetWidth(label.frame) + 8);
    }
}

- (void)buttonPressed:(UIButton *)sender {
    NSInteger tag = sender.tag;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTagsView:didSelectedWithIndex:)]) {
        [self.delegate aliveListTagsView:self didSelectedWithIndex:tag];
    }
}
@end
