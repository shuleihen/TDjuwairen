//
//  AskTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AskModel.h"

@interface AskTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *askBtn;
@property (copy, nonatomic) void (^askBlcok)(void);

+ (CGFloat)heightWithContent:(NSString *)content;
- (void)setupAsk:(AskModel *)ask;


@end
