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
@interface ActualQuotationCell ()
{
    __weak IBOutlet UIImageView *iconImgV;
    __weak IBOutlet UILabel *label_title;
    __weak IBOutlet UILabel *label_desc;
    __weak IBOutlet UIButton *label_Award;
    __weak IBOutlet UIButton *callButton;
    
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setFirmModel:(FirmPlatListModel *)firmModel{
    _firmModel = firmModel;
    [iconImgV sd_setImageWithURL:[NSURL URLWithString:firmModel.plat_logo] placeholderImage:TDDefaultUserAvatar];
    label_title.text = firmModel.plat_name;
    label_desc.text = firmModel.plat_info;
    [label_Award setTitle:[NSString stringWithFormat:@"X%@",firmModel.plat_keynum] forState:UIControlStateNormal];
    //** 当前用户开户状态，0表示没有开户，1表示正在审核，2表示开户成功，3表示开户失败*/
    [_openAnAccountBtn setTitle:[self getTitleWithTag:firmModel.account_status] forState:UIControlStateNormal];
}
- (NSString *)getTitleWithTag:(NSNumber *)num
{
    if ([num isEqual:@0]) {
        return @"立即开户";
    }else if ([num isEqual:@1]){
        return @"正在审核";
    }else if ([num isEqual:@2]){
        return @"开户成功";
    }else if ([num isEqual:@3]){
        return @"开户失败";
    }
    return @"";
}
+ (instancetype)loadActualQuotationCellWithTableView:(UITableView *)tableView {

    ActualQuotationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActualQuotationCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActualQuotationCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (IBAction)doneBtnClick:(UIButton *)sender {
    
//    if (![_firmModel.account_status isEqual:@0]) {
//        return;
//    }
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
