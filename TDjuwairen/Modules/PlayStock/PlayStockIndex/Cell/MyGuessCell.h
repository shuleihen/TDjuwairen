//
//  MyGuessCell.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyGuessCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionLabel;
@property (weak, nonatomic) IBOutlet UILabel *guessIndexLabel;
@property (weak, nonatomic) IBOutlet UILabel *realIndexLabel;
@property (weak, nonatomic) IBOutlet UIButton *betBtn;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@end
