//
//  StockPoolListCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolListCell.h"
#import "UIImage+StockPool.h"

@implementation StockPoolListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIImage *leftImage = [UIImage imageWithStockPoolListLeft];
    self.leftImageView.image = [leftImage resizableImageWithCapInsets:UIEdgeInsetsMake(50, 0, 10, 0)];
    
    UIImage *rightBackImage = [UIImage imageWithStockPoolListRightBackground];
    self.rightBackImageView.image = [rightBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(50, 20, 10, 10)];
    
    NSString *string = @"14 周五";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium],
                          NSForegroundColorAttributeName :[UIColor hx_colorWithHexRGBAString:@"#333333"]}
                  range:NSMakeRange(0, 2)];
    [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f weight:UIFontWeightMedium],
                          NSForegroundColorAttributeName :[UIColor hx_colorWithHexRGBAString:@"#666666"]}
                  range:NSMakeRange(3, 2)];
    self.weekLabel.attributedText = attr;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
