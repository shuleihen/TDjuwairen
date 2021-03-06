//
//  PlayIndividualContentCell.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSIndividualListModel.h"
#import "StockManager.h"
#import "SGAdvertScrollView.h"

@class PlayIndividualContentCell;
@protocol PlayIndividualContentCellDelegate <NSObject>

- (void)playIndividualCell:(PlayIndividualContentCell *)cell guessPressed:(id)sender;
- (void)playIndividualCell:(PlayIndividualContentCell *)cell enjoyListPressed:(id)sender;
- (void)playIndividualCell:(PlayIndividualContentCell *)cell articlePressedWithIndex:(NSInteger)index;

@end

@interface PlayIndividualContentCell : UITableViewCell<SGAdvertScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UILabel *label_title;
@property (nonatomic, weak) IBOutlet UILabel *label_left;
@property (nonatomic, weak) IBOutlet UILabel *label_mid;
@property (nonatomic, weak) IBOutlet UILabel *label_right;
@property (nonatomic, weak) IBOutlet UILabel *label_enjoy;
@property (nonatomic, weak) IBOutlet UILabel *label_detailDesc;
@property (nonatomic, weak) IBOutlet UILabel *label_money;
@property (nonatomic, weak) IBOutlet UIButton *button_guess;
@property (weak, nonatomic) IBOutlet UIImageView *rewardView;
@property (weak, nonatomic) IBOutlet SGAdvertScrollView *articleView;


@property (nonatomic, weak) id<PlayIndividualContentCellDelegate> delegate;

@property (nonatomic, strong) PSIndividualListModel *model;

- (void)setupStock:(StockInfo *)stock;
@end
