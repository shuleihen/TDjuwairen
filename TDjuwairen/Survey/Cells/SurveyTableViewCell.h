//
//  SurveyTableViewCell.h
//  TDjuwairen
//
//  Created by 团大 on 16/5/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UIImageView *userhead;
@property (weak, nonatomic) IBOutlet UILabel *usernickname;
@property (weak, nonatomic) IBOutlet UIImageView *comment;
@property (weak, nonatomic) IBOutlet UILabel *commentnumber;

@property (nonatomic,strong) UIView *labelbackview;

@end
