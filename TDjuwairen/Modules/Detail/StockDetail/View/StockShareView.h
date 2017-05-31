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
/// 收藏
- (void)collectionPressed;
@end

@interface StockShareView : UIView
@property (nonatomic, weak) id<StockShareDelegate> delegate;
@property (assign, nonatomic) BOOL isCollection;

- (void)showInContainView:(UIView *)containView;

@end
