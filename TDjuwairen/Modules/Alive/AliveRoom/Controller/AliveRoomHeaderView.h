//
//  AliveRoomHeaderView.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AliveRoomMasterModel;
typedef enum : NSUInteger {
    ButtonAttentionType     =0, // 关注
    ButtonFansType  =1 // 粉丝
} ButtonType;

typedef void(^BackBlock)();
typedef void(^AttentionButtonClickBlock)(ButtonType btnType);


typedef void(^AddAttentionBlock)(BOOL addAttention);

@interface AliveRoomHeaderView : UIView
@property (strong, nonatomic) AliveRoomMasterModel *headerModel;
@property (copy, nonatomic) BackBlock  backBlock;
@property (copy, nonatomic) AttentionButtonClickBlock  btnClickBlock;
@property (copy, nonatomic) AddAttentionBlock  addAttentionBlock;

+ (instancetype)loadAliveRoomeHeaderView;

@end
