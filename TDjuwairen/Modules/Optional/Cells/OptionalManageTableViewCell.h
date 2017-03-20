//
//  OptionalManageTableViewCell.h
//  TDjuwairen
//
//  Created by 团大 on 2016/12/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ManageCellDelegate <NSObject>

- (void)delectThisCell:(UIButton *)sender;

- (void)longPress:(UIGestureRecognizer*)recognizer;

- (void)topPan:(UIGestureRecognizer*)recognizer;

@end

@interface OptionalManageTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLab;

@property (nonatomic,strong) UILabel *codeLab;

@property (nonatomic,assign) id<ManageCellDelegate>delegate;

@end
