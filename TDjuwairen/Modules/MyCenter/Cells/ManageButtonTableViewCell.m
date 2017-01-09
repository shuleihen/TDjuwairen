//
//  ManageButtonTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ManageButtonTableViewCell.h"
#import "HexColors.h"

#define kButtonPanelHeight 60

@implementation ManageButtonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.CommentManage = [[ButtonView alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth-2)/3, kButtonPanelHeight)];
        self.CommentManage.imageview.image = [UIImage imageNamed:@"icon_comment.png"];
        self.CommentManage.imageview.contentMode = UIViewContentModeScaleAspectFit;
        self.CommentManage.label.text = @"评论管理";
        self.CommentManage.backgroundColor = [UIColor clearColor];
        
        self.CollectManage = [[ButtonView alloc]initWithFrame:CGRectMake((kScreenWidth-2)/3+1, 0, (kScreenWidth-2)/3, kButtonPanelHeight)];
        self.CollectManage.imageview.image = [UIImage imageNamed:@"icon_attention.png"];
        self.CollectManage.imageview.contentMode = UIViewContentModeScaleAspectFit;
        self.CollectManage.label.text = @"我的关注";
        self.CollectManage.backgroundColor = [UIColor clearColor];
        
        self.BrowseManage = [[ButtonView alloc]initWithFrame:CGRectMake(kScreenWidth-(kScreenWidth-2)/3, 0, (kScreenWidth-2)/3, kButtonPanelHeight)];
        self.BrowseManage.imageview.image = [UIImage imageNamed:@"icon_wallet.png"];
        self.BrowseManage.imageview.contentMode = UIViewContentModeScaleAspectFit;
        self.BrowseManage.label.text = @"我的钱包";
        self.BrowseManage.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.CommentManage];
        [self.contentView addSubview:self.CollectManage];
        [self.contentView addSubview:self.BrowseManage];
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
