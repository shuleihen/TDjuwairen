//
//  ViewPointTableViewCell.h
//  TDjuwairen
//
//  Created by 团大 on 16/7/25.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewPointTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImgView;// 头像

@property (nonatomic,strong) UILabel *nicknameLabel;//包含时间

@property (nonatomic,strong) UILabel *nature;//官方非官方

@property (nonatomic,strong) UILabel *titleLabel;//标题

@end
