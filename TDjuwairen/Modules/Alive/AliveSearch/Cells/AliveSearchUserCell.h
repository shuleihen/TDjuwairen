//
//  AliveSearchUserCell.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/26.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AliveSearchResultModel;

@protocol AliveSearchUserCellDelegate <NSObject>
- (void)addAttendWithAliveSearchResultModel:(AliveSearchResultModel *)userModel andCellIndex:(NSInteger)index;
@end

@interface AliveSearchUserCell : UITableViewCell
@property (strong, nonatomic) AliveSearchResultModel *userModel;
@property (weak, nonatomic) id<AliveSearchUserCellDelegate> delegate;

+ (instancetype)loadAliveSearchUserCellWithTableView:(UITableView *)tableView;
@end
