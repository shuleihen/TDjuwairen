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


@end

@implementation BottomEdit

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //
        self.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
        self.imgArr = @[@"tab_shouqijianpan.png",
                        @"tab_chexiao.png",
                        @"tab_huifu.png",
                        @"tab_ziti.png",
                        @"tab_tianjia.png",
                        @"tab_more.png"
                            ];
        self.selectImgArr = @[@"tab_tanchujianpan.png",
                              @"tab_chexiao_blue.png",
                              @"tab_huifu_blue.png",
                              @"tab_ziti_pre.png",
                              @"tab_tianjia_pre.png",
                              @"tab_more_pre.png"];
        
        [self createBtn];
    }
    return self;
}

- (void)createBtn{
    for (int i = 0; i<self.imgArr.count; i++) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/self.imgArr.count*i, 5, kScreenWidth/self.imgArr.count, 30)];
        [button setImage:[UIImage imageNamed:self.imgArr[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:self.selectImgArr[i]] forState:UIControlStateSelected];
        button.tag = i;
        [button addTarget:self action:@selector(clickEdit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)clickEdit:(UIButton *)sender{
    if ([self respondsToSelector:@selector(clickEdit:)]) {
        [self.delegate clickEdit:sender];
    }
}

@end
