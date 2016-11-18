//
//  SelWXOrAlipayView.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelWXOrAlipayViewDelegate <NSObject>

- (void)closeSelWXOrAlipayView:(UIButton *)sender;

- (void)didSelectWXOrZhifubao:(NSIndexPath *)indePath;

@end

@interface SelWXOrAlipayView : UIView

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UIView *showView;

@property (nonatomic,assign) id<SelWXOrAlipayViewDelegate>delegate;

@end
