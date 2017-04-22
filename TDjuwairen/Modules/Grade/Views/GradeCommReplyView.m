//
//  GradeCommReplyView.m
//  TDjuwairen
//
//  Created by zdy on 2017/4/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeCommReplyView.h"
#import "GradeCommentReplyModel.h"
#import "HexColors.h"

@implementation GradeCommReplyView

+ (CGFloat)heightWithReplyList:(NSArray *)replyList withWidth:(CGFloat)width {
    CGFloat height =0.0f;
    
    for (GradeCommentReplyModel *reply in replyList) {
        
        NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                               NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#3371e2"]};
        
        CGSize size = [reply.replyContent boundingRectWithSize:CGSizeMake(width-24, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:dict
                                                       context:nil].size;
        
        
        height += (20+size.height);
    }
    
    if (replyList.count) {
        height += 24.0f;
    }
    
    return height;
}

- (void)setReplyList:(NSArray *)replyList {
    _replyList = replyList;
    
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    CGFloat offy = 12.0f;
    CGFloat offx = 12.0f;
    
    for (GradeCommentReplyModel *reply in self.replyList) {
        [reply.nickName drawInRect:CGRectMake(offx, offy, rect.size.width-offx*2, 16)
                    withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#3371e2"]}];
    
        NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                               NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#3371e2"]};
        
        CGSize size = [reply.replyContent boundingRectWithSize:CGSizeMake(rect.size.width-offx*2, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:dict
                                                       context:nil].size;
        [reply.replyContent drawInRect:CGRectMake(offx, offy+20, size.width, size.height)
                        withAttributes:dict];
        
        offy += (20+size.height);
    }
}
@end
