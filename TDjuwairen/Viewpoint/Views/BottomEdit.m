//
//  BottomEdit.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#define speac (kScreenWidth-30-180)/5
#import "BottomEdit.h"
@interface BottomEdit ()

@property (nonatomic,strong) NSArray *selectImgArr;
@property (nonatomic,strong) NSArray *imgArr;
@property (nonatomic,strong) UIButton *selectBtn;

@end

@implementation BottomEdit

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //
        self.imgArr = @[@"tab_shouqijianpan@3x.png",
                        @"tab_chexiao@3x.png",
                        @"tab_huifu@3x.png",
                        @"tab_ziti@3x.png",
                        @"tab_tianjia@3x.png",
                        @"tab_more@3x.png"
                            ];
        self.selectImgArr = @[@"tab_tanchujianpan@3x.png",
                              @"tab_chexiao_blue@3x.png",
                              @"tab_huifu_blue@3x.png",
                              @"tab_ziti_pre@3x.png",
                              @"tab_tianjia_pre@3x.png",
                              @"tab_more_pre@3x.png"];
        
        [self createBtn];
    }
    return self;
}

- (void)createBtn{
    for (int i = 0; i<self.imgArr.count; i++) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15+(30+speac)*i, 0, 30, 30)];
        [button setImage:[UIImage imageNamed:self.imgArr[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:self.selectImgArr[i]] forState:UIControlStateSelected];
        button.tag = i;
        [button addTarget:self action:@selector(clickEdit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)clickEdit:(UIButton *)sender{
    self.selectBtn.selected = NO;
    sender.selected = YES;
    self.selectBtn = sender;
    if ([self respondsToSelector:@selector(clickEdit:)]) {
        [self.delegate clickEdit:sender];
    }
}

@end
