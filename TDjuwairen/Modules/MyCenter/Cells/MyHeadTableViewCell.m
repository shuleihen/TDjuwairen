//
//  MyHeadTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MyHeadTableViewCell.h"
#import "LoginState.h"
#import "UIImageView+WebCache.h"

@interface MyHeadTableViewCell ()

@end
@implementation MyHeadTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self create];
    }
    return self;
}

- (void)create{
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 27, 30, 30)];
    [self.backBtn setImage:[UIImage imageNamed:@"nav_backwhite"] forState:UIControlStateNormal];
    
    self.backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0, kScreenWidth, 190);
    [self.backImg addSubview:effectview];
    
    UIView *mask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.3;
    [self.backImg addSubview:mask];
    
    self.headImg = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-60)/2, 52, 60, 60)];
    self.headImg.layer.cornerRadius = 30;
    self.headImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImg.layer.borderWidth = 2.0;
    self.headImg.layer.masksToBounds = YES;
    
    self.nickname = [[UILabel alloc]initWithFrame:CGRectMake(0, 125, kScreenWidth, 20)];
    self.nickname.textColor = [UIColor whiteColor];
    self.nickname.font = [UIFont systemFontOfSize:15];
    self.nickname.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.backImg];
    [self addSubview:self.headImg];
    [self addSubview:self.nickname];
    [self addSubview:self.backBtn];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
