//
//  CommentsCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/8.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "CommentsCell.h"

@implementation CommentsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andArr:(NSArray *)arr
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.headImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 30, 30)];
        self.headImg.layer.cornerRadius = 15;
        self.headImg.layer.masksToBounds = YES;
        
        self.nickNameLab = [[UILabel alloc]initWithFrame:CGRectMake(15+30+10, 10, kScreenWidth-55-75, 15)];
        self.nickNameLab.font = [UIFont systemFontOfSize:14];
        
        self.numfloor = [[UILabel alloc]initWithFrame:CGRectMake(15, 10+30+10, 30, 15)];
        self.numfloor.font = [UIFont systemFontOfSize:12];
        self.numfloor.textAlignment = NSTextAlignmentCenter;
        
        if (arr.count > 0) {
            self.floorView = [[FloorInFloorView alloc]initWithArr:arr];
            [self.floorView setFrame:CGRectMake(55, 10+15+10, kScreenWidth-70, self.floorView.height)];
        }
        
        self.goodnumBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-15-60, 10, 60, 15)];
        [self.goodnumBtn setImage:[UIImage imageNamed:@"btn_dianzan_normal.png"] forState:UIControlStateNormal];
        [self.goodnumBtn setImage:[UIImage imageNamed:@"btn_dianzan_pre.png"] forState:UIControlStateSelected];
        
        
        [self.goodnumBtn addTarget:self action:@selector(good:) forControlEvents:UIControlEventTouchUpInside];
        
        self.commentLab = [[UILabel alloc]init];
        self.commentLab.numberOfLines = 0;
        
        self.line = [[UILabel alloc]init];
        self.line.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
        self.line.layer.borderWidth = 1;
        
        [self addSubview:self.headImg];
        [self addSubview:self.numfloor];
        [self addSubview:self.nickNameLab];
        [self addSubview:self.goodnumBtn];
        [self addSubview:self.floorView];
        [self addSubview:self.commentLab];
        [self addSubview:self.line];
    }
    return self;
}

- (void)good:(UIButton *)sender{
    if ([self respondsToSelector:@selector(good:)]) {
        [self.delegate good:sender];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
