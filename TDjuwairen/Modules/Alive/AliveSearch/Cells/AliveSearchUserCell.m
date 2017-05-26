//
//  AliveSearchUserCell.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/26.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveSearchUserCell.h"

@interface AliveSearchUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *uImageView;
@property (weak, nonatomic) IBOutlet UILabel *uNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *uAddAttentionButton;


@end

@implementation AliveSearchUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
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


/// 添加关注
- (IBAction)addAttentionBtnClick:(UIButton *)sender {
}

@end
