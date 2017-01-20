//
//  BearBullSelBtnView.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/9.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BearBullSelBtnViewDelegate <NSObject>

- (void)selBearBull:(UIButton *)sender;

@end

@interface BearBullSelBtnView : UIView

@property (nonatomic,strong) UIButton *bullBtn;

@property (nonatomic,strong) UILabel *bullSel;

@property (nonatomic,strong) UIButton *bearBtn;

@property (nonatomic,strong) UILabel *bearSel;

@property (nonatomic,assign) id<BearBullSelBtnViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame andRatio:(CGFloat)bullRadio;

@end
