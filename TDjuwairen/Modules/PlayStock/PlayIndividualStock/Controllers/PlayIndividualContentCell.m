//
//  PlayIndividualContentCell.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PlayIndividualContentCell.h"

@implementation PlayIndividualContentCell
{
    __weak IBOutlet UILabel *label_title;
    __weak IBOutlet UILabel *label_left;
    __weak IBOutlet UILabel *label_mid;
    __weak IBOutlet UILabel *label_right;
    __weak IBOutlet UILabel *label_enjoy;
    __weak IBOutlet UILabel *label_detailTitle;
    __weak IBOutlet UILabel *label_detailDesc;
    __weak IBOutlet UILabel *label_money;
    __weak IBOutlet UIButton *button_guess;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    label_enjoy.userInteractionEnabled = YES;
    UITapGestureRecognizer *enjoy_Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enjoyClick)];
    [label_enjoy addGestureRecognizer:enjoy_Tap];

    label_money.userInteractionEnabled = YES;
    UITapGestureRecognizer *money_Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moneyClick)];
    [label_money addGestureRecognizer:money_Tap];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonClick:(id)sender {
    if (_guessBlock) {
        _guessBlock(sender);
    }
}
- (void)enjoyClick{
    if (_enjoyBlock) {
        _enjoyBlock();
    }
}

- (void)moneyClick
{
    if (_moneyBlock) {
        _moneyBlock();
    }
}

+ (instancetype)loadCell
{
    return [[[NSBundle mainBundle]loadNibNamed:@"PlayIndividualContentCell" owner:self options:nil] lastObject];
}
@end
