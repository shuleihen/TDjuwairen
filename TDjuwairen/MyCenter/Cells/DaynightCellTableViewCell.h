//
//  DaynightCellTableViewCell.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/15.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DaynightCellTableViewCellDelegate <NSObject>

- (void) updateSwitchAtIndexPath:(id) sender;

@end
@interface DaynightCellTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UISwitch *mySwitch;
@property (nonatomic,assign) id<DaynightCellTableViewCellDelegate>delegate;

- (void) updateSwitchAtIndexPath:(id) sender;

@end
