//
//  SubscritionHistoryListCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SubscriptionHistoryListCell.h"

@implementation SubscriptionHistoryListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSubscriptionModel:(SubscriptionModel *)model {
    self.dateTimeLabel.text = model.dateTime;
    self.titleLabel.text = model.title;
    self.userNameLabel.text = model.userName;
    self.userEmailLabel.text = model.userEmail;
    
    if (model.type == 1) {
        self.typeLabel.text = @"邮箱";
    }
    
}


@end