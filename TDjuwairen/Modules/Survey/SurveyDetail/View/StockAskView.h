//
//  StockAskView.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StockAskDelegate <NSObject>
- (void)askSendWithContent:(NSString *)content;
@end

@interface StockAskView : UIView
@property (nonatomic, strong) id<StockAskDelegate> delegate;
- (void)showInContainView:(UIView *)containView;
@end
