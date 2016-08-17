//
//  ResponsListTableViewCell.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/12.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResponsListTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headimg;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,assign) int viewheight;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andArr:(NSDictionary *)dic;

@end
