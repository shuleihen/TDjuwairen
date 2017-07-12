//
//  MyGuessCell.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexStockRecordModel.h"
#import "IndividualStockRecordModel.h"
#import "MGCellWinKeyView.h"
#import "MGCellContentView.h"

@interface MyGuessCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *guessNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet MGCellWinKeyView *winKeyView;
@property (weak, nonatomic) IBOutlet MGCellContentView *detailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *winkeyViewHeight;


- (void)setupIndexGuessModel:(IndexStockRecordModel *)guess;
- (void)setupIndividualGuessModel:(IndividualStockRecordModel *)guess;
@end
