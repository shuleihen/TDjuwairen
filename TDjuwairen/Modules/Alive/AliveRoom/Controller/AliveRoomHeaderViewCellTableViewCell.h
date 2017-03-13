//
//  AliveRoomHeaderViewCellTableViewCell.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    ButtonAttentionType     =0, // 关注
    ButtonFansType  =1 // 粉丝
} ButtonType;


@class AliveRoomMasterModel;

typedef void(^AttentionBtnClickBlock)(ButtonType btnType);


@interface AliveRoomHeaderViewCellTableViewCell : UITableViewCell
@property (strong, nonatomic) AliveRoomMasterModel *headerModel;
@property (copy, nonatomic) AttentionBtnClickBlock  btnClickBlock;

+ (instancetype)AliveRoomHeaderViewCellTableViewCell:(UITableView *)tableView;
@end
