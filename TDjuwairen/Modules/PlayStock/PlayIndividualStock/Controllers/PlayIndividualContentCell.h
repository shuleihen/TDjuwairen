//
//  PlayIndividualContentCell.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^guessButtonBlock)(UIButton *btn);
typedef void(^guessEnjoyBlock)();
typedef void(^guessMoneyBlock)();
@interface PlayIndividualContentCell : UITableViewCell

+ (instancetype)loadCell;

@property (nonatomic, copy) guessButtonBlock guessBlock;
@property (nonatomic, copy) guessEnjoyBlock enjoyBlock;
@property (nonatomic, copy) guessMoneyBlock moneyBlock;
@end
