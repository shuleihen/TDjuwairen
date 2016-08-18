//
//  AllNoResultTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/18.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AllNoResultTableViewCell.h"

@implementation AllNoResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)submitClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(submitClick:)]) {
        [self.delegate submitClick:sender];
    }
}
@end
