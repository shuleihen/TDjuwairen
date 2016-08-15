//
//  InsertTagsView.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/15.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "InsertTagsView.h"

@implementation InsertTagsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.listArr = [NSMutableArray array];
        
        self.tagScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        
        self.tagList = [[SharpTags alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, 40)];
        self.tagList.signalTagColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0];
        self.tagList.BGColor = [UIColor clearColor];
        
        self.tagsText = [[UITextField alloc]initWithFrame:CGRectMake(15, 50, kScreenWidth-80-15, 30)];
        self.tagsText.layer.cornerRadius = 5;
        self.tagsText.layer.borderWidth = 0.5;
        
        UIButton *send = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-15-80, 50, 80, 30)];
        send.layer.cornerRadius = 5;
        send.backgroundColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0];
        [send setTitle:@"添加" forState:UIControlStateNormal];
        [send addTarget:self action:@selector(addTags:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tagScroll addSubview:self.tagList];
        [self addSubview:self.tagScroll];
        [self addSubview:self.tagsText];
        [self addSubview:send];
    }
    return self;
}

- (void)addTags:(UIButton *)sender{
    if (![self.tagsText.text isEqualToString:@""]) {
        [self.listArr addObject:self.tagsText.text];
        [self.tagList setTagWithTagArray:self.listArr];
        self.tagScroll.contentSize = self.tagList.frame.size;
    }
}

@end
