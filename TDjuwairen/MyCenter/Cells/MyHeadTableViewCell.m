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

@property (nonatomic,strong) LoginState *loginState;
@end
@implementation MyHeadTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.loginState = [LoginState addInstance];
        [self create];
    }
    return self;
}

- (void)create{
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
    
    if (self.loginState.isLogIn==YES) {
        //加载头像
        NSString*imagePath=[NSString stringWithFormat:@"%@",self.loginState.headImage];
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil options:SDWebImageRefreshCached];
        
        self.nickname.text = self.loginState.nickName;
        
        //加载模糊背景图片
        NSString*Path = [NSString stringWithFormat:@"%@",self.loginState.headImage];
        [self.backImg sd_setImageWithURL:[NSURL URLWithString:Path] placeholderImage:nil options:SDWebImageRefreshCached];
    }
    else
    {
        self.nickname.text=@"登陆注册";
        self.headImg.image=[UIImage imageNamed:@"HeadUnLogin"];
        self.backImg.image=[UIImage imageNamed:@"NotLogin.png"];
    }
    
    [self addSubview:self.backImg];
    [self addSubview:self.headImg];
    [self addSubview:self.nickname];
    
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
