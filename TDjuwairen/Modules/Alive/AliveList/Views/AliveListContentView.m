//
//  AliveListContentView.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListContentView.h"
#import "MYPhotoBrowser.h"
#import "RegexKitLite.h"

@implementation AliveListContentView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _messageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _messageLabel.font = [UIFont systemFontOfSize:16.0f];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode   = NSLineBreakByWordWrapping;
//        _messageLabel.backgroundColor = [UIColor redColor];
//        _messageLabel.delegate = self;
        _messageLabel.linkAttributes = @{NSForegroundColorAttributeName: TDThemeColor,NSUnderlineStyleAttributeName:@(0)};
        _messageLabel.activeLinkAttributes = @{NSForegroundColorAttributeName: TDThemeColor,NSUnderlineStyleAttributeName:@(0)};
        [self addSubview:_messageLabel];
    }
    
    return self;
}

- (void)setCellData:(AliveListCellData *)cellData {
    _cellData = cellData;
    
    self.messageLabel.frame = cellData.messageLabelFrame;
    self.messageLabel.attributedText = cellData.message;

    NSString *title = cellData.message.string;
    if (cellData.aliveModel.isForward) {
        // 匹配 查看图片
        NSString *imageRegex = @"查看图片";
        __block int i=0;
        [title enumerateStringsMatchedByRegex:imageRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop){
            NSString *urlString = [NSString stringWithFormat:@"jwr://alive_image/%ld",(long)i];
            [self.messageLabel addLinkToURL:[NSURL URLWithString:urlString]
                                  withRange:*capturedRanges];
            i++;
        }];
        
        // 匹配 @用户名：
        NSString *userRegex = @"@[a-zA-Z0-9\\u4e00-\\u9fa5]+:";
        i = 0;
        [title enumerateStringsMatchedByRegex:userRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop){
            NSString *urlString = [NSString stringWithFormat:@"jwr://alive_user/%ld",(long)i];
            [self.messageLabel addLinkToURL:[NSURL URLWithString:urlString]
                                  withRange:*capturedRanges];
            i++;
        }];
    }
}


@end
