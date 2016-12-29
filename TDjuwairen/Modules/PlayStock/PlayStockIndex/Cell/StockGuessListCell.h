//
//  StockGuessListCell.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockWheelView.h"
#import "StockGuessModel.h"
#import "StockManager.h"

@interface StockGuessListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet StockWheelView *stockWheel;
@property (weak, nonatomic) IBOutlet UILabel *nowPriLabel;
@property (weak, nonatomic) IBOutlet UILabel *valuePriLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueBLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *guessBtn;

@property (copy, nonatomic) void (^guessBtnBlock)(void);

- (void)setupGuessInfo:(StockGuessModel *)stockGuess;
- (void)setupStock:(StockInfo *)stock;

- (void)reloadTimeWithGuess:(StockGuessModel *)stockGuess;

- (CGPoint)pointWithPri:(CGFloat)pri;
@end
