//
//  MyGuessCell.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MyGuessCell.h"
#import "HexColors.h"

@implementation MyGuessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupGuessInfo:(MyGuessModel *)guess {
    self.guessNameLabel.text = guess.stockName;
    self.dateLabel.text = guess.addTime;
    self.sessionLabel.text = guess.seasonString;
    
    self.guessIndexLabel.text = [NSString stringWithFormat:@"%.02f",guess.buyPri];
    
    if (guess.isClosed) {
        self.realIndexLabel.text = [NSString stringWithFormat:@"%.02f",guess.endPri];
    } else {
        self.realIndexLabel.text = @"--";
    }
    
    NSString *key = [NSString stringWithFormat:@"x %ld",(long)guess.buyKeyNum];
    [self.betBtn setTitle:key forState:UIControlStateNormal];
    [self.betBtn setTitle:key forState:UIControlStateHighlighted];
    
    [self.statusBtn setTitle:guess.statusString forState:UIControlStateNormal];
    [self.statusBtn setTitle:guess.statusString forState:UIControlStateHighlighted];
    
    if (guess.status == 0) {
        // 为结算
        [self.statusBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#ff0000"] forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#ff0000"] forState:UIControlStateHighlighted];
        
        [self.statusBtn setImage:[UIImage imageNamed:@"icon_waiting.png"] forState:UIControlStateNormal];
        [self.statusBtn setImage:[UIImage imageNamed:@"icon_waiting.png"] forState:UIControlStateHighlighted];
    } else if (guess.status == 1 ||
               guess.status == 2) {
        // 完全猜中,获胜钥匙
        [self.statusBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#ff0000"] forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#ff0000"] forState:UIControlStateHighlighted];
        
        [self.statusBtn setImage:nil forState:UIControlStateNormal];
        [self.statusBtn setImage:nil forState:UIControlStateHighlighted];
    } else if (guess.status == 3 ||
               guess.status == 4) {
        // 3表示失败 4表示平局
        [self.statusBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#999999"] forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#999999"] forState:UIControlStateHighlighted];
        
        [self.statusBtn setImage:nil forState:UIControlStateNormal];
        [self.statusBtn setImage:nil forState:UIControlStateHighlighted];
    }
}
@end
