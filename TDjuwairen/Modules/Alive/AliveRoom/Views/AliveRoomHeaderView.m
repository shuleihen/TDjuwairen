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

@interface AliveRoomHeaderView ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *aImageView;
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
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (nonatomic, strong)UIAlertView *alert;

@end

@implementation AliveRoomHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.aImageView.layer.cornerRadius = 25;
    self.aImageView.layer.masksToBounds = YES;
    
    self.addAttenBtn.hidden = YES;
    self.editBtn.hidden = YES;
    self.messageBtn.hidden = YES;
    
    self.aSexImageView.hidden = YES;
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
    [self.aAttentionButton setTitle:[NSString stringWithFormat:@"关注%@",master.attenNum] forState:UIControlStateHighlighted];
    
    [self.aFansButton setTitle:[NSString stringWithFormat:@"粉丝%@",master.fansNum] forState:UIControlStateNormal];
    [self.aFansButton setTitle:[NSString stringWithFormat:@"粉丝%@",master.fansNum] forState:UIControlStateHighlighted];
    
    if (master.roomInfo.length) {
        self.aRoomInfoLabel.text = [NSString stringWithFormat:@"直播间介绍：%@",master.roomInfo];
    }
    
    if ([master.sex isEqualToString:@"女"]) {
        self.aSexImageView.highlighted = NO;
        self.aSexImageView.hidden = NO;
    } else if ([master.sex isEqualToString:@"男"]){
        self.aSexImageView.highlighted = YES;
        self.aSexImageView.hidden = NO;
    } else {
        self.aSexImageView.hidden = YES;
    }
    
    if (master.isMaster) {
        // 自己
        self.addAttenBtn.hidden = YES;
        self.editBtn.hidden = NO;
        self.messageBtn.hidden = NO;
    } else {
        self.addAttenBtn.hidden = NO;
        self.editBtn.hidden = YES;
        self.messageBtn.hidden = YES;
    }
    
    if (master.isAtten) {
        [self.addAttenBtn setTitle:@"已关注" forState:UIControlStateNormal];
    } else {
        [self.addAttenBtn setTitle:@"加关注" forState:UIControlStateNormal];
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

- (IBAction)addAttentionPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveRommHeaderView:attenPressed:)]) {
        [self.delegate aliveRommHeaderView:self attenPressed:sender];
    }
}
- (IBAction)levelClick:(id)sender {
//    _alert = [[UIAlertView alloc] initWithTitle:@"" message:@"xxxxx" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    
//    [_alert show];
}
- (IBAction)guestRuleClick:(id)sender {
//    _alert = [[UIAlertView alloc] initWithTitle:@"" message:@"xxxxx" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    
//    [_alert show];
}




@end
