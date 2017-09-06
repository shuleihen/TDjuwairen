//
//  PublishStockCodeInputTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/9/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PublishStockCodeInputTableViewCell.h"

@implementation PublishStockCodeInputTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-60, 2, 60, 40)];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:TDTitleTextColor forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cancelBtn];
        
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(12, 44-TDPixel, kScreenWidth-24, TDPixel)];
        sep.backgroundColor = TDSeparatorColor;
        [self.contentView addSubview:sep];
        
        _cancelBtn.hidden = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cancelPressed:(id)sender {
    [self.textField resignFirstResponder];
}
@end
