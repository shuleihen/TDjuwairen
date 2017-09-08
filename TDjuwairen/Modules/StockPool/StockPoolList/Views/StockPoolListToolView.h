//
//  StockPoolListToolView.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StockPoolListToolViewDelegate <NSObject>

- (void)settingPressed:(id)sender;
- (void)draftPressed:(id)sender;
- (void)publishPressed:(id)sender;
- (void)attentionPressed:(id)sender;
@end

@interface StockPoolListToolView : UIView
@property (nonatomic, weak) id<StockPoolListToolViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UIImageView *stockPoolDescTipImageView;
- (void)hidTipImageView;
- (void)hidSPDescTipImageView;
@end
