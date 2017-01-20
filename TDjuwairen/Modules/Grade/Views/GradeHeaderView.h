//
//  GradeHeanderView.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeView.h"
#import "GradeDetailModel.h"

@interface GradeHeaderView : UIView

@property (nonatomic, strong) UILabel *stockNameLabel;
@property (nonatomic, strong) UILabel *stockIdLabel;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) GradeView *gradeView;

- (void)setupGradeModel:(GradeDetailModel *)model;
@end
