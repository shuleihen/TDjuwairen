//
//  TDPopupMenuButton.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDPopupMenuButton.h"

@implementation TDPopupMenuButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    // UIImageView
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.bounds.size.width;
    CGFloat imageH = self.bounds.size.height * 0.8;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    // UILabel
    CGFloat labelY = imageH;
    CGFloat labelH = self.bounds.size.height - labelY;
    self.titleLabel.frame = CGRectMake(imageX, labelY, imageW, labelH);
}

@end
