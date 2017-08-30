//
//  MemberCenterVipManager.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/30.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberCenterVipManager : NSObject
@property (nonatomic, weak) UIViewController *viewController;

// vip 解锁
- (void)unlockVipIsRenew:(BOOL)isRenew withController:(UIViewController *)controller;
@end
