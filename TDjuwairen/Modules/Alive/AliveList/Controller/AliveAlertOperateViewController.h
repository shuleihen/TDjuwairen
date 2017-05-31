//
//  AliveAlertOperateViewController.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/31.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AliveAlertOperateViewControllerDelegate <NSObject>

- (void)alertSelectedWithIndex:(NSInteger)index andTitle:(NSString *)titleStr;

@end

@interface AliveAlertOperateViewController : UIViewController
@property (strong, nonatomic) NSArray *sourceArr;
@property (assign, nonatomic) id<AliveAlertOperateViewControllerDelegate> delegate;
- (CGFloat)tableViewHeight;

@end
