//
//  UIViewController+NoData.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/27.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NoData)
- (void)setupNoDataImage:(UIImage *)image message:(NSString *)message;
- (void)showNoDataView:(BOOL)isShow;
@end
