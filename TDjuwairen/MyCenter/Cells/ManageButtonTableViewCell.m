//
//  ManageButtonTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ManageButtonTableViewCell.h"

@implementation ManageButtonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
        self.CommentManage = [[ButtonView alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth-2)/3, 67)];
        self.CommentManage.backgroundColor = [UIColor clearColor];
        self.CommentManage.imageview.image = [UIImage imageNamed:@"CommontImg.png"];
        self.CommentManage.label.text = @"评论管理";
        self.CommentManage.label.font = [UIFont systemFontOfSize:14];
        self.CommentManage.label.textColor = [UIColor darkGrayColor];
        
        self.CollectManage = [[ButtonView alloc]initWithFrame:CGRectMake((kScreenWidth-2)/3+1, 0, (kScreenWidth-2)/3, 67)];
        self.CollectManage.backgroundColor = [UIColor clearColor];
        self.CollectManage.imageview.image = [UIImage imageNamed:@"CollectImg.png"];
        self.CollectManage.label.text = @"收藏管理";
        self.CollectManage.label.font = [UIFont systemFontOfSize:14];
        self.CollectManage.label.textColor = [UIColor darkGrayColor];
        
        self.BrowseManage = [[ButtonView alloc]initWithFrame:CGRectMake(kScreenWidth-(kScreenWidth-2)/3, 0, (kScreenWidth-2)/3, 67)];
        self.BrowseManage.backgroundColor = [UIColor clearColor];
        self.BrowseManage.imageview.image = [UIImage imageNamed:@"BrowseImg.png"];
        self.BrowseManage.label.text = @"浏览记录";
        self.BrowseManage.label.font = [UIFont systemFontOfSize:14];
        self.BrowseManage.label.textColor = [UIColor darkGrayColor];
        
        [self addSubview:self.CommentManage];
        [self addSubview:self.CollectManage];
        [self addSubview:self.BrowseManage];
    }
    return self;
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
