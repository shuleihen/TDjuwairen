//
//  SearchResultTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/6/1.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SearchResultTableViewCell.h"

@implementation SearchResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsStock:(BOOL)isStock {
    _isStock = isStock;
    
    self.addBtn.hidden = !isStock;
    self.inviteBtn.hidden = !isStock;
}

- (IBAction)addPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addStockPressedWithResult:)]) {
        [self.delegate addStockPressedWithResult:self.searchResult];
    }
}

- (IBAction)invitePressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(invitePressedWithResult:)]) {
        [self.delegate invitePressedWithResult:self.searchResult];
    }
}
@end
