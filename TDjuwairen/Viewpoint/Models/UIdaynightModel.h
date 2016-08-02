//
//  UIdaynightModel.h
//  TDjuwairen
//
//  Created by 团大 on 16/7/28.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIdaynightModel : NSObject

@property (nonatomic, strong) UIColor *navigationColor; //导航栏背景色

@property (nonatomic, strong) UIColor *titleColor;// 标题颜色

@property (nonatomic, strong) UIColor *textColor; // 正文颜色

@property (nonatomic,strong) UIColor *backColor;//背景色

@property (nonatomic,strong) UIColor *lineColor;//分割线颜色


/**
 * 创建单例对象
 */
+(UIdaynightModel *)sharedInstance;

- (void)day;

- (void)night;

@end
