//
//  SurveyListTableViewCell.h
//  TDjuwairen
//
//  Created by 团大 on 16/10/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyListTableViewCell : UITableViewCell

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UILabel *stockName;

@property (nonatomic,strong) UILabel *nowPri;

@property (nonatomic,strong) UILabel *increPer;

@property (nonatomic,strong) UILabel *increase;

@property (nonatomic,strong) UIImageView *stockImg;

@property (nonatomic,strong) UILabel *line;

@property (nonatomic,strong) UILabel *stockSurvey;

@end
