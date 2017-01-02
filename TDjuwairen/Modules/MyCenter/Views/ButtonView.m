//
//  ButtonView.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ButtonView.h"
#import "HexColors.h"

@implementation ButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //
        self.backgroundColor = [UIColor whiteColor];
        self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-17)/2, 10, 21, 20)];
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, self.frame.size.width, 20)];
        self.label.font = [UIFont systemFontOfSize:13];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.dk_textColorPicker = DKColorPickerWithKey(TITLE);
        [self addSubview:self.imageview];
        [self addSubview:self.label];
        
    }
    return self;
}

@end
