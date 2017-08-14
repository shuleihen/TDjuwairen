//
//  StockPoolListCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolListCell.h"
#import "UIImage+StockPool.h"
#import "StockPoolListCellModel.h"

@interface StockPoolListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightBackImageView;
@property (weak, nonatomic) IBOutlet TDGradientProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordTotalRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sNewImageView;

@end

@implementation StockPoolListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *leftImage = [UIImage imageWithStockPoolListLeft];
    self.leftImageView.image = [leftImage resizableImageWithCapInsets:UIEdgeInsetsMake(50, 0, 10, 0)];
    
    UIImage *rightBackImage = [UIImage imageWithStockPoolListRightBackground];
    self.rightBackImageView.image = [rightBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(50, 20, 10, 10)];
   
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
    self.recordTotalRatioLabel.text = [NSString stringWithFormat:@"仓位 %@%@",cellModel.record_total_ratio,@"%"];
    self.progressView.progress = [cellModel.record_total_ratio integerValue]*0.01f;
    self.recordDescLabel.text = cellModel.record_desc;
    
    NSDateComponents *componentsTime = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate dateWithTimeIntervalSince1970:[cellModel.record_time integerValue]]];
    self.timeLabel.text = [NSString stringWithFormat:@"%ld:%ld",componentsTime.hour,componentsTime.minute];
    self.sNewImageView.hidden = cellModel.record_is_new;
    
    NSDateComponents *componentsMonth = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate dateWithTimeIntervalSince1970:[cellModel.record_time integerValue]]];
    
    self.monthLabel.text = [NSString stringWithFormat:@"%ld-%ld",componentsMonth.year,componentsMonth.month];;
}



@end
