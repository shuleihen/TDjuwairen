//
//  AliveListCellData.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/30.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListCellData.h"
#import "TTTAttributedLabel.h"

@implementation AliveListCellData

- (id)initWithAliveModel:(AliveListModel *)aliveModel {
    if (self = [super init]) {
        self.aliveModel = aliveModel;
        self.isShowTiedan = (aliveModel.aliveType == kAlivePosts)?NO:YES;
        self.isShowViewpointImageView = (aliveModel.aliveType == kAliveViewpoint);
        
        if (!aliveModel.isForward) {
            self.isShowReviewImageButton = NO;
            
            if (self.isShowViewpointImageView) {
                self.isShowImgView = NO;
            } else {
                self.isShowImgView = aliveModel.aliveImgs.count?YES:NO;
            }
        } else {
            // 转发有图片才提示“查看图片”，不显示图片
            self.isShowReviewImageButton = (aliveModel.aliveImgs.count>0)?YES:NO;
            self.isShowImgView = NO;
        }
        
        self.isShowTags = (aliveModel.aliveTags.count>0);
    }
    return self;
}

- (void)setup {
    
    if (self.aliveModel.aliveType == kAliveHot ||
        self.aliveModel.aliveType == kAliveSurvey ||
        self.aliveModel.aliveType == kAliveVideo) {
        self.cellHeight = [self surveyHeightWithAliveModel:self.aliveModel];
        return;
    }
    
    CGFloat left = 12.0f;
    CGFloat right = 12.0f;
    CGFloat contentWidht = kScreenWidth-left-right;
    CGFloat height = 0;
    
    self.message = [self stringWithAliveMessage:self.aliveModel.aliveTitle
                                       withSize:CGSizeMake(contentWidht, MAXFLOAT)
                             isAppendingShowAll:self.isShowDetail
                             isAppendingShowImg:self.isShowReviewImageButton];
    
    
    CGSize messageSize = [TTTAttributedLabel sizeThatFitsAttributedString:self.message
                                     withConstraints:CGSizeMake(contentWidht, MAXFLOAT)
                              limitedToNumberOfLines:0];
    
    self.messageLabelFrame = CGRectMake(left, 62, contentWidht, messageSize.height);
    
    height = CGRectGetMaxY(self.messageLabelFrame);
    
    if (self.aliveModel.isForward) {
        self.imgsViewFrame = CGRectZero;
        
        if (self.message.string.length == 0) {
            // 转发分享，没有标题内容
            self.forwardFrame = CGRectMake(left, 62, contentWidht, 80);
        } else {
            self.forwardFrame = CGRectMake(left, height+10, contentWidht, 80);
        }
        
        height = CGRectGetMaxY(self.forwardFrame) + 11.0f;
        
    } else {
        
        if (self.isShowViewpointImageView) {
            // 直播观点图片显示
            self.viewpointImageViewFrame = CGRectMake(left, height+10, contentWidht, 178);
            
            height = CGRectGetMaxY(self.viewpointImageViewFrame);
        } else {
            // 直播图文和贴单图片显示
            BOOL isHaveImage = (self.aliveModel.aliveImgs.count>0);
            
            if (isHaveImage) {
                CGFloat imagesViewHeight = [self imagesViewHeightWithImages:self.aliveModel.aliveImgs];
                self.imgsViewFrame = CGRectMake(left, height+10, contentWidht, imagesViewHeight);
            } else {
                self.imgsViewFrame = CGRectMake(left, height, 0, 0);
            }
            
            height = CGRectGetMaxY(self.imgsViewFrame);
        }
        
        
        // 标签
        if (self.isShowTags) {
            CGFloat tagsViewHeight = [self tagsViewHeightWithTags:self.aliveModel.aliveTags withLimitWidth:contentWidht];
            self.tagsFrame = CGRectMake(left, height+10, contentWidht, tagsViewHeight);
        } else {
            self.tagsFrame = CGRectMake(left, height, 0, 0);
        }
        
        height = CGRectGetMaxY(self.tagsFrame)+11;
    }
    
    self.cellHeight = height;
}

- (CGFloat)tagsViewHeightWithTags:(NSArray *)tags withLimitWidth:(CGFloat)limitWidth{
    CGFloat height = 0;
    
    CGFloat offx=0,offy=0;
    CGRect rect = CGRectZero;
    
    for (NSString *tag in tags) {
        CGSize size = [tag boundingRectWithSize:CGSizeMake(MAXFLOAT, 15.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil].size;
        
        if ((offx + size.width+6) > limitWidth) {
            offx =0;
            offy += 25;
        }
        
        rect = CGRectMake(offx, offy, size.width+6, 15);
        
        offx += (size.width+6 + 5);
    }
    
    height = CGRectGetMaxY(rect);
    
    return height;
}

- (NSAttributedString *)stringWithAliveMessage:(NSString *)message withSize:(CGSize)size isAppendingShowAll:(BOOL)isShowAll isAppendingShowImg:(BOOL)isShowImg {
    
    NSDictionary *sizeDict = [self messageAttritDictionary];

    if (isShowAll) {
        NSString *msg = message;
        if (isShowImg) {
            if (message.length > 0) {
                msg = [message stringByAppendingString:@"  查看图片"];
            } else {
                msg = [message stringByAppendingString:@"查看图片"];
            }
            
        }
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:msg
                                                                                  attributes:sizeDict];
        
        if (isShowImg) {
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor hx_colorWithHexRGBAString:@"#3371E2"] range:NSMakeRange(msg.length-4, 4)];
        }
        
        return attri;
    } else {
        // 计算一行文本高度
        NSString *oneLineString = @"一行高度abc";
        CGSize oneLineSize = [oneLineString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:sizeDict context:nil].size;
        
        NSString *msg = message;
        if (isShowImg) {
            if (message.length > 0) {
                msg = [message stringByAppendingString:@"  查看图片"];
            } else {
                msg = [message stringByAppendingString:@"查看图片"];
            }
        }
        
        CGSize textSize = [msg boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:sizeDict context:nil].size;
        
        if (textSize.height/oneLineSize.height <= 3) {
            // 3行以内
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]
                                                initWithString:msg
                                                attributes:sizeDict];
            
            if (isShowImg) {
                [attri addAttribute:NSForegroundColorAttributeName value:[UIColor hx_colorWithHexRGBAString:@"#3371E2"] range:NSMakeRange(msg.length-4, 4)];
            }
            return attri;
        }
        
        
        NSString *appendingString = @"...全文";
        if (isShowImg) {
            appendingString = [appendingString stringByAppendingString:@"  查看图片"];
        }
        
        
        
        NSInteger index = [self rangeIndexOfString:message appendingString:appendingString withSize:size index:message.length/2 length:message.length/2 oneLineHeight:oneLineSize.height];
        
        NSString *planText = [message substringToIndex:index];
        /*
        __block NSString *planText;
        
        [message enumerateSubstringsInRange:NSMakeRange(0, message.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
            NSString *mstr = [message substringToIndex:substringRange.location];
            NSString *pstr = [mstr stringByAppendingString:appendingString];
            
            CGSize textSize = [pstr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:sizeDict context:nil].size;
            
            if (textSize.height/oneLineSize.height >= 3) {
                // 3行以内
                *stop = YES;
            } else {
                planText = mstr;
            }
        }];
        */
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:planText attributes:sizeDict];
        
        NSMutableAttributedString *appendAttri = [[NSMutableAttributedString alloc] initWithString:appendingString attributes:sizeDict];
        [appendAttri addAttribute:NSForegroundColorAttributeName value:[UIColor hx_colorWithHexRGBAString:@"#333333"] range:NSMakeRange(0, 3)];
        [appendAttri addAttribute:NSForegroundColorAttributeName value:[UIColor hx_colorWithHexRGBAString:@"#3371E2"] range:NSMakeRange(3, appendingString.length - 3)];
        
        [attr appendAttributedString:appendAttri];
        
        return attr;
    }
}

- (NSInteger)rangeIndexOfString:(NSString *)string
                appendingString:(NSString *)appendingString
                       withSize:(CGSize)size
                          index:(NSInteger)index
                         length:(NSInteger)length
                   oneLineHeight:(CGFloat)oneLineHeight {

    NSDictionary *sizeDict = [self messageAttritDictionary];
    
    NSString *mstr = [string substringToIndex:index];
    NSString *pstr = [mstr stringByAppendingString:appendingString];
    
    CGSize textSize = [pstr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:sizeDict context:nil].size;
    
    if (textSize.height/oneLineHeight >= 3) {
        NSInteger nextIndex;
        NSInteger len = length/2;
        
        if (length/2 == 0) {
            nextIndex = index-1;
            len = 0;
        } else {
            nextIndex = index - length/2;
            len = length/2;
        }
        
        return [self rangeIndexOfString:string appendingString:appendingString withSize:size index:nextIndex length:len oneLineHeight:oneLineHeight];
    } else {
        if (length == 0) {
            return index;
        }
        NSInteger nextIndex = index + length/2;
        
        return [self rangeIndexOfString:string appendingString:appendingString withSize:size index:nextIndex length:length/2 oneLineHeight:oneLineHeight];
    }
}

- (NSDictionary *)messageAttritDictionary {
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineSpacing = 3.0f;
    ps.paragraphSpacingBefore = 0.0f;
    ps.paragraphSpacing = 0.0f;
    ps.alignment = NSTextAlignmentLeft;
    
    NSDictionary *sizeDict = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                               NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"],
                               NSParagraphStyleAttributeName:ps};
    return sizeDict;
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

- (CGFloat)surveyHeightWithAliveModel:(AliveListModel *)model {
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:model.aliveTitle attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#333333"]}];
    
    NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attatch.bounds = CGRectMake(2, -2, 17, 17);
    attatch.image = [UIImage imageNamed:@"type_video.png"];
    
    NSAttributedString *video = [NSAttributedString attributedStringWithAttachment:attatch];
    [attri appendAttributedString:video];
    
    CGSize size = [attri boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    return size.height + 280;
}
@end
