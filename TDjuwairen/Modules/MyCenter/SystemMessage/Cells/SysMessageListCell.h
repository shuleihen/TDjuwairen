//
//  SysMessageListCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/18.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SysMessageListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLableWidth;

@property (nonatomic, copy) void (^deleteBlock)(void);
@end
