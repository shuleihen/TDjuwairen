//
//  TDPopuMenuViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDPopupMenuViewController;
@protocol TDPopupMenuDelegate <NSObject>

- (void)popupMenu:(TDPopupMenuViewController *)popupMenu withIndex:(NSInteger)selectedIndex;

@end

@interface TDPopupMenuViewController : UIViewController

@property (strong, nonatomic) UIImage *backImg;
@property (nonatomic, weak) id<TDPopupMenuDelegate> delegate;
@end
