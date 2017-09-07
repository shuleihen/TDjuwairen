//
//  PublishForwardTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/9/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlivePublishModel.h"

@interface PublishForwardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *forwardImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

- (void)setupPublishModel:(AlivePublishModel *)model withPublishType:(NSInteger)publishType;
@end
