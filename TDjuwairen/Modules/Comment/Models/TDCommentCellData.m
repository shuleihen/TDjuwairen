//
//  TDCommentCellData.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDCommentCellData.h"

@implementation TDCommentCellData
- (void)setCommentModel:(TDCommentModel *)commentModel {
    _commentModel = commentModel;
    
    if (commentModel.replayToUserNickName.length) {
        NSString *content = [NSString stringWithFormat:@"%@回复%@：%@",commentModel.nickName,commentModel.replayToUserNickName,commentModel.content];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:content];
        [att setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                             NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#151515"]} range:NSMakeRange(0, content.length)];
        [att setAttributes:@{NSForegroundColorAttributeName : TDThemeColor} range:NSMakeRange(0, commentModel.nickName.length)];
        [att setAttributes:@{NSForegroundColorAttributeName : TDThemeColor} range:NSMakeRange(commentModel.nickName.length+2,commentModel.replayToUserNickName.length+1)];
        self.attri = att;
    } else {
        NSString *content = [NSString stringWithFormat:@"%@：%@",commentModel.nickName,commentModel.content];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:content];
        [att setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                             NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#151515"]} range:NSMakeRange(0, content.length)];
        [att setAttributes:@{NSForegroundColorAttributeName : TDThemeColor} range:NSMakeRange(0, commentModel.nickName.length)];
        self.attri = att;
    }
    
    CGSize size = [self.attri boundingRectWithSize:CGSizeMake(kScreenWidth-64-12-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.contentRect = CGRectMake(12, 8, size.width, size.height);
    
    self.cellHeight = size.height + 10+ 23;
}
@end
