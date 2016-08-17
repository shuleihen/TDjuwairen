//
//  EditView.m
//  juwairen
//
//  Created by tuanda on 16/5/31.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "EditView.h"
@implementation EditView
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        CGFloat width=self.frame.size.width;
        CGFloat height=self.frame.size.height;
        
        self.selectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, width/2,height)];
        [self.selectBtn setTitleColor:[UIColor darkGrayColor]forState:UIControlStateNormal];
        [self.selectBtn setTitle:@"全选" forState:UIControlStateNormal];
        self.selectBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        self.selectBtn.backgroundColor=[UIColor whiteColor];
        
        self.deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(width/2, 0, width/2,height)];
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        self.selectBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        self.deleteBtn.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
        
        [self addSubview:self.deleteBtn];
        [self addSubview:self.selectBtn];
        
    }
    return self;
}


@end
