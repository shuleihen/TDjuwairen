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

@interface AliveMasterListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *aImageView;
@property (weak, nonatomic) IBOutlet UILabel *aTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *aLevelLabel;
@property (weak, nonatomic) IBOutlet UIButton *aAttentionButton;

@property (weak, nonatomic) IBOutlet UILabel *aFansCountLabel;


@end

@implementation AliveMasterListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.aAttentionButton.layer.cornerRadius = 2;
    self.aAttentionButton.layer.masksToBounds = YES;
    self.aAttentionButton.layer.borderWidth = 1;
    self.aAttentionButton.layer.borderColor = TDThemeColor.CGColor;
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
    [self.aImageView sd_setImageWithURL:[NSURL URLWithString:aliveModel.avatar] placeholderImage:nil];
    self.aTitleLabel.text = aliveModel.masterNickName;
    self.aLevelLabel.text = [NSString stringWithFormat:@"%ld级",aliveModel.level];
    self.aFansCountLabel.text = [NSString stringWithFormat:@"%@粉丝",aliveModel.attenNum];
    
    if (aliveModel.isAtten == YES) {
        [self.aAttentionButton setTitleColor:TDThemeColor forState:UIControlStateNormal];
        [self.aAttentionButton setBackgroundColor:[UIColor whiteColor]];
        [self.aAttentionButton setTitle:@"已关注" forState:UIControlStateNormal];
        
    }else {
        
        [self.aAttentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.aAttentionButton setBackgroundColor:TDThemeColor];
        [self.aAttentionButton setTitle:@"加关注" forState:UIControlStateNormal];
    }
    
}
- (IBAction)attentionButtonClick:(UIButton *)sender {
}

@end
