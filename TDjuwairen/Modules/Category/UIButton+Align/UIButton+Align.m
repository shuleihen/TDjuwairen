//
//  UIButton+Align.m
//  DYCategory
//
//  Created by zdy on 2017/1/9.
//  Copyright © 2017年 lianlian. All rights reserved.
//

#import "UIButton+Align.h"
#import <objc/runtime.h>

@implementation UIButton (Align)
- (void)align:(ButtonAlign)align withSpacing:(CGFloat)spacing
{
    // contentVerticalAlignment 和 contentHorizontalAlignment 使用默认center，如果修改了会对下面的计算有影响
    
    CGSize imageSize = self.imageView.image.size;
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    
    if (align == BAVerticalImage) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -imageSize.width, -imageSize.height - spacing/2, 0.0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(-titleSize.height-spacing/2, 0, 0, -titleSize.width)];
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

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";
static char *IsCheckedKey = "isCheckedKey";

-(void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets;
        [value getValue:&edgeInsets];
        return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (void)setIsChecked:(NSString *)isChecked {
    objc_setAssociatedObject(self, IsCheckedKey, isChecked, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)isChecked {
    return objc_getAssociatedObject(self, IsCheckedKey);
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) ||!self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

#pragma mark-
- (void)setNormalImageWith:(NSString *)imgName {
    [self setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}
- (void)setBackNormalImageWith:(NSString *)imgName {
    [self setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}
- (void)setTitleNormalWith:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)setTitleColorNormalWith:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
}
- (void)setSelectedImg:(NSString *)selectedImgName {
    [self setImage:[UIImage imageNamed:selectedImgName] forState:UIControlStateSelected];
}
- (void)setBackColorWith:(UIColor *)backColor{
    self.backgroundColor = backColor;
}

@end
