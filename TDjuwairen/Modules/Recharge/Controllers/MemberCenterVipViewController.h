//
//  MemberCenterVipViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/29.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberCenterVipModel;
@protocol MemberCenterVipDelegate <NSObject>

- (void)didSelectedWithMemberCenterVipModel:(MemberCenterVipModel *)vipModel;

@end

@interface MemberCenterVipViewController : UIViewController
@property (nonatomic, assign) BOOL isRenew;
@property (nonatomic, strong) NSArray *vipList;
@property (nonatomic, weak) id<MemberCenterVipDelegate> delegate;
@end
