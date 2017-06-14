//
//  HotTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/18.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "HotTableViewCell.h"

@implementation HotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSpotModel:(StockHotModel *)model {
    self.titleLabel.text = model.title;
    
    if (model.isCollection) {
        self.dateTimeLabel.text = [NSString stringWithFormat:@"%@(%@)",model.companyName,model.companyCode];
        self.sourceLabel.text = [NSString stringWithFormat:@"%@ %@",model.source,model.dateTime];
        self.dateTimeLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        self.sourceLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#cccccc"];
    } else {
        self.dateTimeLabel.text = model.dateTime;
        self.sourceLabel.text = model.source;
        self.dateTimeLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#cccccc"];
        self.sourceLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
    }
}

- (void)setupAnnounceModel:(StockAnnounceModel *)model {
    self.titleLabel.text = model.title;
    self.dateTimeLabel.text = model.dateTime;
    self.sourceLabel.text = @"";
}
@end
