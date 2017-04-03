//
//  AliveListCellData.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/30.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListCellData.h"

@implementation AliveListCellData

- (id)initWithAliveModel:(AliveListModel *)aliveModel {
    if (self = [super init]) {
        self.aliveModel = aliveModel;
        self.isShowTiedan = (aliveModel.aliveType ==2)?NO:YES;
        self.isShowForwardImg = YES;
    }
    return self;
}

- (void)setup {
    
    CGFloat left = 64.0f;
    
    self.message = [self stringWithAliveMessage:self.aliveModel.aliveTitle
                                       withSize:CGSizeMake(kScreenWidth-left-12, MAXFLOAT)
                             isAppendingShowAll:self.isShowDetail
                             isAppendingShowImg:self.isShowForwardImg];
    
    CGSize messageSize = [self.message boundingRectWithSize:CGSizeMake(kScreenWidth-left-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.messageLabelFrame = CGRectMake(left, 42, kScreenWidth-left-12, messageSize.height);
    
    CGFloat imagesViewHeight = [self imagesViewHeightWithImages:self.aliveModel.aliveImgs];
    self.imgsViewFrame = CGRectMake(left, CGRectGetMaxY(self.messageLabelFrame)+15, kScreenWidth-left-12, imagesViewHeight);
    
    if (self.aliveModel.isForward) {
        self.forwardFrame = CGRectMake(64, CGRectGetMaxY(self.imgsViewFrame)+15, kScreenWidth-left-12, 80);
        self.cellHeight = CGRectGetMaxY(self.forwardFrame) + 11.0f;
    } else {
        self.cellHeight = CGRectGetMaxY(self.imgsViewFrame) + 11.0f;
    }
    
}


- (NSAttributedString *)stringWithAliveMessage:(NSString *)message withSize:(CGSize)size isAppendingShowAll:(BOOL)isShowAll isAppendingShowImg:(BOOL)isShowImg {
    if (isShowAll) {
        NSAttributedString *attri = [[NSAttributedString alloc] initWithString:message
                                                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                                                                 NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#222222"]}];
        return attri;
    } else {
        // 计算一行文本高度
        NSString *oneLineString = @"一行高度abc";
        CGSize oneLineSize = [oneLineString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]} context:nil].size;
        
        
        CGSize textSize = [message boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]} context:nil].size;
        
        if (textSize.height/oneLineSize.height <= 3) {
            // 3行以内
            NSAttributedString *attri = [[NSAttributedString alloc] initWithString:message
                                                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                                                                     NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#222222"]}];
            return attri;
        }
        
        
        NSString *appendingString = @"...全文";
        if (!isShowImg) {
            appendingString = [appendingString stringByAppendingString:@"  查看图片"];
        }
        
        __block NSString *planText;
        
        [message enumerateSubstringsInRange:NSMakeRange(0, message.length) options:NSStringEnumerationReverse|NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
            NSString *mstr = [message substringToIndex:substringRange.location];
            NSString *pstr = [mstr stringByAppendingString:appendingString];
            
            CGSize textSize = [pstr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]} context:nil].size;
            
            if (textSize.height/oneLineSize.height <= 3) {
                // 3行以内
                planText = mstr;
                *stop = YES;
            }
        }];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:planText attributes:@{NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#222222"]}];
        NSMutableAttributedString *appendAttri = [[NSMutableAttributedString alloc] initWithString:appendingString];
        [appendAttri addAttribute:NSForegroundColorAttributeName value:[UIColor hx_colorWithHexRGBAString:@"#222222"] range:NSMakeRange(0, 3)];
        [appendAttri addAttribute:NSForegroundColorAttributeName value:[UIColor hx_colorWithHexRGBAString:@"#3371E2"] range:NSMakeRange(3, appendingString.length - 3)];
        [attr appendAttributedString:appendAttri];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0, attr.length)];
         
        return attr;
    }
}

- (CGFloat)imagesViewHeightWithImages:(NSArray *)images {
    CGFloat height = 0.f;
    if (images.count == 0) {
        height = 0;
    } else if (images.count == 1) {
        height = 180.0f;
    } else if (images.count > 1) {
        NSInteger x = images.count/3;
        NSInteger y = images.count%3;
        if (y > 0) {
            x++;
        }
        height = 80*x+(((x-1)>0)?((x-1)*10):0);
    }
    
    return height;
}
@end
