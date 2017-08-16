//
//  SPEditTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/15.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPEditRecordModel.h"

@class SPEditTableViewCell;
@protocol SPEditTableViewCellDelegate <NSObject>
- (void)spEditTableViewCell:(SPEditTableViewCell *)cell stockNamePressed:(id)sender;
- (void)spEditTableViewCell:(SPEditTableViewCell *)cell optionPressed:(id)sender;
@end

@interface SPEditTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *stockNameBtn;
@property (weak, nonatomic) IBOutlet UITextField *percentageField;
@property (weak, nonatomic) IBOutlet UIButton *optionBtn;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, weak) id<SPEditTableViewCellDelegate> delegate;
@property (nonatomic, strong) SPEditRecordModel *model;
@end
