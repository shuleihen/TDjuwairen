//
//  AliveSearchUserCell.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/26.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveSearchUserCell.h"
#import "AliveSearchResultModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+Border.h"

@interface AliveSearchUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *uImageView;
@property (weak, nonatomic) IBOutlet UILabel *uNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *uAddAttentionButton;

@end

@implementation AliveSearchUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.uImageView cutCircular:15];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
+ (instancetype)loadAliveSearchUserCellWithTableView:(UITableView *)tableView {

    AliveSearchUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveSearchUserCell"];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"AliveSearchUserCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setUserModel:(AliveSearchResultModel *)userModel {
    _userModel = userModel;
    [self.uImageView sd_setImageWithURL:[NSURL URLWithString:userModel.userIcon] placeholderImage:TDDefaultUserAvatar];
    self.uNameLabel.text = userModel.userNickName;
    if (userModel.isAttend == YES) {
        [self.uAddAttentionButton setTitleColor:TDThemeColor forState:UIControlStateNormal];
        [self.uAddAttentionButton cutCircularRadius:4 addBorder:1 borderColor:TDThemeColor];
        [self.uAddAttentionButton setTitle:@"已关注" forState:UIControlStateNormal];
         [self.uAddAttentionButton setBackgroundColor:[UIColor whiteColor]];
    }else {
        [self.uAddAttentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.uAddAttentionButton cutCircularRadius:4 addBorder:0 borderColor:[UIColor clearColor]];
        [self.uAddAttentionButton setTitle:@"加关注" forState:UIControlStateNormal];
        [self.uAddAttentionButton setBackgroundColor:TDThemeColor];
        
    }
    
    
}

/// 添加关注
- (IBAction)addAttentionBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addAttendWithAliveSearchResultModel: andCellIndex:)]) {
        [self.delegate addAttendWithAliveSearchResultModel:self.userModel andCellIndex:self.tag];
    }
}


@end
