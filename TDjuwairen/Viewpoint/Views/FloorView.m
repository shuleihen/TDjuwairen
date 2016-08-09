//
//  FloorView.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/8.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "FloorView.h"

@implementation FloorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.nicknameLab = [[UILabel alloc]init];
        self.nicknameLab.font = [UIFont systemFontOfSize:13];
        
        self.numLab = [[UILabel alloc]init];
        self.numLab.font = [UIFont systemFontOfSize:12];
        self.commentLab = [[UILabel alloc]init];
 
        [self addSubview:self.nicknameLab];
        [self addSubview:self.numLab];
        [self addSubview:self.commentLab];
    }
    return self;
}

@end
