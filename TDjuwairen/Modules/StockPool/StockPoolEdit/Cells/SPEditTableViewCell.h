//
//  SPEditTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/15.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPEditTableViewCell;
@protocol SPEditTableViewCellDelegate <NSObject>

- (void)spEditTableViewCell:(SPEditTableViewCell *)cell optionPressed:(id)sender;
@end

@interface SPEditTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *stockNameField;
@property (weak, nonatomic) IBOutlet UITextField *percentageField;
@property (weak, nonatomic) IBOutlet UIButton *optionBtn;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, weak) id<SPEditTableViewCellDelegate> delegate;
@end
