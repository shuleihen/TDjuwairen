//
//  StockPoolExpireCell.m
//  TDjuwairen
//
//  Created by deng shu on 2017/8/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolExpireCell.h"
#import "UIImage+StockPool.h"
#import "StockPoolListCellModel.h"
#import "UIControl+YMCustom.h"

@interface StockPoolExpireCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIButton *addMoneyButton;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@end

@implementation StockPoolExpireCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *leftImage = [UIImage imageWithStockPoolListLeft];
    self.leftImageView.image = [leftImage resizableImageWithCapInsets:UIEdgeInsetsMake(50, 0, 10, 0)];
    _addMoneyButton.custom_acceptEventInterval = 0.5;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCellModel:(StockPoolListCellModel *)cellModel {
    _cellModel = cellModel;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:[NSDate dateWithTimeIntervalSince1970:[cellModel.record_time integerValue]]];
    
    NSString *dayStr = [NSString stringWithFormat:@"%ld",components.day];
    NSString *weekStr = [NSString stringWithFormat:@" %@",[cellModel getWeekDayStr:components.weekday]];
    NSString *string = [NSString stringWithFormat:@"%ld%@",components.day,weekStr];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium],
                          NSForegroundColorAttributeName :[UIColor hx_colorWithHexRGBAString:@"#333333"]}
                  range:NSMakeRange(0, dayStr.length)];
    if (dayStr.length+weekStr.length <= string.length) {
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f weight:UIFontWeightMedium],
                              NSForegroundColorAttributeName :[UIColor hx_colorWithHexRGBAString:@"#666666"]}
                      range:NSMakeRange(dayStr.length, weekStr.length)];
    }
    
    self.weekLabel.attributedText = attr;
    NSDateComponents *componentsMonth = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate dateWithTimeIntervalSince1970:[cellModel.record_time integerValue]]];
    
    self.monthLabel.text = [NSString stringWithFormat:@"%ld-%ld",componentsMonth.year,componentsMonth.month];
    
}


/** 续费按钮点击事件*/
- (IBAction)addMoneyButtonClick:(UIButton *)sender {
    if (self.cellModel == nil) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(addMoney:cellModel:)]) {
        [self.delegate addMoney:self cellModel:self.cellModel];
    }
    
}

@end
