//
//  SPDetailTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SPDetailTableViewCell.h"

@implementation SPDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRecordModel:(SPEditRecordModel *)recordModel {
    _recordModel = recordModel;
    self.stockNameLabel.text = [NSString stringWithFormat:@"%@(%@)",recordModel.stockName,recordModel.stockCode];
    self.ratioLabel.text = [NSString stringWithFormat:@"%@%%", recordModel.ratio];
    
    switch (recordModel.type) {
        case kSPEidtRecordTypeNormal:
            self.optionLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
            self.optionLabel.text = @"持有";
            break;
        case SPEidtRecordTypeAdd:
            self.optionLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#E74922"];
            self.optionLabel.text = @"增持";
            break;
        case SPEidtRecordTypeReduce:
            self.optionLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#13C869"];
            self.optionLabel.text = @"减持";
            break;
        case SPEidtRecordTypeSell:
            self.optionLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#13C869"];
            self.optionLabel.text = @"卖出";
            break;
        case SPEidtRecordTypeBuy:
            self.optionLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#E74922"];
            self.optionLabel.text = @"买入";
            break;
        default:
            break;
    }
}
@end
