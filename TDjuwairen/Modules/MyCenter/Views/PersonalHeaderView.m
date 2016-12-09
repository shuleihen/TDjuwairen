//
//  PersonalHeaderView.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/9.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PersonalHeaderView.h"
#import "HexColors.h"

#define HeaderHeight 190
#define AvatarHeight 60

@implementation PersonalHeaderView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self create];
    }
    return self;
}

- (void)create {
    self.backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, HeaderHeight)];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0, kScreenWidth, HeaderHeight);
    [self.backImg addSubview:effectview];
    
    UIView *mask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, HeaderHeight)];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.3;
    [self.backImg addSubview:mask];
    
    self.headImg = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-AvatarHeight)/2, 52, AvatarHeight, AvatarHeight)];
    self.headImg.layer.cornerRadius = AvatarHeight/2;
    self.headImg.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
    self.headImg.layer.borderWidth = 2.0;
    self.headImg.layer.masksToBounds = YES;
    
    self.nickname = [[UILabel alloc]initWithFrame:CGRectMake(0, 125, kScreenWidth, 20)];
    self.nickname.textColor = [UIColor whiteColor];
    self.nickname.font = [UIFont systemFontOfSize:15];
    self.nickname.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.backImg];
    [self addSubview:self.headImg];
    [self addSubview:self.nickname];
    
    self.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#5ca8e5"];
}

- (void)addTarget:(id)target action:(SEL)action {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}
@end
