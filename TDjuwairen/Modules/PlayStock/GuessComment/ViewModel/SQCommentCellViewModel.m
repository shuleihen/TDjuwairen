//
//  SQCommentCellViewModel.m
//  CommentDemo
//
//  Created by suqianghotel on 16/8/21.
//  Copyright © 2016年 suqianghotel. All rights reserved.
//

#import "SQCommentCellViewModel.h"
#import "SQCommentModel.h"
#import "HexColors.h"


@implementation SQCommentCellViewModel


- (void)setCommentModel:(SQCommentModel *)commentModel
{
    _commentModel = commentModel;
    
    CGFloat margin = 13;
    
    CGFloat nameLabelX = margin;
    CGFloat nameLabelF = 11;
    CGFloat nameLabelW = 250;
    CGFloat nameLabelH = 20;
    
    self.nameLabelF = CGRectMake(nameLabelX, nameLabelF, nameLabelW, nameLabelH);
    
    CGFloat contentLabelX = margin;
    CGFloat contentLabelY = 35;
    CGFloat contentLabelW = self.maxW - 2 * margin;
    CGFloat contentLabelH = 0;
    
    /*
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    para.lineSpacing = 2;
    NSDictionary *attr = @{
                            NSParagraphStyleAttributeName: para,
                            NSFontAttributeName: [UIFont systemFontOfSize:14],
                            NSForegroundColorAttributeName: [UIColor colorWithHue:<#(CGFloat)#> saturation:<#(CGFloat)#> brightness:<#(CGFloat)#> alpha:<#(CGFloat)#>]
                           };
    
    self.contentAttributedString = [[NSAttributedString alloc] initWithString:commentModel.all attributes:attr];
    contentLabelH = [self.contentAttributedString boundingRectWithSize:CGSizeMake(contentLabelW, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    */
    UIFont *contentLabelFont = [UIFont systemFontOfSize:14];
    contentLabelH = [[Tool isStringNull:commentModel.content]?commentModel.roomremark_text:commentModel.content boundingRectWithSize:CGSizeMake(contentLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentLabelFont} context:nil].size.height;
    
    self.contentLabelF = CGRectMake(contentLabelX, contentLabelY, contentLabelW, contentLabelH);
    
    self.cellHeight = CGRectGetMaxY(self.contentLabelF);
}


@end
