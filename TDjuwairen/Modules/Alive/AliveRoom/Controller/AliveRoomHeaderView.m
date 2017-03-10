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

@interface AliveRoomHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *aImageView;
@property (weak, nonatomic) IBOutlet UILabel *aNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *aAttentionButton;
@property (weak, nonatomic) IBOutlet UIButton *aFansButton;

@property (weak, nonatomic) IBOutlet UILabel *aRoomInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aSexImageView;


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

- (void)setHeaderModel:(AliveRoomMasterModel *)headerModel {

    _headerModel = headerModel;
    [self.aImageView sd_setImageWithURL:[NSURL URLWithString:headerModel.avatar] placeholderImage:nil];
    self.aNickNameLabel.text = headerModel.masterNickName;
    self.aAddressLabel.text = headerModel.city;
    [self.aAttentionButton setTitle:[NSString stringWithFormat:@"关注%@",headerModel.attenNum] forState:UIControlStateNormal];
    [self.aFansButton setTitle:[NSString stringWithFormat:@"粉丝%@",headerModel.fansNum] forState:UIControlStateNormal];
    self.aRoomInfoLabel.text = [NSString stringWithFormat:@"直播间介绍：%@",headerModel.roomInfo];
    if ([headerModel.sex isEqualToString:@"女"]) {
        self.aSexImageView.highlighted = NO;
    }else {
    
        self.aSexImageView.highlighted = YES;
    }
    
}
- (IBAction)backButtonClick {
    if (self.backBlock) {
        self.backBlock();
    }
    
}

@end
