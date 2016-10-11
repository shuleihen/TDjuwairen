//
//  PaperTagsView.m
//  TDjuwairen
//
//  Created by zdy on 16/10/9.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PaperTagsView.h"

@implementation PaperTagsView
- (void)setTags:(NSArray *)tags {
    _tags = tags;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    int itemSpacing = 10;
    int itemHeight = 20;
    int margin = 15;
    
    CGFloat offx = margin;
    CGFloat offy = 10;
    
    for (NSString *string in tags) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setTitle:string forState:UIControlStateNormal];
        
        CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}];
        CGFloat itmeWith = size.width + 10;
        if ((offx + itemSpacing + itmeWith) > (kScreenWidth - margin)) {
            offx = margin;
            offy += (itemHeight+itemSpacing);
        }
        btn.frame = CGRectMake(offx, offy, itmeWith, itemHeight);
        [self addSubview:btn];
        
        offx += (itmeWith + itemSpacing);
    }
    
    self.bounds = CGRectMake(0, 0, kScreenWidth, offy+itemHeight+itemSpacing);
}
@end
