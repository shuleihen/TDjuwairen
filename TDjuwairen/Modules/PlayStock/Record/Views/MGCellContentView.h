//
//  MyGuessCellContentView.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexStockRecordModel.h"
#import "IndividualStockRecordModel.h"

@interface MGCellContentView : UIView

- (void)setupIndexGuessModel:(IndexStockRecordModel *)guess;
- (void)setupIndividualGuessModel:(IndividualStockRecordModel *)guess;
@end
