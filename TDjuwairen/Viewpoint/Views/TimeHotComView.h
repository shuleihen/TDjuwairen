//
//  TimeHotComView.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/8.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeHotComViewDelegate <NSObject>

- (void)justLouzhu:(UIButton *)sender;
- (void)selectTime:(UIButton *)sender;
- (void)selectHot:(UIButton *)sender;
@end

@interface TimeHotComView : UIView

@property (nonatomic,strong) UIButton *timeBtn;

@property (nonatomic,strong) UIButton *hotBtn;

@property (nonatomic,strong) UIButton *louzhu;
@property (nonatomic,strong) UIButton *just;

@property (nonatomic,assign) id<TimeHotComViewDelegate>delegate;
@end
