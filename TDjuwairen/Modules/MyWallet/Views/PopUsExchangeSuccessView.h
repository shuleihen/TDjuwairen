//
//  PopUsExchangeSuccessView.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ExchangeModel.h"

@protocol PopUsExchangeSuccessViewDelegate <NSObject>

- (void)clickCloseSuccessView:(UIButton *)sender;
@end

@interface PopUsExchangeSuccessView : UIView

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *duihuanImg;

@property (nonatomic, strong) UIImageView *prizeImg;

@property (nonatomic, strong) UILabel *prizeLab;

@property (nonatomic, strong) UIButton *goAwardBtn;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) id<PopUsExchangeSuccessViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame andWithModel:(ExchangeModel *)model;


@end
