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

- (void)setTags:(NSArray *)tags {
    _tags = tags;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (tags.count == 0) {
        return;
    }
    
    CGRect rect = self.bounds;
    
    CGFloat offx=0,offy=0;
    for (NSString *tag in tags) {
        CGSize size = [tag boundingRectWithSize:CGSizeMake(MAXFLOAT, 15.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil].size;
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor hx_colorWithHexRGBAString:@"#3371e2"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = tag;
        label.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#3371e2"].CGColor;
        label.layer.borderWidth = 1.0;
        [self addSubview:label];
        
        if ((offx + size.width+8) > rect.size.width) {
            offx =0;
            offy += 32;
        }
        
        label.frame = CGRectMake(offx, offy, size.width+8, 22);
        
        offx += (CGRectGetWidth(label.frame) + 8);
    }
}

@end
