//
//  TDCommentTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDCommentTableViewCell.h"

@implementation TDCommentTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        _commentTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        _commentTimeLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        [self.contentView addSubview:_commentTimeLabel];
        
        _replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replyBtn setTitle:@"回复" forState:UIControlStateNormal];
        [_replyBtn setTitleColor:TDDetailTextColor forState:UIControlStateNormal];
        _replyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_replyBtn addTarget:self action:@selector(replyPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_replyBtn];
        
        self.contentView.backgroundColor = TDViewBackgrouondColor;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)replyPressed:(id)sender {
    if (self.replyBlock) {
        self.replyBlock(self.commentCellData.commentModel.commentId);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentCellData:(TDCommentCellData *)commentCellData {
    _commentCellData = commentCellData;
    
    self.contentLabel.frame = commentCellData.contentRect;
    self.commentTimeLabel.frame = CGRectMake(12, CGRectGetMaxY(commentCellData.contentRect)+3, 140, 16);
    self.replyBtn.frame = CGRectMake(kScreenWidth-64-12-30, CGRectGetMaxY(commentCellData.contentRect)+3, 30, 16);
    
    TDCommentModel *comment = commentCellData.commentModel;
    self.contentLabel.attributedText = commentCellData.attri;
    
    self.commentTimeLabel.text = comment.time;
}
@end
