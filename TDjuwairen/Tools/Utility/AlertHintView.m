//
//  AlertHintView.m
//  TDjuwairen
//
//  Created by 团大 on 2016/12/8.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AlertHintView.h"

#import "Masonry.h"
#import "NSString+Ext.h"
#import "UIdaynightModel.h"

@interface AlertHintView ()

@property (nonatomic, copy) clearBlock clear_Block;

@property (nonatomic, copy) delectBlock delect_Block;

@end

@implementation AlertHintView

- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title Alert:(NSString *)alert cancel:(NSString *)cancel sure:(NSString *)sure
{
    if (self = [super initWithFrame:frame]) {
        
        UIdaynightModel *daynightModel = [UIdaynightModel sharedInstance];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.5;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = daynightModel.navigationColor;

        UILabel *titLab = [[UILabel alloc] init];
        titLab.font = [UIFont systemFontOfSize:18];
        titLab.textColor = daynightModel.titleColor;
        
        UILabel *alertLab = [[UILabel alloc] init];
        alertLab.text = alert;
        alertLab.font = [UIFont systemFontOfSize:16];
        alertLab.textColor = daynightModel.titleColor;
        
        UIButton *clear = [[UIButton alloc] init];
        [clear setTitle:cancel forState:UIControlStateNormal];
        [clear setTitleColor:daynightModel.titleColor forState:UIControlStateNormal];
        [clear addTarget:self action:@selector(clickClear:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *delect = [[UIButton alloc] init];
        [delect setTitle:sure forState:UIControlStateNormal];
        [delect setTitleColor:daynightModel.titleColor forState:UIControlStateNormal];
        [delect addTarget:self action:@selector(clickDelect:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:backView];
        [self addSubview:view];
        [self addSubview:titLab];
        [self addSubview:alertLab];
        [self addSubview:clear];
        [self addSubview:delect];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(kScreenWidth-50);
        }];
        
        UIFont *font = [UIFont systemFontOfSize:18];
        CGSize titlesize = CGSizeMake(kScreenWidth-50, 500.0);
        titlesize = [title calculateSize:titlesize font:font];
        [titLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).with.offset(25);
            make.left.equalTo(view).with.offset(15);
            make.width.mas_equalTo(titlesize.width);
            make.height.mas_equalTo(titlesize.height);
        }];
        
        UIFont *alertFont = [UIFont systemFontOfSize:16];
        CGSize alertsize = CGSizeMake(kScreenWidth-50, 500.0);
        alertsize = [alert calculateSize:alertsize font:alertFont];
        [alertLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titLab.mas_bottom).with.offset(25);
            make.left.equalTo(view).with.offset(15);
            make.width.mas_equalTo(alertsize.width);
            make.height.mas_equalTo(alertsize.height);
        }];
        
        [delect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertLab.mas_bottom).with.offset(25);
            make.right.equalTo(view).with.offset(-15);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(30);
        }];
        
        [clear mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertLab.mas_bottom).with.offset(25);
            make.right.equalTo(delect.mas_left).with.offset(-15);
            make.bottom.equalTo(view).with.offset(-25);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

+ (instancetype)alterViewWithTitle:(NSString *)title content:(NSString *)content cancel:(NSString *)cancel sure:(NSString *)sure cancelBtClcik:(clearBlock)clear sureBtClcik:(delectBlock)delect
{
    AlertHintView *view = [[AlertHintView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) WithTitle:title Alert:content cancel:cancel sure:sure];
    view.clear_Block = clear;
    view.delect_Block = delect;
    return view;
}

- (void)clickClear:(UIButton *)sender{
//    [self removeFromSuperview];
    if (self.clear_Block) {
        self.clear_Block(self);
    }
}

- (void)clickDelect:(UIButton *)sender{
//    [self removeFromSuperview];
    if (self.delect_Block) {
        self.delect_Block(self);
    }
}

@end
