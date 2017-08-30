//
//  AliveRoomStockPoolTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/29.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveRoomStockPoolTableViewCell.h"

@implementation AliveRoomStockPoolTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.container.layer.shadowOffset = CGSizeMake(0, 1);
    self.container.layer.shadowColor = [UIColor hx_colorWithHexRGBAString:@"#cccccc"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
