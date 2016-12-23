//
//  NiuxiongTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockCommentModel.h"

@interface NiuxiongTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *favourBtn;
@property (copy, nonatomic) void (^favourBlcok)(UIButton *);

+ (CGFloat)heightWithContent:(NSString *)content;
- (void)setupComment:(StockCommentModel *)comment;
@end
