//
//  AliveListCellData.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/30.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListCellData.h"
#import "TTTAttributedLabel.h"

#define kAliveListMessageLineLimit 5

@interface AliveListCellData ()

- (NSAttributedString *)stringWithAliveMessage:(NSString *)message withSize:(CGSize)size isAppendingShowAll:(BOOL)isShowAll isAppendingShowImg:(BOOL)isShowImg;

- (CGFloat)imagesViewHeightWithImages:(NSArray *)images;

- (CGFloat)tagsViewHeightWithTags:(NSArray *)tags withLimitWidth:(CGFloat)limitWidth;

@end

@implementation AliveListCellData

+ (AliveListCellData *)cellDataWithAliveModel:(AliveListModel *)model {
    
    AliveListCellData *cellData = nil;
    
    if (model.isForward) {
        cellData = [[AliveListForwardCellData alloc] initWithAliveModel:model];
    } else {
        switch (model.aliveType) {
            case kAliveNormal:
            case kAlivePosts:
            {
                cellData = [[AliveListPostCellData alloc] initWithAliveModel:model];
            }
                break;
            case kAliveViewpoint: {
                cellData = [[AliveListViewpointCellData alloc] initWithAliveModel:model];
            }
                break;
            case kAliveHot:
            case kAliveSurvey:
            case kAliveVideo:{
                cellData = [[AliveListSurveyCellData alloc] initWithAliveModel:model];
            }
                break;
            default:
                NSAssert(NO, @"直播类型不支持");
                break;
        }
    }
    
    return cellData;
}

- (id)initWithAliveModel:(AliveListModel *)aliveModel {
    if (self = [super init]) {
        _aliveModel = aliveModel;
    }
    return self;
}

- (void)setup {
    
}

- (CGFloat)tagsViewHeightWithTags:(NSArray *)tags withLimitWidth:(CGFloat)limitWidth {
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
        
        if (textSize.height/oneLineSize.height <= kAliveListMessageLineLimit) {
            // 5行以内
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
    
    if (textSize.height/oneLineHeight >= kAliveListMessageLineLimit) {
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


#pragma mark - AliveL

@implementation AliveListSurveyCellData

- (void)setup {
    AliveListModel *model = self.aliveModel;
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:model.aliveTitle attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#333333"]}];
    
    NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attatch.bounds = CGRectMake(2, -2, 17, 17);
    attatch.image = [UIImage imageNamed:@"type_video.png"];
    
    NSAttributedString *video = [NSAttributedString attributedStringWithAttachment:attatch];
    [attri appendAttributedString:video];
    
    CGSize size = [attri boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    self.cellHeight = size.height + 280;
}

@end

#pragma mark - AliveListPostCellData

@implementation AliveListPostCellData


- (void)setup {
    CGFloat contentWidht = kScreenWidth-24;
    CGFloat left = 12.0f;
    CGFloat height = 0.0f;
    
    self.message = [self stringWithAliveMessage:self.aliveModel.aliveTitle
                                       withSize:CGSizeMake(contentWidht, MAXFLOAT)
                             isAppendingShowAll:self.isShowDetailMessage
                             isAppendingShowImg:NO];
    
    CGSize messageSize = [TTTAttributedLabel sizeThatFitsAttributedString:self.message
                                                          withConstraints:CGSizeMake(contentWidht, MAXFLOAT)
                                                   limitedToNumberOfLines:0];
    
    self.messageLabelFrame = CGRectMake(left, 0, contentWidht, messageSize.height);
    
    height = CGRectGetMaxY(self.messageLabelFrame);
    
    // 图片
    BOOL isHaveImage = (self.aliveModel.aliveImgs.count>0);
    if (isHaveImage) {
        CGFloat imagesViewHeight = [self imagesViewHeightWithImages:self.aliveModel.aliveImgs];
        self.imagesViewFrame = CGRectMake(left, height+10, contentWidht, imagesViewHeight);
    } else {
        self.imagesViewFrame = CGRectMake(left, height, 0, 0);
    }
    
    height = CGRectGetMaxY(self.imagesViewFrame);
    
    // 标签
    if (self.aliveModel.aliveTags.count) {
        CGFloat tagsViewHeight = [self tagsViewHeightWithTags:self.aliveModel.aliveTags withLimitWidth:contentWidht];
        self.tagsViewFrame = CGRectMake(left, height+10, contentWidht, tagsViewHeight);
    } else {
        self.tagsViewFrame = CGRectMake(left, height, 0, 0);
    }
    
    height = CGRectGetMaxY(self.tagsViewFrame)+11;
    
    self.viewHeight = height;
    self.cellHeight = self.viewHeight + 64;
}

@end

#pragma mark - AliveListViewpointCellData

@implementation AliveListViewpointCellData

- (void)setup {
    CGFloat contentWidht = kScreenWidth-24;
    CGFloat left = 12.0f;
    CGFloat height = 0.0f;
    
    self.message = [self stringWithAliveMessage:self.aliveModel.aliveTitle
                                       withSize:CGSizeMake(contentWidht, MAXFLOAT)
                             isAppendingShowAll:self.isShowDetailMessage
                             isAppendingShowImg:NO];
    
    CGSize messageSize = [TTTAttributedLabel sizeThatFitsAttributedString:self.message
                                                          withConstraints:CGSizeMake(contentWidht, MAXFLOAT)
                                                   limitedToNumberOfLines:0];
    
    self.messageLabelFrame = CGRectMake(left, 0, contentWidht, messageSize.height);
    
    height = CGRectGetMaxY(self.messageLabelFrame);
    
    self.imageViewFrame = CGRectMake(left, height+10, contentWidht, 178);
    height = CGRectGetMaxY(self.imageViewFrame);
    
    self.viewHeight = height;
    self.cellHeight = self.viewHeight + 64;
}
@end

#pragma mark - AliveListForwardCellData

@implementation AliveListForwardCellData

- (void)setup {
 
    CGFloat contentWidht = kScreenWidth-24;
    CGFloat left = 12.0f;
    CGFloat height = 0.0f;
    BOOL isShowReviewImageButton = (self.aliveModel.aliveImgs.count>0);
    
    self.message = [self stringWithAliveMessage:self.aliveModel.aliveTitle
                                       withSize:CGSizeMake(contentWidht, MAXFLOAT)
                             isAppendingShowAll:self.isShowDetailMessage
                             isAppendingShowImg:isShowReviewImageButton];
    

    CGSize messageSize = [TTTAttributedLabel sizeThatFitsAttributedString:self.message
                                                          withConstraints:CGSizeMake(contentWidht, MAXFLOAT)
                                                   limitedToNumberOfLines:0];
    
    self.messageLabelFrame = CGRectMake(left, 0, contentWidht, messageSize.height);
    
    height = CGRectGetMaxY(self.messageLabelFrame);
    
    AliveListForwardModel *forward = self.aliveModel.forwardModel;
    
    switch (forward.aliveType) {
        case kAliveNormal:
        case kAlivePosts: {
            AliveListModel *model = [[AliveListModel alloc] init];
            model.aliveType = forward.aliveType;
            model.aliveTitle = forward.aliveTitle;
            model.aliveImgs = forward.aliveImgs;
            model.aliveTags = forward.aliveTags;
            
            AliveListPostCellData *pCellData = [[AliveListPostCellData alloc] initWithAliveModel:model];
            pCellData.isShowDetailMessage = NO;
            [pCellData setup];
            
            self.forwardCellData = pCellData;
            self.forwardViewFrame = CGRectMake(0, height+10, kScreenWidth, pCellData.viewHeight);
        }
            break;
        case kAliveSurvey:
        case kAliveHot: {
            self.forwardViewFrame = CGRectMake(0, height+10, kScreenWidth, 91);
        }
            break;
        default:
            self.forwardViewFrame = CGRectMake(0, height, kScreenWidth, 0);
            break;
    }
    
    self.viewHeight = CGRectGetMaxY(self.forwardViewFrame) + 15;
    self.cellHeight = self.viewHeight + 64;
}
@end
