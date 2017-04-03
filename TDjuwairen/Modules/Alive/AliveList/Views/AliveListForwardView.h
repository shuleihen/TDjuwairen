//
//  AliveListForwardView.h
//  TDjuwairen
//
//  Created by zdy on 2017/4/3.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@class AliveListForwardModel;
@interface AliveListForwardView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) TTTAttributedLabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)setupAliveForward:(AliveListForwardModel *)foward;
@end
