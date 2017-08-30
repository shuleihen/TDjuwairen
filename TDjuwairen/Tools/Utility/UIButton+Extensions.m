//
//  UIButton+Extensions.m
//  ButtonEnlarge
//
//  Created by dengshu on 16-5-28.
//  Copyright (c) 2016年 zhanshu. All rights reserved.
//

#import "UIButton+Extensions.h"
#import <objc/runtime.h>



@implementation UIButton (Extensions)

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";
static char *IsCheckedKey = "isCheckedKey";
static const void *associatedKey = "associatedKey";

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

-(void)setClick:(clickBlock)click{
    
    objc_setAssociatedObject(self, associatedKey, click, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self removeTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (click) {
        [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(clickBlock)click{
    
    return objc_getAssociatedObject(self, associatedKey);
}

-(void)buttonClick:(UIButton *)sender{
    if (self.click) {
        self.click(sender);
    }
}
//- (void)setIsChecked:(BOOL)isChecked {
//    
//    //NSValue *value = [NSValue value:&isChecked withObjCType:@encode(BOOL)];
//    NSString *value = [NSString stringWithFormat:@"%d",isChecked];
//    objc_setAssociatedObject(self, IsCheckedKey, value, OBJC_ASSOCIATION_ASSIGN);
//}
//
//- (BOOL)isChecked {
//    
//    NSString *value = objc_getAssociatedObject(self, IsCheckedKey);
//    if (<#condition#>) {
//        <#statements#>
//    }
//
////    NSValue *value = objc_getAssociatedObject(self, IsCheckedKey);
////    BOOL isBool;
////    [value getValue:&isBool];
////    return isBool;
//}
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
