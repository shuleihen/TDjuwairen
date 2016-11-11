//
//  TopBotButton.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/8.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "TopBotButton.h"

@implementation TopBotButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 25;
    CGFloat imageH = 25;
    CGFloat imageX = (contentRect.size.width - imageW) * 0.5;
    CGFloat imageY = 5;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = 20;
    CGFloat imageX = (contentRect.size.width - imageW) * 0.5;
    CGFloat imageY = 35;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
