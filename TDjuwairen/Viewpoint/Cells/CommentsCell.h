//
//  CommentsCell.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/8.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloorInFloorView.h"

@protocol FloorInFloorViewDelegate <NSObject>

- (void)good:(UIButton *)sender;

@end
@interface CommentsCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImg;

@property (nonatomic,strong) UILabel *nickNameLab;

@property (nonatomic,strong) UILabel *numfloor;

@property (nonatomic,strong) UIButton *goodnumBtn;

@property (nonatomic,strong) UILabel *commentLab;

@property (nonatomic,strong) FloorInFloorView *floorView;

@property (nonatomic,strong) UILabel *line;

@property (nonatomic,copy) id<FloorInFloorViewDelegate>delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andArr:(NSArray *)arr;
@end
