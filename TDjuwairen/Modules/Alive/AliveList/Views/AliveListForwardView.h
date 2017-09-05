//
//  AliveListForwardView.h
//  TDjuwairen
//
//  Created by zdy on 2017/4/3.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlivePublishModel;
@interface AliveListForwardView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)setupAlive:(AlivePublishModel *)model;
@end
