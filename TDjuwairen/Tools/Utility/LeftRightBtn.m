//
//  LeftRightBtn.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/1.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "LeftRightBtn.h"
#import "NSString+Ext.h"

@implementation LeftRightBtn

- (instancetype)initWithFrame:(CGRect)frame andImg:(NSString *)img{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgView.image = [UIImage imageNamed:img];
        imgView.center = self.center;
        [self addSubview:imgView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withImg:(NSString *)img andText:(NSString *)text
{
    if (self = [super initWithFrame:frame]) {
        UIFont *font = [UIFont systemFontOfSize:15];
        CGSize textSize = CGSizeMake(200.0f, 20);
        textSize = [text calculateSize:textSize font:font];
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-(20+8+textSize.width))/2, 5, 20, 20)];
        self.imgView.image = [UIImage imageNamed:img];

        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width-(20+8+textSize.width))/2+20+8, 5, textSize.width+10, 20)];
        self.textLabel.text = text;
        self.textLabel.font = font;
        self.textLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [self addSubview:self.imgView];
        [self addSubview:self.textLabel];
        
    }
    return self;
}

@end
