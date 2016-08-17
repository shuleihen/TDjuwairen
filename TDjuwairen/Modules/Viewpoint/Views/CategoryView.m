//
//  CategoryView.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/25.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "CategoryView.h"

@implementation CategoryView

- (instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)arr
{
    if (self = [super initWithFrame:frame]) {
        self.btnsArr = [NSMutableArray array];
        
        [self setupWithScrollview];
        [self createWithArr:arr];
    }
    return self;
}

- (void)setupWithScrollview{
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    self.scrollview.backgroundColor = [UIColor whiteColor];
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollview];
}

- (void)createWithArr:(NSArray *)arr
{
    for (int i = 0; i<arr.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(70*i, 0, 70, 40)];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateSelected];
        button.tag = i;
        [button addTarget:self action:@selector(ClickBtn:) forControlEvents:UIControlEventTouchDown];
        if (i == 0) {
            button.selected = YES;
            self.selectBtn = button;
        }
        [self.btnsArr addObject:button];
        [self.scrollview addSubview:button];
    }
    self.scrollview.contentSize = CGSizeMake(70*arr.count, 40);
    
    //下划线
    self.selectLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 38, 70, 2)];
    self.selectLab.layer.borderWidth = 2;
    self.selectLab.layer.borderColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0].CGColor;
    [self addSubview:self.selectLab];
    
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    line1.layer.borderWidth = 1;
    line1.layer.borderColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1.0].CGColor;
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, 1)];
    line2.layer.borderWidth = 1;
    line2.layer.borderColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1.0].CGColor;
    [self addSubview:line1];
    [self addSubview:line2];
}

- (void)ClickBtn:(UIButton *)sender{
//    if (self.block) {
//        sender.selected = YES;
//        self.block(sender);
//    }
    if ([self respondsToSelector:@selector(ClickBtn:)]) {
        [self.delegate ClickBtn:sender];
    }
}

@end
