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

- (void)setIsAdd:(BOOL)isAdd {
    _isAdd = isAdd;
    
    if (isAdd) {
        [self.addBtn setTitle:@"已添加" forState:UIControlStateNormal];
        [self.addBtn setImage:nil forState:UIControlStateNormal];
    } else {
        [self.addBtn setTitle:nil forState:UIControlStateNormal];
        [self.addBtn setImage:[UIImage imageNamed:@"add_shares2.png"] forState:UIControlStateNormal];
    }
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
