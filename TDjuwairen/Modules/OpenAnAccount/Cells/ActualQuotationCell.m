//
//  ActualQuotationCell.m
//  TDjuwairen
//
//  Created by deng shu on 2017/4/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "ActualQuotationCell.h"
#import "UIButton+Align.h"
#import "UIImageView+WebCache.h"
#import "HexColors.h"
@interface ActualQuotationCell ()
{
    __weak IBOutlet UIImageView *iconImgV;
    __weak IBOutlet UILabel *label_title;
    __weak IBOutlet UILabel *label_desc;
    __weak IBOutlet UIButton *label_Award;
    __weak IBOutlet UIButton *callButton;
    __weak IBOutlet NSLayoutConstraint *label_width;
    
}
@property (weak, nonatomic) IBOutlet UIButton *openAnAccountBtn;

@end

@implementation ActualQuotationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.openAnAccountBtn.layer.borderWidth = 1;
    self.openAnAccountBtn.layer.borderColor = TDThemeColor.CGColor;
    self.openAnAccountBtn.layer.cornerRadius = 3;
    self.openAnAccountBtn.layer.masksToBounds = YES;
    [callButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -15)];
    iconImgV.layer.borderColor =[UIColor hx_colorWithHexRGBAString:@"EDEDED"].CGColor;
    iconImgV.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setFirmModel:(FirmPlatListModel *)firmModel{
    _firmModel = firmModel;
     //** 当前用户开户状态，0表示没有开户，1表示正在审核，2表示开户成功，3表示开户失败*/
    [iconImgV sd_setImageWithURL:[NSURL URLWithString:firmModel.plat_logo] placeholderImage:TDDefaultUserAvatar];
    label_title.text = firmModel.plat_name;
    label_desc.text = firmModel.plat_info;
    [_openAnAccountBtn setTitle:firmModel.account_statusStr forState:UIControlStateNormal];
    
    if ([firmModel.account_status isEqual:@2]) {
        [self.openAnAccountBtn setTitleColor:TDAssistTextColor forState:UIControlStateNormal];
        self.openAnAccountBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [label_Award setTitle:[NSString stringWithFormat:@" X %@已发放",firmModel.plat_keynum] forState:UIControlStateNormal];
        label_width.constant = 0;
    }else if ([firmModel.account_status isEqual:@3]) {
        [self.openAnAccountBtn setTitleColor:TDBrickRedColor forState:UIControlStateNormal];
        self.openAnAccountBtn.layer.borderColor = TDBrickRedColor.CGColor;
        [label_Award setTitle:[NSString stringWithFormat:@" X %@已发放",firmModel.plat_keynum] forState:UIControlStateNormal];
        label_width.constant = 72;
    }else{
        [self.openAnAccountBtn setTitleColor:TDThemeColor forState:UIControlStateNormal];
        self.openAnAccountBtn.layer.borderColor = TDThemeColor.CGColor;
        [label_Award setTitle:[NSString stringWithFormat:@" X %@",firmModel.plat_keynum] forState:UIControlStateNormal];
        label_width.constant = 72;
    }

}

+ (instancetype)loadActualQuotationCellWithTableView:(UITableView *)tableView {

    ActualQuotationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActualQuotationCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActualQuotationCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (IBAction)doneBtnClick:(UIButton *)sender {
    
    if ([_firmModel.account_status isEqual:@2]) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(openAnAccountButtonClickDone:)]) {
        [self.delegate openAnAccountButtonClickDone:_firmModel];
    }
}
- (IBAction)callNumClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(callnNumButtonClickDone:)]) {
        [self.delegate callnNumButtonClickDone:_firmModel];
    }
}



@end
