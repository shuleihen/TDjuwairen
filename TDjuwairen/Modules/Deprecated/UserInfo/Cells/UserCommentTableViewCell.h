//
//  UserCommentTableViewCell.h
//  TDjuwairen
//
//  Created by 团大 on 16/9/19.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloorInFloorView.h"

@interface UserCommentTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImg;

@property (nonatomic,strong) UILabel *nickNameLab;

@property (nonatomic,strong) UILabel *numfloor;

@property (nonatomic,strong) FloorInFloorView *floorView;

@property (nonatomic,strong) UILabel *commentLab;

@property (nonatomic,strong) UILabel *originalLab;

@property (nonatomic,strong) UILabel *line;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andArr:(NSArray *)arr;

@end
