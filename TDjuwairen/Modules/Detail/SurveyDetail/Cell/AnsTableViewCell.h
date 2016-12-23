//
//  AnsTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnsModel.h"

@interface AnsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

+ (CGFloat)heightWithContent:(NSString *)content isFirst:(BOOL)isFirst;

- (void)setupAns:(AnsModel *)ans;
@end
