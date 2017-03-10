//
//  AliveRoomHeaderView.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AliveRoomMasterModel;
typedef void(^BackBlock)();

@interface AliveRoomHeaderView : UIView
@property (strong, nonatomic) AliveRoomMasterModel *headerModel;
@property (copy, nonatomic) BackBlock  backBlock;

+ (instancetype)loadAliveRoomeHeaderView;

@end
