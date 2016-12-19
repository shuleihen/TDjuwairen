//
//  StockMarketComparisonView.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/19.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockMarketComparisonView.h"

@implementation StockMarketComparisonView


- (void)setKandie:(CGFloat)kandie {
    _kandie = kandie;
    [self setNeedsDisplay];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // bg image
    UIImage *bgImage = [UIImage imageNamed:@"bg_progress.png"];
    [bgImage drawInRect:CGRectMake(0, (rect.size.height - bgImage.size.height)/2, rect.size.width, bgImage.size.height)];
    
    // 看跌占比
    CGFloat w = rect.size.width*self.kandie;
    UIImage *kandieImage = [UIImage imageNamed:@"progress_kandie.png"];
    [kandieImage drawInRect:CGRectMake(rect.size.width-w+2, (rect.size.height - kandieImage.size.height)/2, w, kandieImage.size.height)];
}


@end
