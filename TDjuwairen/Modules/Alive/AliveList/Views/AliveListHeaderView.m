//
//  AliveListHeaderView.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListHeaderView.h"
#import "UIImageView+WebCache.h"

@implementation AliveListHeaderView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 40, 40)];
        _avatar.layer.cornerRadius = 20.0f;
        _avatar.clipsToBounds = YES;
        _avatar.userInteractionEnabled = YES;
        [self addSubview:_avatar];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarPressed:)];
        [_avatar addGestureRecognizer:tap];
        
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nickNameLabel.font = [UIFont systemFontOfSize:16.0f];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#3371E2"];
        _nickNameLabel.userInteractionEnabled = YES;
        [self addSubview:_nickNameLabel];
        
        UITapGestureRecognizer *nickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarPressed:)];
        [_nickNameLabel addGestureRecognizer:nickTap];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 36, 80, 12)];
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        [self addSubview:_timeLabel];
        
        _officialImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_official.png"]];
        _officialImageView.hidden = YES;
        [self addSubview:_officialImageView];
        
        
        _arrowButton = [[UIButton alloc] init];
        [_arrowButton setImage:[UIImage imageNamed:@"icon_arrow_down.png"] forState:UIControlStateNormal];
        _arrowButton.frame = CGRectMake(kScreenWidth-42, 12, 30, 30);
        [_arrowButton addTarget:self action:@selector(arrowPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_arrowButton];
    }
    return self;
}

- (void)setAliveModel:(AliveListModel *)aliveModel {
    // 头像
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:aliveModel.masterAvatar] placeholderImage:TDDefaultUserAvatar];
    
    // 昵称
    self.nickNameLabel.text = aliveModel.masterNickName;
    CGSize nickNameSize = [self.nickNameLabel sizeThatFits:CGSizeMake(kScreenWidth-12-64, 18)];
    self.nickNameLabel.frame = CGRectMake(62, 14, nickNameSize.width, 18);
    
    // 官方认证标示
    if (aliveModel.isOfficial) {
        self.officialImageView.frame = CGRectMake(62+nickNameSize.width+5, 15, 16, 16);
        self.officialImageView.hidden = NO;
    } else {
        self.officialImageView.hidden = YES;
    }
    
    // 直播动态时间
    self.timeLabel.text = aliveModel.aliveTime;
    
    // 收藏不显示下拉按钮
    self.arrowButton.hidden = aliveModel.isCollection;
}

- (IBAction)avatarPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListHeaderView:avatarPressed:)]) {
        [self.delegate aliveListHeaderView:self avatarPressed:sender];
    }
}

- (void)arrowPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListHeaderView:arrowPressed:)]) {
        [self.delegate aliveListHeaderView:self arrowPressed:sender];
    }
}
@end
