//
//  TOCTitleButton.m
//  clubManager
//
//  Created by jiazhen-mac-01 on 16/8/16.
//  Copyright © 2016年 yxy. All rights reserved.
//

#import "TOCTitleButton.h"
#import "UIView+Layout.h"
@implementation TOCTitleButton
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 重新设置button中title和image的位置
    
    self.titleLabel.center = CGPointMake(self.tz_width / 2, self.tz_height /2);
    self.imageView.tz_left = CGRectGetMaxX(self.titleLabel.frame) + 5;
    self.imageView.tz_top = CGRectGetMidY(self.titleLabel.frame);
}
@end
