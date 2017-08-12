//
//  UILabel+TDLabel.m
//  TDjuwairen
//
//  Created by deng shu on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "UILabel+TDLabel.h"

@implementation UILabel (TDLabel)
- (instancetype)initWithTitle:(NSString *)titleStr textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)textAlignment {

    if (self = [super init]) {
        
        if (titleStr.length > 0) {
            self.text = titleStr;
        }
    
        if (textColor == nil) {
            self.textColor = TDDetailTextColor;
        
        }else {
            self.textColor = textColor;
        }
        
        self.font = [UIFont systemFontOfSize:fontSize];
        if (textAlignment) {
            self.textAlignment = textAlignment;
        }
    }
    return self;
}
@end
