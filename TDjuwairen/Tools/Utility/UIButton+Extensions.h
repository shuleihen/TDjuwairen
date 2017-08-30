//
//  UIButton+Extensions.h
//  ButtonEnlarge
//
//  Created by dengshu on 16-5-28.
//  Copyright (c) 2016年 zhanshu. All rights reserved.
//

//扩大按钮的点击范围
//点击事件处理成block属性
//button内容处理

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LSButtonEdgeInsetsStyle){
    //文字在左 图片在右
    LSButtonEdgeInsetsStyleLeft,
    //文字在右 图片在左
    LSButtonEdgeInsetsStyleRight,
    //文字在上 图片在下
    LSButtonEdgeInsetsStyleTop,
    //文字在下 图片在上
    LSButtonEdgeInsetsStyleBottom
};

typedef void(^clickBlock)(UIButton *sender);

@interface UIButton (Extensions)

//@property (nonatomic, assign) BOOL isChecked;

@property (nonatomic, strong) NSString *isChecked;
@property(nonatomic,copy)clickBlock click;
@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;
- (void)setBackNormalImageWith:(NSString *)imgName;
- (void)setTitleNormalWith:(NSString *)title;
- (void)setTitleColorNormalWith:(UIColor *)color;
- (void)setNormalImageWith:(NSString*)imgName;
- (void)setSelectedImg:(NSString *)selectedImgName;
- (void)setBackColorWith:(UIColor *)backColor;


@end
