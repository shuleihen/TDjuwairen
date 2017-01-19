//
//  StockShareView.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StockShareDelegate <NSObject>

- (void)sharePressed;
- (void)feedbackPressed;
@end

@interface StockShareView : UIView
@property (nonatomic, weak) id<StockShareDelegate> delegate;

- (void)showInContainView:(UIView *)containView;

@end
