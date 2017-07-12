//
//  StockGuessListCell.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockGuessListCell.h"
#import "HexColors.h"

@implementation StockGuessListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([UIScreen mainScreen].bounds.size.width <= 320) {
        // iPhone 5 以下此次
        self.wheelImageView.frame = CGRectMake(100-60, 80-60, 60*2, 127);
        self.leftContentHeight.constant = 108.0f;
    } else {
        self.wheelImageView.frame = CGRectMake(125-75.5, 80-75.5, 75.5*2, 160);
        self.leftContentHeight.constant = 112.0f;
    }
    
    UIImage *image1 = [UIImage imageNamed:@"icon_turntable.png"];
    UIImage *image2 = [UIImage imageNamed:@"icon_turntable2.png"];
    UIImage *image3 = [UIImage imageNamed:@"icon_turntable.png"];
    self.wheelImageView.animationImages = @[image1,image2,image3];
    self.wheelImageView.animationDuration = 0.5f;
    self.wheelImageView.animationRepeatCount = 1;
    self.isShowImageAnimation = NO;
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
    self.stockWheel.buyIndexs = stockGuess.guessPoints;
    self.guessBtn.enabled = !stockGuess.isClosed;
    
    /*
    BOOL isToday = [self isTodayWithEndTime:stockGuess.endTime];
    
    if (stockGuess.season == 1) {
        self.sessionLabel.text = isToday?@"今日上午场":@"明天上午场";
    } else if (stockGuess.season == 2) {
        self.sessionLabel.text = isToday?@"今日下午场":@"明天下午场";
    }
    
    NSString *time = [self intervalNowDateWithDateInterval:stockGuess.endTime];
    self.timeLabel.text = [NSString stringWithFormat:@"剩余时间 %@",time];
    */
}

- (void)setupStock:(StockInfo *)stock {
    float value = [stock priValue];            //跌涨额
    float valueB = [stock priPercentValue];     //跌涨百分比
    
    if (value >= 0.00) {
        self.nowPriLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#e64920"];
        self.valuePriLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#e64920"];
        self.valueBLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#e64920"];
        
    } else {
        self.nowPriLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#1fcc67"];
        self.valuePriLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#1fcc67"];
        self.valueBLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#1fcc67"];
    }
    
    NSString *nowPriString = [NSString stringWithFormat:@"%.2lf",stock.nowPriValue];
    
    self.nowPriLabel.text = nowPriString;
    self.valuePriLabel.text = [NSString stringWithFormat:@"%+.2lf",value];
    self.valueBLabel.text = [NSString stringWithFormat:@"%+.2lf%%",valueB*100];
    self.stockWheel.index = stock.nowPriValue;
    
    if (self.isShowImageAnimation) {
        [self.wheelImageView startAnimating];
        self.isShowImageAnimation = NO;
    }
}

- (void)reloadTimeWithGuess:(StockGuessModel *)stockGuess {
    /*
    NSString *time = [self intervalNowDateWithDateInterval:stockGuess.endTime];
    self.timeLabel.text = [NSString stringWithFormat:@"剩余时间 %@",time];
     */
}

- (BOOL)isTodayWithEndTime:(NSTimeInterval)endTime {
    BOOL isToday = YES;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:endTime];
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateCom = [calendar components:NSCalendarUnitDay fromDate:date];
    NSDateComponents *nowCom = [calendar components:NSCalendarUnitDay fromDate:now];
    
    isToday = dateCom.day == nowCom.day;
    
    return isToday;
}

- (NSString *)intervalNowDateWithDateInterval:(NSTimeInterval)endTime {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval cha = ((endTime-now)>0)?(endTime-now):0;

    NSString *sen = [NSString stringWithFormat:@"%02d", (int)cha%60];
    NSString *min = [NSString stringWithFormat:@"%02d", (int)cha/60%60];
    NSString *house = [NSString stringWithFormat:@"%02d", (int)cha/3600];
    
    return [NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
}

- (CGPoint)pointWithPri:(CGFloat)pri {
    CGPoint point = [self.stockWheel pointWithPri:pri];
    
//    return [self convertPoint:point toView:[UIApplication sharedApplication].keyWindow];
    return CGPointMake(point.x, point.y+45);
}
@end
