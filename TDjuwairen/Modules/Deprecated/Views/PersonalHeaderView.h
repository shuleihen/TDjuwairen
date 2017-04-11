//
//  PersonalHeaderView.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/9.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalHeaderView : UIView
@property (nonatomic,strong) UIImageView *backImg;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *nickname;

- (void)addTarget:(id)target action:(SEL)action;
@end
