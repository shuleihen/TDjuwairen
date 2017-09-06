//
//  AliveListCellData.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/30.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListCellData.h"
#import "TTTAttributedLabel.h"
#import "AliveVideoListTableViewCell.h"
#import "SurveyHandler.h"
#import "NSString+ImageSize.h"

#define kAliveListMessageLineLimit 5
#define kAliveListHeaderHeight  52
#define kAliveListBottomHeight  37

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
            case kAliveStockHolder:
            {
                cellData = [[AliveListPostCellData alloc] initWithAliveModel:model];
            }
                break;
            case kAliveViewpoint: {
                cellData = [[AliveListViewpointCellData alloc] initWithAliveModel:model];
            }
                break;
            case kAliveHot: {
                cellData = [[AliveListHotCellData alloc] initWithAliveModel:model];
            }
                break;
            case kAliveSurvey:
            case kAliveDeep:
            case kAliveVideo:{
                cellData = [[AliveListSurveyCellData alloc] initWithAliveModel:model];
            }
                break;
            case kAlivePlayStock:{
                cellData = [[AliveListPlayStockCellData alloc] initWithAliveModel:model];
            }
                break;
            case kAliveAd:{
                cellData = [[AliveListAdCellData alloc] initWithAliveModel:model];
            }
                break;
            case kAliveStockPool:
            case kAliveStockPoolRecord:{
                cellData = [[AliveListStockPoolCellData alloc] initWithAliveModel:model];
            }
                break;
            case kAliveVisitCard:{
                cellData = [[AliveListVisitCardCellData alloc] initWithAliveModel:model];
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
    
        _isShowDetailMessage = NO;
        _isShowHeaderView = YES;
        _isShowBottomView = YES;
    }
    return self;
}

- (void)setup {
    CGFloat contentWidht = kScreenWidth-24;
    CGFloat left = 12.0f;

    if (self.aliveModel.aliveTitle.length) {
        NSString *title = @"";
        if (self.aliveModel.isForward) {
            title = [self.aliveModel.aliveTitle stringByReplacingOccurrencesOfString:@"^&%查看图片%&$" withString:@"查看图片"];
        } else {
            title = self.aliveModel.aliveTitle;
        }
        
        self.message = [self stringWithAliveMessage:title
                                           withSize:CGSizeMake(contentWidht, MAXFLOAT)
                                 isAppendingShowAll:self.isShowDetailMessage
                                 isAppendingShowImg:NO];
        
        CGSize messageSize = [TTTAttributedLabel sizeThatFitsAttributedString:self.message
                                                              withConstraints:CGSizeMake(contentWidht, MAXFLOAT)
                                                       limitedToNumberOfLines:0];
        
        self.messageLabelFrame = CGRectMake(left, 10, contentWidht, messageSize.height);
    }
    
}

- (CGFloat)tagsViewHeightWithTags:(NSArray *)tags withLimitWidth:(CGFloat)limitWidth {
    CGFloat height = 0;
    
    CGFloat offx=0,offy=0;
    CGRect rect = CGRectZero;
    
    for (NSString *tag in tags) {
        CGSize size = [tag boundingRectWithSize:CGSizeMake(MAXFLOAT, 15.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil].size;
        
        if ((offx + size.width+8) > limitWidth) {
            offx =0;
            offy += 32;
        }
        
        rect = CGRectMake(offx, offy, size.width+8, 22);
        
        offx += (size.width+8 + 5);
    }
    
    height = CGRectGetMaxY(rect);
    
    return height;
}

- (NSAttributedString *)stringWithAliveMessage:(NSString *)message withSize:(CGSize)size isAppendingShowAll:(BOOL)isShowAll isAppendingShowImg:(BOOL)isShowImg {
    
    NSDictionary *sizeDict = [self messageAttritDictionary];
    
    if (isShowAll) {

        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:message
                                                                                  attributes:sizeDict];
        
        return attri;
    } else {
        // 计算一行文本高度
        NSString *oneLineString = @"一行高度abc";
        CGSize oneLineSize = [oneLineString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:sizeDict context:nil].size;
        

        CGSize textSize = [message boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:sizeDict context:nil].size;
        
        if (textSize.height/oneLineSize.height <= kAliveListMessageLineLimit) {
            // 5行以内
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]
                                                initWithString:message
                                                attributes:sizeDict];
            if (self.aliveModel.searchTextStr.length > 0) {
                NSMutableArray *arrM = [self getRangeStr:message findText:self.aliveModel.searchTextStr];
               
                for (NSNumber *num in arrM) {
                    NSRange rang = NSMakeRange([num integerValue], self.aliveModel.searchTextStr.length);
                    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor hx_colorWithHexRGBAString:@"#FF6C00"] range:rang];
                }
                
            }

            return attri;
        }
        
        NSString *appendingString = @"...全文";

        NSInteger index = [self rangeIndexOfString:message appendingString:appendingString withSize:size index:message.length/2 length:message.length/2 oneLineHeight:oneLineSize.height];
        
        NSString *planText = [message substringToIndex:index];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:planText attributes:sizeDict];
        if (self.aliveModel.searchTextStr.length > 0) {
            NSMutableArray *arrM = [self getRangeStr:planText findText:self.aliveModel.searchTextStr];
            
            for (NSNumber *num in arrM) {
                NSRange rang = NSMakeRange([num integerValue], self.aliveModel.searchTextStr.length);
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor hx_colorWithHexRGBAString:@"#FF6C00"] range:rang];
            }
            
        }
        
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
    ps.lineSpacing = 6.0f;
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
    CGFloat space = 5.0f;
    CGFloat border = 12.0f;
    CGFloat itemW = (kScreenWidth-border*2-space*2)/3;
    
    if (images.count == 0) {
        height = 0;
    } else if (images.count == 1) {
        CGSize size = [images.firstObject imageSize];
        CGFloat w =180,h=180;
        if (!CGSizeEqualToSize(size, CGSizeZero)) {
            if (size.width > size.height) {
                w = kScreenWidth/2;
                h = (size.height/size.width)*w;
            } else if (size.height > size.width) {
                h = kScreenWidth/2;
                w = (size.width/size.height)*h;
            }
        }
        
        height = h;
    } else if (images.count > 1 && images.count <=3) {
        height = itemW;
    } else if (images.count <= 6) {
        height = itemW*2 + space;
    } else {
        height = itemW*3 + space*2;
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


- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText
{
    
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:3];
    
    if (findText == nil && [findText isEqualToString:@""])
    {
        
        return nil;
        
    }
    
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    
    if (rang.location != NSNotFound && rang.length != 0)
    {
        
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        
        NSRange rang1 = {0,0};
        
        NSInteger location = 0;
        
        NSInteger length = 0;
        
        for (int i = 0;; i++)
        {
            
            if (0 == i)
            {
                
                //去掉这个abc字符串
                location = rang.location + rang.length;
                
                length = text.length - rang.location - rang.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            else
            {
                
                location = rang1.location + rang1.length;
                
                length = text.length - rang1.location - rang1.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            
            //在一个range范围内查找另一个字符串的range
            
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0)
            {
                
                break;
                
            }
            else//添加符合条件的location进数组
                
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
            
        }
        
        return arrayRanges;
        
    }
    
    return nil;
    
}
@end


#pragma mark - AliveListPostCellData 推单

@implementation AliveListPostCellData


- (void)setup {
    
    [super setup];
    
    CGFloat contentWidht = kScreenWidth-24;
    CGFloat left = 12.0f;
    CGFloat height = 0.0f;
    
    height = CGRectGetMaxY(self.messageLabelFrame);
    
    // 图片
    if (self.aliveModel.aliveImgs.count) {
        CGFloat imagesViewHeight = [self imagesViewHeightWithImages:self.aliveModel.aliveImgs];
        self.imagesViewFrame = CGRectMake(left, height+7, contentWidht, imagesViewHeight);
    } else {
        self.imagesViewFrame = CGRectMake(left, height, 0, 0);
    }
    
    height = CGRectGetMaxY(self.imagesViewFrame);
    
    // 标签
    if (self.aliveModel.aliveType == kAlivePosts ||
        self.aliveModel.aliveType == kAliveStockHolder) {
        AliveListPostExtra *extra = self.aliveModel.extra;
        if (extra.aliveTags.count) {
            CGFloat tagsViewHeight = [self tagsViewHeightWithTags:extra.aliveTags withLimitWidth:contentWidht];
            self.tagsViewFrame = CGRectMake(left, height+10, contentWidht, tagsViewHeight);
        } else {
            self.tagsViewFrame = CGRectMake(left, height, 0, 0);
        }
    } else {
        self.tagsViewFrame = CGRectMake(left, height, 0, 0);
    }
    
    height = CGRectGetMaxY(self.tagsViewFrame);
    
    self.topHeaderHeight = kAliveListHeaderHeight;
    self.viewHeight = height+15;
    self.bottomHeight =  kAliveListBottomHeight;
    if (self.isShowBottomView) {
        self.cellHeight = self.viewHeight + self.topHeaderHeight + self.bottomHeight;
    } else {
        self.cellHeight = self.viewHeight + self.topHeaderHeight;
    }
}


@end

#pragma mark - AliveListViewpointCellData 观点

@implementation AliveListViewpointCellData

- (void)setup {
    [super setup];
    
    CGFloat contentWidht = kScreenWidth-24;
    CGFloat left = 12.0f;
    CGFloat height = 0.0f;
    
    height = CGRectGetMaxY(self.messageLabelFrame);
    
    if (self.aliveModel.aliveImgs.count) {
        self.imageViewFrame = CGRectMake(left, height+8, contentWidht, 178);
        height = CGRectGetMaxY(self.imageViewFrame);
        self.isShowImageView = YES;
    } else {
        self.isShowImageView = NO;
        // 没有图片显示简略详情
        if ([self.aliveModel.extra isKindOfClass:[NSDictionary class]]) {
            NSString *desc = self.aliveModel.extra[@"view_desc"];
            CGSize size =[desc boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size;
            self.descLabelFrame = CGRectMake(12, height+7, kScreenWidth-24, size.height);
            height = CGRectGetMaxY(self.descLabelFrame);
        }
    }
    
    self.topHeaderHeight = kAliveListHeaderHeight;
    self.viewHeight = height+15;
    self.bottomHeight =  kAliveListBottomHeight;
    if (self.isShowBottomView) {
        self.cellHeight = self.viewHeight + self.topHeaderHeight + self.bottomHeight;
    } else {
        self.cellHeight = self.viewHeight + self.topHeaderHeight;
    }
}
@end

#pragma mark - AliveListForwardCellData 转发

@implementation AliveListForwardCellData

- (void)setup {
    [super setup];
    
    CGFloat height = 0.0f;
    
    AliveListForwardModel *forward = self.aliveModel.forwardModel;
    AliveListModel *forwardAlive = forward.forwardList.lastObject;
    
    height = CGRectGetMaxY(self.messageLabelFrame);
    
    
    switch (forwardAlive.aliveType) {
        case kAliveNormal:
        case kAlivePosts:
        case kAliveStockHolder:
        {
            AliveListPostCellData *pCellData = [[AliveListPostCellData alloc] initWithAliveModel:forwardAlive];
            pCellData.isShowDetailMessage = NO;
            pCellData.isShowBottomView = NO;
            [pCellData setup];
            
            self.forwardCellData = pCellData;
            self.forwardViewFrame = CGRectMake(0, height+7, kScreenWidth, pCellData.viewHeight);
        }
            break;
        case kAliveSurvey:
        case kAliveDeep:
        case kAliveHot: {
            self.forwardViewFrame = CGRectMake(0, height+7, kScreenWidth, 91);
        }
            break;
        case kAliveViewpoint:
        {
            AliveListViewpointCellData *pCellData = [[AliveListViewpointCellData alloc] initWithAliveModel:forwardAlive];
            pCellData.isShowDetailMessage = NO;
            pCellData.isShowBottomView = NO;
            [pCellData setup];
            
            self.forwardCellData = pCellData;
            self.forwardViewFrame = CGRectMake(0, height+7, kScreenWidth, pCellData.viewHeight);
        }
            break;
        case kAliveVideo:{
            self.forwardViewFrame = CGRectMake(0, height+7, kScreenWidth, 220);
        }
            break;
        case kAlivePlayStock:{
            AliveListPlayStockCellData *pCellData = [[AliveListPlayStockCellData alloc] initWithAliveModel:forwardAlive];
            pCellData.isShowDetailMessage = NO;
            pCellData.isShowBottomView = NO;
            [pCellData setup];
            
            self.forwardCellData = pCellData;
            self.forwardViewFrame = CGRectMake(0, height+7, kScreenWidth, pCellData.viewHeight);
        }
            break;
        case kAliveStockPool:
        case kAliveStockPoolRecord: {
            AliveListStockPoolCellData *pCellData = [[AliveListStockPoolCellData alloc] initWithAliveModel:forwardAlive];
            pCellData.isShowDetailMessage = NO;
            pCellData.isShowBottomView = NO;
            pCellData.isShowHeaderView = NO;
            [pCellData setup];
            
            self.forwardCellData = pCellData;
            self.forwardViewFrame = CGRectMake(0, height+7, kScreenWidth, pCellData.viewHeight);
        }
            break;
        case kAliveVisitCard: {
            AliveListVisitCardCellData *pCellData = [[AliveListVisitCardCellData alloc] initWithAliveModel:forwardAlive];
            pCellData.isShowDetailMessage = NO;
            pCellData.isShowBottomView = NO;
            pCellData.isShowHeaderView = NO;
            [pCellData setup];
            
            self.forwardCellData = pCellData;
            self.forwardViewFrame = CGRectMake(0, height+7, kScreenWidth, pCellData.viewHeight);
        }
            break;
            
        default:
            self.forwardViewFrame = CGRectMake(0, height+7, kScreenWidth, 0);
            break;
    }
    
    self.topHeaderHeight = kAliveListHeaderHeight;
    self.viewHeight = CGRectGetMaxY(self.forwardViewFrame) + 15;
    self.bottomHeight =  kAliveListBottomHeight;
    if (self.isShowBottomView) {
        self.cellHeight = self.viewHeight + self.topHeaderHeight + self.bottomHeight;
    } else {
        self.cellHeight = self.viewHeight + self.topHeaderHeight;
    }
}
@end


#pragma mark - AliveListSurveyCellData 调研

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
    
    self.topHeaderHeight = 0;
    self.cellHeight = size.height + 280;
}

@end

#pragma mark - AliveListHotCellData 热点

@implementation AliveListHotCellData

- (void)setup {
    AliveListModel *model = self.aliveModel;
    AliveListExtra *extra = model.extra;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 2.5f;
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:17.0f],
                           NSParagraphStyleAttributeName: style};
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:model.aliveTitle
                                                                              attributes:dict];
    NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attatch.bounds = CGRectMake(2, -2, 17, 17);
    attatch.image = [SurveyHandler imageWithSurveyType:extra.surveyType];
    
    NSAttributedString *video = [NSAttributedString attributedStringWithAttachment:attatch];
    [attri appendAttributedString:video];
    
    CGSize size = [attri boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    
    NSDictionary *dict2 = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                            NSParagraphStyleAttributeName: style};
    NSAttributedString *contentAttra = [[NSAttributedString alloc] initWithString:extra.surveyDesc attributes:dict2];
    CGSize descSize = [contentAttra boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    self.topHeaderHeight = 0;
    self.bottomHeight = 0;
    self.isShowHeaderView = NO;
    self.isShowBottomView = NO;
    self.cellHeight = size.height + descSize.height + 12 + 8 + 50;
}

@end



#pragma mark - AliveListAdCellData 广告

@implementation AliveListAdCellData

- (void)setup {
    AliveListModel *model = self.aliveModel;
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:model.aliveTitle attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#333333"]}];
    
    NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attatch.bounds = CGRectMake(2, -2, 17, 17);
    attatch.image = [UIImage imageNamed:@"type_video.png"];
    
    NSAttributedString *video = [NSAttributedString attributedStringWithAttachment:attatch];
    [attri appendAttributedString:video];
    
    CGSize size = [attri boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    self.topHeaderHeight = 0;
    self.bottomHeight = 0;
    self.isShowHeaderView = NO;
    self.isShowBottomView = NO;
    self.cellHeight = size.height + 280;
}

@end

#pragma mark - AliveListPlayStockCellData 玩票

@implementation AliveListPlayStockCellData

- (void)setup {
    [super setup];
    
    CGFloat contentWidht = kScreenWidth-24;
    CGFloat left = 12.0f;
    CGFloat height = 0.0f;
    
    height = CGRectGetMaxY(self.messageLabelFrame);
    
    self.adImageFrame = CGRectMake(left, height+8, contentWidht, 178);
    height = CGRectGetMaxY(self.adImageFrame);
    
    self.stockNameLabelFrame = CGRectMake(left, height+8, contentWidht, 14);
//    height = CGRectGetMaxY(self.stockNameLabelFrame);
    
    self.timeLabelFrame = CGRectMake(left, height+8, contentWidht, 14);
    height = CGRectGetMaxY(self.timeLabelFrame);
    
    self.topHeaderHeight = kAliveListHeaderHeight;
    self.viewHeight = height+15;
    self.bottomHeight =  kAliveListBottomHeight;
    
    if (self.isShowBottomView) {
        self.cellHeight = self.viewHeight + self.topHeaderHeight + self.bottomHeight;
    } else {
        self.cellHeight = self.viewHeight + self.topHeaderHeight;
    }
}

@end



#pragma mark - AliveListStockPoolCellData 股票池

@implementation AliveListStockPoolCellData

- (void)setup {
    [super setup];
    
    CGFloat contentWidht = kScreenWidth-24;
    CGFloat left = 12.0f;
    CGFloat height = 0.0f;
    
    height = CGRectGetMaxY(self.messageLabelFrame);
    
    self.stockPoolViewFrame = CGRectMake(left, height+8, contentWidht, 85);
    height = CGRectGetMaxY(self.stockPoolViewFrame);
    
    self.topHeaderHeight = kAliveListHeaderHeight;
    self.viewHeight = height+15;
    self.bottomHeight =  kAliveListBottomHeight;
    if (self.isShowBottomView) {
        self.cellHeight = self.viewHeight + self.topHeaderHeight + self.bottomHeight;
    } else {
        self.cellHeight = self.viewHeight + self.topHeaderHeight;
    }
}

@end


#pragma mark - AliveListVisitCardCellData 名片

@implementation AliveListVisitCardCellData

- (void)setup {
    [super setup];
    
    CGFloat height = 0.0f;
    
    height = CGRectGetMaxY(self.messageLabelFrame);
    
    self.visitCardViewFrame = CGRectMake(12, height+8, kScreenWidth-24, 65);
    height = CGRectGetMaxY(self.visitCardViewFrame);
    
    self.topHeaderHeight = kAliveListHeaderHeight;
    self.viewHeight = height + 15;
    
    self.bottomHeight =  kAliveListBottomHeight;
    if (self.isShowBottomView) {
        self.cellHeight = self.viewHeight + self.topHeaderHeight + self.bottomHeight;
    } else {
        self.cellHeight = self.viewHeight + self.topHeaderHeight;
    }
}

@end
