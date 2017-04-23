//
//  ActualQuotationCell.m
//  TDjuwairen
//
//  Created by deng shu on 2017/4/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "ActualQuotationCell.h"
#import "UIButton+Align.h"
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

+ (instancetype)loadActualQuotationCellWithTableView:(UITableView *)tableView {

    ActualQuotationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActualQuotationCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActualQuotationCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (IBAction)doneBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(openAnAccountButtonClickDone:)]) {
        [self.delegate openAnAccountButtonClickDone:@"kaihu"];
    }
}
- (IBAction)callNumClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(callnNumButtonClickDone:)]) {
        [self.delegate callnNumButtonClickDone:@"111"];
    }
}



@end
