//
//  AliveRoomHeaderView.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveRoomHeaderView.h"
#import "AliveRoomMasterModel.h"
#import "UIImageView+WebCache.h"
#import "LoginState.h"

@interface AliveRoomHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *aImageView;
@property (weak, nonatomic) IBOutlet UILabel *aNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aAddressLabel;

@property (weak, nonatomic) IBOutlet UIButton *aAttentionButton;
@property (weak, nonatomic) IBOutlet UIButton *aFansButton;

@property (weak, nonatomic) IBOutlet UILabel *aRoomInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aSexImageView;

@property (weak, nonatomic) IBOutlet UIButton *aLevelButton;
@property (weak, nonatomic) IBOutlet UIButton *aGuessRateButton;

@property (weak, nonatomic) IBOutlet UIButton *addAttenBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;

@end

@implementation AliveRoomHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.aImageView.layer.cornerRadius = 25;
    self.aImageView.layer.masksToBounds = YES;
    
}

+ (instancetype)loadAliveRoomeHeaderView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"AliveRoomHeaderView" owner:nil options:nil] lastObject];
}

- (void)setupRoomMasterModel:(AliveRoomMasterModel *)master {
    
    _headerModel = master;
    [self.aLevelButton setTitle:[NSString stringWithFormat:@"%@",master.level] forState:UIControlStateNormal];
    [self.aGuessRateButton setTitle:[NSString stringWithFormat:@"%@",master.guessRate] forState:UIControlStateNormal];
    
    [self.aImageView sd_setImageWithURL:[NSURL URLWithString:master.avatar] placeholderImage:TDDefaultUserAvatar];
    self.aNickNameLabel.text = master.masterNickName;
    self.aAddressLabel.text = master.city;
    [self.aAttentionButton setTitle:[NSString stringWithFormat:@"关注%@",master.attenNum] forState:UIControlStateNormal];
    [self.aFansButton setTitle:[NSString stringWithFormat:@"粉丝%@",master.fansNum] forState:UIControlStateNormal];
    self.aRoomInfoLabel.text = [NSString stringWithFormat:@"直播间介绍：%@",master.roomInfo];
    if ([master.sex isEqualToString:@"女"]) {
        self.aSexImageView.highlighted = NO;
    }else {
        
        self.aSexImageView.highlighted = YES;
    }
    
    if ([US.userId isEqualToString:master.masterId]) {
        // 自己
        self.addAttenBtn.hidden = YES;
        self.editBtn.hidden = NO;
        self.messageBtn.hidden = NO;
    } else {
        self.addAttenBtn.hidden = NO;
        self.editBtn.hidden = YES;
        self.messageBtn.hidden = YES;
    }
}

- (IBAction)backPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveRommHeaderView:backPressed:)]) {
        [self.delegate aliveRommHeaderView:self backPressed:sender];
    }
}

- (IBAction)editPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveRommHeaderView:editPressed:)]) {
        [self.delegate aliveRommHeaderView:self editPressed:sender];
    }
}

- (IBAction)messagePressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveRommHeaderView:messagePressed:)]) {
        [self.delegate aliveRommHeaderView:self messagePressed:sender];
    }
}

- (IBAction)attentionPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveRommHeaderView:attentionListPressed:)]) {
        [self.delegate aliveRommHeaderView:self attentionListPressed:sender];
    }
}

- (IBAction)fansPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveRommHeaderView:fansListPressed:)]) {
        [self.delegate aliveRommHeaderView:self fansListPressed:sender];
    }
}


@end
