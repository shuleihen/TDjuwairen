//
//  SQCommentTableViewCell.m
//  CommentDemo
//
//  Created by suqianghotel on 16/8/21.
//  Copyright © 2016年 suqianghotel. All rights reserved.
//

#import "SQCommentTableViewCell.h"
#import "SQCommentModel.h"
#import "SQCommentCellViewModel.h"
#import "TTTAttributedLabel.h"
#import "HexColors.h"

@interface SQCommentTableViewCell()
@property(nonatomic, strong) TTTAttributedLabel *nameLabel;
@property(nonatomic, strong) TTTAttributedLabel *contentLabel;
@end

@implementation SQCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {

        _nameLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        _nameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
//        _nameLabel.linkAttributes = @{NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#666666"]};
//        _nameLabel.activeLinkAttributes = @{NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#666666"]};
        [self.contentView addSubview:_nameLabel];
        
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        _contentLabel.font = [UIFont systemFontOfSize:14];
//        _contentLabel.linkAttributes = @{NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#cccccc"]};
//        _contentLabel.activeLinkAttributes = @{NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#cccccc"]};
        
        [self.contentView addSubview:_contentLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted == YES) {
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}


- (void)setCommentCellVM:(SQCommentCellViewModel *)commentCellVM
{
    _commentCellVM = commentCellVM;
    
    self.nameLabel.frame = commentCellVM.nameLabelF;
    self.nameLabel.text = commentCellVM.commentModel.userName;
    
    self.contentLabel.frame = commentCellVM.contentLabelF;
    self.contentLabel.text = commentCellVM.commentModel.content;
    
    /*
    TTTAttributedLabelLink *fromLink = [self.contentLabel addLinkToPhoneNumber:commentCellVM.commentModel.from withRange:NSMakeRange(0, commentCellVM.commentModel.from.length)];
    
    fromLink.linkTapBlock = ^(TTTAttributedLabel *label, TTTAttributedLabelLink *link)
    {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didUserInfoClicked:)]) {
            [self.delegate cell:self didUserInfoClicked:commentCellVM.commentModel.from];
        }

    };
    
    if (commentCellVM.commentModel.to.length > 0) {
        TTTAttributedLabelLink *toLink = [self.contentLabel addLinkToPhoneNumber:commentCellVM.commentModel.from
                                                                       withRange:NSMakeRange(commentCellVM.commentModel.from.length + 2, commentCellVM.commentModel.to.length)];
        
        toLink.linkTapBlock = ^(TTTAttributedLabel *label, TTTAttributedLabelLink *link)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didUserInfoClicked:)]) {
                [self.delegate cell:self didUserInfoClicked:commentCellVM.commentModel.to];
            }
        };
    }
    */
    
//    commentCellVM.commentModel.all;
}
@end
