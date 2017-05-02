//
//  PublishSelectedStockCell.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/4/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchCompanyListModel;

@protocol PublishSelectedStockCellDelegate <NSObject>

- (void)deletePublishSelectedCell:(id)model;

@end


@interface PublishSelectedStockCell : UITableViewCell
@property (strong, nonatomic) SearchCompanyListModel *stockModel;

@property (weak, nonatomic) id<PublishSelectedStockCellDelegate> delegate;
+ (instancetype)loadPublishSelectedStockCellWithTableView:(UITableView *)tableView;

@end
