//
//  RechargeView.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RechargeViewDelegate <NSObject>

- (void)closeRechargeView:(UIButton *)sender;

- (void)clickRecharge:(UIButton *)sender;

@end

@interface RechargeView : UIView

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UIView *showView;

@property (nonatomic,assign) id<RechargeViewDelegate>delegate;

@end
