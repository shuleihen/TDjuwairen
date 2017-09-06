//
//  AliveListTagsView.m
//  TDjuwairen
//
//  Created by zdy on 2017/4/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListTagsView.h"
#import "HexColors.h"

@implementation AliveListTagsView

- (void)setStockHolderName:(NSString *)stockHolderName {
    _stockHolderName = stockHolderName;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGSize size = [stockHolderName boundingRectWithSize:CGSizeMake(MAXFLOAT, 15.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil].size;
    
    UIButton *label = [[UIButton alloc] init];
    label.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [label setTitleColor:TDThemeColor forState:UIControlStateNormal];
    [label setTitle:stockHolderName forState:UIControlStateNormal];
    label.layer.borderColor = TDThemeColor.CGColor;
    label.layer.borderWidth = 1.0;
    label.tag = 0;
    [label addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:label];
    
    label.frame = CGRectMake(0, 0, size.width+8, 24);

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(size.width+18, 0, 103, 24)];
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
        label.layer.borderColor = TDThemeColor.CGColor;
        label.layer.borderWidth = 1.0;
        label.tag = i++;
        [label addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:label];
        
        if ((offx + size.width+8) > rect.size.width) {
            offx =0;
            offy += 34;
        }
        
        label.frame = CGRectMake(offx, offy, size.width+8, 24);
        
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
