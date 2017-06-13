//
//  AliveListForwardSurveyView.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveListForwardModel.h"

@interface AliveListForwardSurveyView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *auhorLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) AliveListForwardModel *forwardModel;

@end
