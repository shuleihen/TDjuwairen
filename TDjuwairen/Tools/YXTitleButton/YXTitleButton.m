//
//  YXTitleButton.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "YXTitleButton.h"

@implementation YXTitleButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = CGRectMake(60, 7, [UIScreen mainScreen].bounds.size.width-120, 30);
    
    [self setBackgroundImage:[UIImage imageNamed:@"survey_search.png"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"survey_search.png"] forState:UIControlStateHighlighted];
    
}
@end
