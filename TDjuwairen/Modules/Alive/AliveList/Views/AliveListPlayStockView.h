//
//  AliveListPlayStockView.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListContentView.h"

@protocol AliveListPlayStockViewDelegate <NSObject>
- (void)playStockPressed:(id)sender;

@end

@interface AliveListPlayStockView : AliveListContentView
@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) UILabel *stockNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, weak) id<AliveListPlayStockViewDelegate> delegate;
@end
