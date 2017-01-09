//
//  UIButton+Align.m
//  DYCategory
//
//  Created by zdy on 2017/1/9.
//  Copyright © 2017年 lianlian. All rights reserved.
//

#import "UIButton+Align.h"

@implementation UIButton (Align)
- (void)align:(ButtonAlign)align withSpacing:(CGFloat)spacing
{
    // contentVerticalAlignment 和 contentHorizontalAlignment 使用默认center，如果修改了会对下面的计算有影响
    
    CGSize imageSize = self.imageView.image.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    if (align == BAVerticalImage) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -imageSize.width, -imageSize.height - spacing/2, 0.0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(-titleSize.height-spacing/2, 0.0, 0.0, -titleSize.width)];
    }
    else if (align == BAVerticalTitle) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -imageSize.width, imageSize.height + spacing/2, 0.0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(titleSize.height + spacing/2, 0.0, 0.0, -titleSize.width)];
    }
    else if (align == BAHorizontalImage) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, spacing/2, 0, 0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, spacing/2)];
    }
    else if (align == BAHorizontalTitle) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width + spacing/2)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width - spacing/2)];
    }
}

- (void)rightAlign:(ButtonAlign)align withSpacing:(CGFloat)spacing
{
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    CGSize imageSize = self.imageView.image.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    if (align == BAHorizontalImage) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, spacing/2, 0, 0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, spacing/2)];
    }
    else if (align == BAHorizontalTitle) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width + spacing/2)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width - spacing/2)];
    }
}

@end
