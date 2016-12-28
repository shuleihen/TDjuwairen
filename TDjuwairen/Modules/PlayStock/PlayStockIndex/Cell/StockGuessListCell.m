//
//  StockGuessListCell.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockGuessListCell.h"

@implementation StockGuessListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)guessPressed:(id)sender {
    if (self.guessBtnBlock) {
        self.guessBtnBlock();
    }
}

- (void)setupGuessInfo:(StockGuessModel *)stockGuess {
    self.stockWheel.type = stockGuess.type;
    self.stockNameLabel.text = stockGuess.stockName;
    
    if (stockGuess.season == 1) {
        self.sessionLabel.text = @"上午场";
    } else if (stockGuess.season == 2) {
        self.sessionLabel.text = @"下午场";
    }
    
    NSString *time = [self intervalNowDateWithDateInterval:stockGuess.endTime];
    self.timeLabel.text = [NSString stringWithFormat:@"剩余时间 %@",time];
    
    self.guessBtn.enabled = !stockGuess.isClosed;
}

- (void)setupStock:(StockInfo *)stock {
    float value = [stock priValue];            //跌涨额
    float valueB = [stock priPercentValue];     //跌涨百分比
    NSString *nowPriString = [NSString stringWithFormat:@"%+.2lf",stock.nowPriValue];
    
    self.nowPriLabel.text = nowPriString;
    self.valuePriLabel.text = [NSString stringWithFormat:@"%+.2lf",value];
    self.valueBLabel.text = [NSString stringWithFormat:@"%+.2lf%%",valueB*100];
    self.stockWheel.index = stock.nowPriValue;
}

- (NSString *)intervalNowDateWithDateInterval:(NSTimeInterval)endTime {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval cha = endTime-now;

    NSString *sen = [NSString stringWithFormat:@"%d", (int)cha%60];
    NSString *min = [NSString stringWithFormat:@"%d", (int)cha/60%60];
    NSString *house = [NSString stringWithFormat:@"%d", (int)cha/3600];
    
    return [NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
}
@end
