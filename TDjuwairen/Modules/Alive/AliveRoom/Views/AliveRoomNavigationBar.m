//
//  AliveRoomNavigationBar.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveRoomNavigationBar.h"

@implementation AliveRoomNavigationBar

+ (instancetype)loadAliveRoomeNavigationBar {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"AliveRoomNavigationBar" owner:nil options:nil] lastObject];
}


- (void)setupRoomMasterModel:(AliveRoomMasterModel *)master {
    
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
        [self.addAttenBtn setImage:nil forState:UIControlStateNormal];
        self.addAttenBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    } else {
        [self.addAttenBtn setTitle:@"" forState:UIControlStateNormal];
        [self.addAttenBtn setImage:[UIImage imageNamed:@"alive_addfriend.png"] forState:UIControlStateNormal];
        self.addAttenBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
}

- (void)showNavigationBar:(BOOL)isShow withTitle:(NSString *)title {
    self.bg.hidden = !isShow;
    self.titleLabel.text = title;
}

- (IBAction)backPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveRoomNavigationBar:backPressed:)]) {
        [self.delegate aliveRoomNavigationBar:self backPressed:sender];
    }
}

- (IBAction)editPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveRoomNavigationBar:editPressed:)]) {
        [self.delegate aliveRoomNavigationBar:self editPressed:sender];
    }
}

- (IBAction)messagePressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveRoomNavigationBar:messagePressed:)]) {
        [self.delegate aliveRoomNavigationBar:self messagePressed:sender];
    }
}

- (IBAction)addAttentionPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveRoomNavigationBar:attenPressed:)]) {
        [self.delegate aliveRoomNavigationBar:self attenPressed:sender];
    }
}
@end
