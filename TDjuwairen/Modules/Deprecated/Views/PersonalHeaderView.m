//
//  PersonalHeaderView.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/9.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PersonalHeaderView.h"
#import "HexColors.h"

#define AvatarHeight 80

@implementation PersonalHeaderView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self create];
    }
    return self;
}

- (void)create {
    self.backImg = [[UIImageView alloc]initWithFrame:self.bounds];
    self.backImg.image = [UIImage imageNamed:@"bg_mine.png"];
    
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
//    effectview.frame = self.bounds;
//    [self.backImg addSubview:effectview];
    
//    UIView *mask = [[UIView alloc] initWithFrame:self.bounds];
//    mask.backgroundColor = [UIColor blackColor];
//    mask.alpha = 0.3;
//    [self.backImg addSubview:mask];
    
    self.headImg = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-AvatarHeight)/2, 52, AvatarHeight, AvatarHeight)];
    self.headImg.layer.cornerRadius = AvatarHeight/2;
    self.headImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImg.layer.borderWidth = 1.0;
    self.headImg.layer.masksToBounds = YES;
    
    self.nickname = [[UILabel alloc]initWithFrame:CGRectMake(0, 145, kScreenWidth, 20)];
    self.nickname.textColor = [UIColor whiteColor];
    self.nickname.font = [UIFont systemFontOfSize:14];
    self.nickname.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.backImg];
    [self addSubview:self.headImg];
    [self addSubview:self.nickname];
}

- (void)addTarget:(id)target action:(SEL)action {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}
@end
