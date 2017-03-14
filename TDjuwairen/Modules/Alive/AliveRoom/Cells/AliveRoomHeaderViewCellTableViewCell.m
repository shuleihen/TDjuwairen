//
//  AliveRoomHeaderViewCellTableViewCell.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveRoomHeaderViewCellTableViewCell.h"
#import "AliveRoomMasterModel.h"
#import "UIImageView+WebCache.h"

@interface AliveRoomHeaderViewCellTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *aImageView;
@property (weak, nonatomic) IBOutlet UILabel *aNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *aAttentionButton;
@property (weak, nonatomic) IBOutlet UIButton *aFansButton;

@property (weak, nonatomic) IBOutlet UILabel *aRoomInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aSexImageView;
@property (weak, nonatomic) IBOutlet UIButton *aLevelButton;

@property (weak, nonatomic) IBOutlet UIButton *aGuessRateButton;

@end

@implementation AliveRoomHeaderViewCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.aImageView.layer.cornerRadius = 25;
    self.aImageView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)AliveRoomHeaderViewCellTableViewCell:(UITableView *)tableView {

    AliveRoomHeaderViewCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveRoomHeaderViewCellTableViewCell"];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AliveRoomHeaderViewCellTableViewCell" owner:self options:nil] lastObject];
        
    }
    return cell;
}

- (void)setHeaderModel:(AliveRoomMasterModel *)headerModel {
    
    _headerModel = headerModel;
    [self.aLevelButton setTitle:[NSString stringWithFormat:@"%@",headerModel.level] forState:UIControlStateNormal];
    [self.aGuessRateButton setTitle:[NSString stringWithFormat:@"%@",headerModel.guessRate] forState:UIControlStateNormal];
    
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


- (IBAction)attentionButton:(UIButton *)sender {
    
}


@end
