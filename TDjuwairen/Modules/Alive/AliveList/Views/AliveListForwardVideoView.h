//
//  AliveListForwardVideoView.h
//  TDjuwairen
//
//  Created by zdy on 2017/9/4.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveListModel.h"

@interface AliveListForwardVideoView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) AliveListModel *aliveModel;
@end
