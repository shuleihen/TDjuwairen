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
#import "LoginStateManager.h"
#import "TDAvatar.h"
#import "UIButton+Align.h"

@interface AliveRoomHeaderView ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet TDAvatar *aImageView;
@property (weak, nonatomic) IBOutlet UILabel *aNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aAddressLabel;

@property (weak, nonatomic) IBOutlet UIButton *aFansButton;
@property (weak, nonatomic) IBOutlet UIButton *aAttentionButton;

@property (weak, nonatomic) IBOutlet UILabel *aRoomInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aSexImageView;

@property (weak, nonatomic) IBOutlet UIButton *aLevelButton;
@property (weak, nonatomic) IBOutlet UIButton *aGuessRateButton;

@property (weak, nonatomic) IBOutlet UIButton *addAttenBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation AliveRoomHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.addAttenBtn.hidden = YES;
    self.editBtn.hidden = YES;
    self.aSexImageView.hidden = YES;
}

+ (instancetype)loadAliveRoomeHeaderView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"AliveRoomHeaderView" owner:nil options:nil] lastObject];
}

- (void)setupRoomMasterModel:(AliveRoomMasterModel *)master {
    
    _headerModel = master;
    
    [self.aImageView sd_setImageWithURL:[NSURL URLWithString:master.avatar] placeholderImage:TDDefaultUserAvatar options:SDWebImageRefreshCached];
    self.aNickNameLabel.text = master.masterNickName;
    self.aAddressLabel.text = master.city;
    self.aRoomInfoLabel.text = master.roomInfo;
    
    [self.aAttentionButton setTitle:[NSString stringWithFormat:@"关注%@",master.attenNum] forState:UIControlStateNormal];
    [self.aAttentionButton setTitle:[NSString stringWithFormat:@"关注%@",master.attenNum] forState:UIControlStateHighlighted];
    
    [self.aFansButton setTitle:[NSString stringWithFormat:@"粉丝%@",master.fansNum] forState:UIControlStateNormal];
    [self.aFansButton setTitle:[NSString stringWithFormat:@"粉丝%@",master.fansNum] forState:UIControlStateHighlighted];

    
    if (US.sex == kUserSexWoman) {
        self.aSexImageView.highlighted = NO;
        self.aSexImageView.hidden = NO;
    } else if (US.sex == kUserSexMan){
        self.aSexImageView.highlighted = YES;
        self.aSexImageView.hidden = NO;
    } else {
        self.aSexImageView.hidden = YES;
    }
    
    if (master.isMaster) {
        // 自己，显示编辑和分享，不显示关注
        self.addAttenBtn.hidden = YES;
        self.editBtn.hidden = NO;
    } else {
        // 显示分享和关注，不显示编辑
        self.addAttenBtn.hidden = NO;
        self.editBtn.hidden = YES;
    }
    
    if (master.isAtten) {
        [self.addAttenBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.addAttenBtn setImage:[UIImage imageNamed:@"ico_reducefriend.png"] forState:UIControlStateNormal];
    } else {
        [self.addAttenBtn setTitle:@"加关注" forState:UIControlStateNormal];
        [self.addAttenBtn setImage:[UIImage imageNamed:@"ico_addfriend.png"] forState:UIControlStateNormal];
    }
    [self.addAttenBtn align:BAVerticalImage withSpacing:2];
}

- (void)setSroolOffset:(CGPoint)offset {
    
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

- (IBAction)sharePressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveRommHeaderView:sharePressed:)]) {
        [self.delegate aliveRommHeaderView:self sharePressed:sender];
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

- (IBAction)addAttentionPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveRommHeaderView:attenPressed:)]) {
        [self.delegate aliveRommHeaderView:self attenPressed:sender];
    }
}
- (IBAction)levelClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveRommHeaderView:levelPressed:)]) {
        [self.delegate aliveRommHeaderView:self levelPressed:sender];
    }
}

- (IBAction)guestRuleClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveRommHeaderView:guestRulePressed:)]) {
        [self.delegate aliveRommHeaderView:self guestRulePressed:sender];
    }
}

@end
