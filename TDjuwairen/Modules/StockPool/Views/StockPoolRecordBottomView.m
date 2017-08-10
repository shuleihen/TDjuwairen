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
        [_settingBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self addSubview:_settingBtn];
        
        
    }
    return self;
}

@end
