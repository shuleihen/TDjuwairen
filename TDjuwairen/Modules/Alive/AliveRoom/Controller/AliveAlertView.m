//
//  AliveAlertView.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveAlertView.h"

@implementation AliveAlertView

- (instancetype)initWithAliveAlertView:(NSString *)titleStr detail:(NSString *)detailStr {

    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        CGFloat textH = [detailStr boundingRectWithSize:CGSizeMake(kScreenWidth-48, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} context:nil].size.height+45;
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(12, (kScreenHeight-textH)/2, kScreenWidth-24, textH+10)];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.cornerRadius = 2;
        whiteView.layer.masksToBounds = YES;
        [self addSubview:whiteView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, CGRectGetWidth(whiteView.frame)-24, 45)];
        titleLabel.text = titleStr;
        titleLabel.font = [UIFont systemFontOfSize:18.0];
        [whiteView addSubview:titleLabel];
      
        
        
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 45, CGRectGetWidth(whiteView.frame)-12, textH-45)];
        detailLabel.text = detailStr;
        detailLabel.numberOfLines = 0;
        detailLabel.font = [UIFont systemFontOfSize:15.0];
        [whiteView addSubview:detailLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        [self addGestureRecognizer:tap];
        
        
        UIWindow *keyW = [UIApplication sharedApplication].keyWindow;
        [keyW addSubview:self];
     
    }
    return self;
}


- (void)dismissView {

    [self removeFromSuperview];
}



@end
