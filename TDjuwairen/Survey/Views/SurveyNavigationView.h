//
//  SurveyNavigationView.h
//  TDjuwairen
//
//  Created by 团大 on 16/5/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchButtonBlock)();
@interface SurveyNavigationView : UIView

@property (nonatomic,strong) UIImageView *logoImage; //logo;
@property (nonatomic,strong) UIButton *searchButton;       //搜索按钮
@property (nonatomic,strong) UILabel *line;

@property (nonatomic,copy) SearchButtonBlock block;

@end
