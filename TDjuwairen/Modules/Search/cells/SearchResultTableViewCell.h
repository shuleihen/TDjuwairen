//
//  SearchResultTableViewCell.h
//  TDjuwairen
//
//  Created by 团大 on 16/6/1.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultModel.h"

@protocol SearchResultCellDelegate <NSObject>

- (void)gradePressedWithResult:(SearchResultModel *)model;
- (void)addStockPressedWithResult:(SearchResultModel *)model;
- (void)invitePressedWithResult:(SearchResultModel *)model;
@end

@interface SearchResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsWidth;
@property (nonatomic, strong) SearchResultModel *searchResult;
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *inviteBtn;
@property (nonatomic, weak) IBOutlet UIButton *addBtn;
@property (nonatomic, assign) BOOL isStock;

@property (nonatomic, weak) id<SearchResultCellDelegate> delegate;
@end
