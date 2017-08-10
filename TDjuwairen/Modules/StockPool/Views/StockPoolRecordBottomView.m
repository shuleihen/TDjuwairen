//
//  StockPoolRecordBottomView.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 2017/8/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolRecordBottomView.h"

@interface StockPoolRecordBottomView ()
/// 设置按钮
@property (strong, nonatomic) UIButton *settingBtn;
/// 草稿箱按钮
@property (strong, nonatomic) UIButton *draftBtn;
/// 记账按钮
@property (strong, nonatomic) UIButton *bookKeepingBtn;
/// 订阅按钮
@property (strong, nonatomic) UIButton *subscribeBtn;


@end

@implementation StockPoolRecordBottomView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingBtn setImage:[UIImage imageNamed:@"ico_setting"] forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _settingBtn.frame = CGRectMake(22, 14.5, 22, 20);
        [self addSubview:_settingBtn];
        
        _draftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_draftBtn setImage:[UIImage imageNamed:@"ico_drafts"] forState:UIControlStateNormal];
        [_draftBtn addTarget:self action:@selector(draftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _draftBtn.frame = CGRectMake(70, 14.5, 22, 20);
        [self addSubview:_draftBtn];
        
        _bookKeepingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bookKeepingBtn setImage:[UIImage imageNamed:@"ico_drafts"] forState:UIControlStateNormal];
        [_bookKeepingBtn addTarget:self action:@selector(bookKeepingBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _bookKeepingBtn.frame = CGRectMake(70, 14.5, 22, 20);
        [self addSubview:_bookKeepingBtn];
    }
    return self;
}

#pragma - actions
/** 设置按钮点击事件 */
- (void)settingBtnClick {

    
}

/** 草稿箱按钮点击事件 */
- (void)draftBtnClick {
    
}

/** 记账按钮点击事件 */
- (void)bookKeepingBtnClick {
    
}



@end
