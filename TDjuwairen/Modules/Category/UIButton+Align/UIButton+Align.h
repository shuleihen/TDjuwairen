//
//  UIButton+Align.h
//  DYCategory
//
//  Created by zdy on 2017/1/9.
//  Copyright © 2017年 lianlian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonAlign) {
    BAVerticalImage     = 1,    // 图片在上
    BAVerticalTitle     = 2,    // 文字在上
    BAHorizontalImage   = 3,    // 图片在左边
    BAHorizontalTitle   = 4,    // 文字在左边
};

@interface UIButton (Align)
- (void)align:(ButtonAlign)align withSpacing:(CGFloat)spacing;
- (void)rightAlign:(ButtonAlign)align withSpacing:(CGFloat)spacing;
@end
