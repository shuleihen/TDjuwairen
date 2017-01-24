//
//  PopupExchangeView.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ExchangeModel.h"

@protocol PopupExchangeViewDelegate <NSObject>

- (void)gotoImfomation:(UIButton *)sender;

- (void)closePopupExchangeView:(UIButton *)sender;

@end

@interface PopupExchangeView : UIView

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *duihuanImg;

@property (nonatomic, strong) UIImageView *prizeImg;

@property (nonatomic, strong) UILabel *prizeLab;

@property (nonatomic, strong) UIButton *goAwardBtn;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, assign) id<PopupExchangeViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame andWithModel:(ExchangeModel *)model;

@end
