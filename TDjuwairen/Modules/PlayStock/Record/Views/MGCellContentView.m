//
//  MyGuessCellContentView.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "MGCellContentView.h"

@implementation MGCellContentView


- (void)setupIndexGuessModel:(IndexStockRecordModel *)guess {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *label11 = [self normalLabel];
    label11.frame = CGRectMake(12, 0, 58, 15);
    label11.text = @"竞猜指数";
    [self addSubview:label11];
    
    UILabel *label12 = [self normalLabel];
    label12.frame = CGRectMake(84, 0, 100, 15);
    label12.text = [NSString stringWithFormat:@"%.2f",guess.buyPri];
    [self addSubview:label12];
    
    UILabel *label13 = [self normalLabel];
    label13.frame = CGRectMake(kScreenWidth/2+20, 0, 58, 15);
    label13.text = @"收盘指数";
    [self addSubview:label13];
    
    UILabel *label14 = [self normalLabel];
    label14.frame = CGRectMake(kScreenWidth/2+92, 0, 100, 15);
    label14.text = guess.isClosed?[NSString stringWithFormat:@"%.2f",guess.endPri]:@"--";
    [self addSubview:label14];
    
    
    UILabel *label21 = [self normalLabel];
    label21.frame = CGRectMake(12, 24, 58, 15);
    label21.text = @"下注数量";
    [self addSubview:label21];
    
    UILabel *label22 = [self orangeLabel];
    label22.frame = CGRectMake(84, 24, 100, 15);
    label22.text = [NSString stringWithFormat:@"%ld把钥匙",(long)guess.buyKeyNum];
    [self addSubview:label22];
    
    if (guess.status == 1 ||
        guess.status == 2) {
        // 获胜，完全获胜,才显示奖励倍数
        UILabel *label23 = [self normalLabel];
        label23.frame = CGRectMake(kScreenWidth/2+20, 24, 58, 15);
        label23.text = @"奖励倍数";
        [self addSubview:label23];
        
        UILabel *label24 = [self orangeLabel];
        label24.frame = CGRectMake(kScreenWidth/2+92, 24, 100, 15);
        label24.text = [NSString stringWithFormat:@"X%d",guess.odds];
        [self addSubview:label24];
    }
    
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2-TDPixel, 0, TDPixel, 40)];
    sep.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#eeeeee"];
    [self addSubview:sep];
}

- (void)setupIndividualGuessModel:(IndividualStockRecordModel *)guess {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *label11 = [self normalLabel];
    label11.frame = CGRectMake(12, 0, 58, 15);
    label11.text = @"竞猜指数";
    [self addSubview:label11];
    
    UILabel *label12 = [self normalLabel];
    label12.frame = CGRectMake(84, 0, 100, 15);
    label12.text = guess.guessPoint;
    [self addSubview:label12];
    
    UILabel *label13 = [self normalLabel];
    label13.frame = CGRectMake(kScreenWidth/2+20, 0, 58, 15);
    label13.text = @"收盘价";
    [self addSubview:label13];
    
    UILabel *label14 = [self normalLabel];
    label14.frame = CGRectMake(kScreenWidth/2+92, 0, 100, 15);
    label14.text = (guess.status == 0)?@"--":guess.endPrice;
    [self addSubview:label14];
    
    
    UILabel *label21 = [self normalLabel];
    label21.frame = CGRectMake(12, 24, 58, 15);
    label21.text = @"参与人数";
    [self addSubview:label21];
    
    UILabel *label22 = [self normalLabel];
    label22.frame = CGRectMake(84, 24, 100, 15);
    label22.text = [NSString stringWithFormat:@"%d",guess.joinNum];
    [self addSubview:label22];
    
    UILabel *label23 = [self normalLabel];
    label23.frame = CGRectMake(kScreenWidth/2+20, 24, 58, 15);
    label23.text = @"胜利人数";
    [self addSubview:label23];
    
    UILabel *label24 = [self normalLabel];
    label24.frame = CGRectMake(kScreenWidth/2+92, 24, 100, 15);
    label24.text = (guess.status == 0)?@"--":[NSString stringWithFormat:@"%d",guess.winnerNum];
    [self addSubview:label24];
    
    UILabel *label31 = [self normalLabel];
    label31.frame = CGRectMake(12, 48, 58, 15);
    label31.text = @"胜者奖励";
    [self addSubview:label31];
    
    UILabel *label32 = [self orangeLabel];
    label32.frame = CGRectMake(84, 48, 100, 15);
    label32.text = [NSString stringWithFormat:@"%d把钥匙",guess.winKeyNum];
    [self addSubview:label32];
    
    if (guess.extraKeyNum != 0) {
        UILabel *label33 = [self normalLabel];
        label33.frame = CGRectMake(kScreenWidth/2+20, 48, 58, 15);
        label33.text = @"额外奖励";
        [self addSubview:label33];
        
        UILabel *label34 = [self orangeLabel];
        label34.frame = CGRectMake(kScreenWidth/2+92, 48, 100, 15);
        label34.text = [NSString stringWithFormat:@"+%d把钥匙",guess.extraKeyNum];
        [self addSubview:label34];
    }
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2-TDPixel, 0, TDPixel, 63)];
    sep.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#eeeeee"];
    [self addSubview:sep];
}

- (UILabel *)normalLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
    
    return label;
}

- (UILabel *)orangeLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor hx_colorWithHexRGBAString:@"#EC9C1D"];
    
    return label;
}
@end
