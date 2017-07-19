//
//  MyGuessCell.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MyGuessCell.h"
#import "HexColors.h"
#import "PlayStockHnadler.h"

@implementation MyGuessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    
    self.detailView.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setupIndexGuessModel:(IndexStockRecordModel *)guess {
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",guess.addTime, [PlayStockHnadler stringWithSeason:guess.season]];
    
    switch (guess.status) {
        case 0:
            // 进行中
            self.statusLabel.text = @"竞猜中";
            self.statusLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#3371E2"];
            break;
        case 1:
            // 完全猜中
            self.statusLabel.text = @"完全猜中 获胜";
            self.statusLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#446F14"];
            break;
        case 2:
            // 获胜
            self.statusLabel.text = @"获胜";
            self.statusLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#446F14"];
            break;
        case 3:
            // 失败
            self.statusLabel.text = @"未获胜";
            self.statusLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#446F14"];
            break;
        case 4:
            // 平局
            self.statusLabel.text = @"平局";
            self.statusLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#446F14"];
            break;
        default:
            break;
    }
    
    self.guessNameLabel.text = guess.stockName;
    
    if (guess.isWin) {
        NSString *winString = [NSString stringWithFormat:@"获得%ld把", guess.buyKeyNum*guess.odds];
        CGSize size = [winString boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f]} context:nil].size;
        self.winkeyViewHeight.constant = size.width+30+6;
        self.winKeyView.statusString = winString;
    } else {
        self.winkeyViewHeight.constant = 0;
        self.winKeyView.statusString = @"";
    }
    
    [self.detailView setupIndexGuessModel:guess];
}

- (void)setupIndividualGuessModel:(IndividualStockRecordModel *)guess {
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",guess.addTime, [PlayStockHnadler stringWithSeason:guess.season]];
    
    switch (guess.status) {
        case 0:
            // 进行中
            self.statusLabel.text = @"竞猜中";
            self.statusLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#3371E2"];
            break;
        case 1:
            // 完全猜中
            self.statusLabel.text = @"完全猜中 获胜";
            self.statusLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#446F14"];
            break;
        case 2:
            // 获胜
            self.statusLabel.text = @"获胜";
            self.statusLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#446F14"];
            break;
        case 3:
            // 失败
            self.statusLabel.text = @"未获胜";
            self.statusLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#446F14"];
            break;
        case 4:
            // 平局
            self.statusLabel.text = @"平局";
            self.statusLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#446F14"];
            break;
        default:
            break;
    }
    
    self.guessNameLabel.text = [NSString stringWithFormat:@"%@(%@)",guess.stockName, guess.stockCode];
    
    if (guess.isWin) {
        NSString *winString = [NSString stringWithFormat:@"获得%ld把", (guess.winKeyNum+guess.extraKeyNum)];
        CGSize size = [winString boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f]} context:nil].size;
        self.winkeyViewHeight.constant = size.width+30+6;
        self.winKeyView.statusString = winString;
    } else {
        self.winkeyViewHeight.constant = 0;
        self.winKeyView.statusString = @"";
    }
    
    [self.detailView setupIndividualGuessModel:guess];
}

@end
