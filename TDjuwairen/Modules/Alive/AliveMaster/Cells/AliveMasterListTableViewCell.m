//
//  AliveMasterListTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveMasterListTableViewCell.h"
#import "AliveMasterModel.h"
#import "UIImageView+WebCache.h"
#import "LoginStateManager.h"

@interface AliveMasterListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *aImageView;
@property (weak, nonatomic) IBOutlet UILabel *aTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *aLevelLabel;

@property (weak, nonatomic) IBOutlet UILabel *aFansCountLabel;



@end

@implementation AliveMasterListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.attentBtn.layer.cornerRadius = 2;
    self.attentBtn.layer.masksToBounds = YES;
    self.attentBtn.layer.borderWidth = 1;
    self.attentBtn.layer.borderColor = TDThemeColor.CGColor;
    
    self.aImageView.layer.cornerRadius = 25;
    self.aImageView.layer.masksToBounds = YES;
    self.aImageView.layer.borderWidth = 1;
    self.aImageView.layer.borderColor = TDSeparatorColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (instancetype)loadAliveMasterListTableViewCell:(UITableView *)tableView {
    
    AliveMasterListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveMasterCell"];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AliveMasterListTableViewCell" owner:self options:nil] lastObject];
        
    }
    return cell;
}

- (void)setAliveModel:(AliveMasterModel *)aliveModel {
    
    _aliveModel = aliveModel;
    [self.aImageView sd_setImageWithURL:[NSURL URLWithString:aliveModel.avatar] placeholderImage:TDDefaultUserAvatar];
    self.aTitleLabel.text = aliveModel.masterNickName;
    self.aLevelLabel.text = [NSString stringWithFormat:@"%ld级",(long)aliveModel.level];
    self.aFansCountLabel.text = [NSString stringWithFormat:@"%@粉丝",aliveModel.attenNum];
    self.introLabel.text = (aliveModel.roomIntro.length)?aliveModel.roomIntro:@"暂无介绍";
    
    if (aliveModel.isAtten == YES) {
        [self.attentBtn setTitleColor:TDThemeColor forState:UIControlStateNormal];
        [self.attentBtn setBackgroundColor:[UIColor whiteColor]];
        [self.attentBtn setTitle:@"已关注" forState:UIControlStateNormal];
        
    }else {
        
        [self.attentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.attentBtn setBackgroundColor:TDThemeColor];
        [self.attentBtn setTitle:@"加关注" forState:UIControlStateNormal];
    }
    
    // 自己隐藏关注按钮
    if (US.isLogIn && [US.userId isEqualToString:aliveModel.masterId]) {
        self.attentBtn.hidden = YES;
    } else {
        self.attentBtn.hidden = NO;
    }
}

- (IBAction)attentionButtonClick:(UIButton *)sender {

    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveMasterListCell:attentPressed:)]) {
        [self.delegate aliveMasterListCell:self attentPressed:sender];
    }
}

@end
