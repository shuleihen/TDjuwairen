//
//  PlayStockCommentCell.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/26.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuessCommentModel.h"

@interface GuessCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subContentHeight;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)setupGuessComment:(GuessCommentModel *)guessComment;
@end
