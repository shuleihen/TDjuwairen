//
//  AliveListContentView.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListContentView.h"
#import "MYPhotoBrowser.h"

@implementation AliveListContentView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _messageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _messageLabel.font = [UIFont systemFontOfSize:16.0f];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode   = NSLineBreakByWordWrapping;
        _messageLabel.delegate = self;
        [self addSubview:_messageLabel];
    }
    
    return self;
}

- (void)setCellData:(AliveListCellData *)cellData {
    _cellData = cellData;
    
    self.messageLabel.frame = cellData.messageLabelFrame;
    self.messageLabel.attributedText = cellData.message;
        
    if ([cellData.message.string hasSuffix:@"查看图片"]) {
        [self.messageLabel setLinkAttributes:@{NSUnderlineStyleAttributeName: @(0)}];
        [self.messageLabel setActiveLinkAttributes:@{NSUnderlineStyleAttributeName: @(0),
                                                     NSUnderlineColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#3371E2"]}];
        [self.messageLabel addLinkToURL:[NSURL URLWithString:@"jwr://show_alive_list_img"] withRange:NSMakeRange(cellData.message.string.length-4, 4)];
    } else {
        [self.messageLabel setLinkAttributes:nil];
        [self.messageLabel setActiveLinkAttributes:nil];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    MYPhotoBrowser *photoBrowser = [[MYPhotoBrowser alloc] initWithUrls:self.cellData.aliveModel.aliveImgs
                                                               imgViews:nil
                                                            placeholder:nil
                                                             currentIdx:0
                                                            handleNames:nil
                                                               callback:^(UIImage *handleImage,NSString *handleType) {
                                                               }];
    [photoBrowser showWithAnimation:YES];
}

@end
