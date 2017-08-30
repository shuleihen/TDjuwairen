//
//  DYRefreshImageView.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/8.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "DYRefreshBaseView.h"


@interface DYRefreshAliveView : DYRefreshBaseView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSArray *titleArray;
@end
