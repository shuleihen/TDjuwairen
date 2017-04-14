//
//  AliveListTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HexColors.h"
#import "MYPhotoBrowser.h"

@implementation AliveListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
                
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 40, 40)];
        _avatar.layer.cornerRadius = 20.0f;
        _avatar.clipsToBounds = YES;
        _avatar.userInteractionEnabled = YES;
        [self.contentView addSubview:_avatar];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarPressed:)];
        [_avatar addGestureRecognizer:tap];
        
        _tiedanLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 60, 40, 12)];
        _tiedanLabel.font = [UIFont systemFontOfSize:12.0f];
        _tiedanLabel.textAlignment = NSTextAlignmentCenter;
        _tiedanLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#cccccc"];
        _tiedanLabel.text = @"贴单";
        _tiedanLabel.layer.borderWidth = 0.5f;
        _tiedanLabel.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#cccccc"].CGColor;
        [self.contentView addSubview:_tiedanLabel];
        
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 15, kScreenWidth-92-64, 18)];
        _nickNameLabel.font = [UIFont systemFontOfSize:16.0f];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#3371E2"];
        _nickNameLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:_nickNameLabel];
        
        UITapGestureRecognizer *nickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarPressed:)];
        [_nickNameLabel addGestureRecognizer:nickTap];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-92, 15, 80, 12)];
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#cccccc"];
        [self.contentView addSubview:_timeLabel];
        
        
        _messageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(64, 42, kScreenWidth-12-64, 0)];
        _messageLabel.font = [UIFont systemFontOfSize:16.0f];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        _messageLabel.numberOfLines = 0;
        _messageLabel.delegate = self;
        [self.contentView addSubview:_messageLabel];
        
        _imagesView = [[AliveListImagesView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imagesView];
        
        self.forwardView = [[AliveListForwardView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-64-12, 80)];
        self.forwardView.hidden = YES;
        [self.contentView addSubview:self.forwardView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forwardAvatarPressed:)];
        [self.forwardView.nameLabel addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forwardMsgPressed:)];
        [self.forwardView addGestureRecognizer:tap2];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)avatarPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:avatarPressed:)]) {
        [self.delegate aliveListTableCell:self avatarPressed:sender];
    }
}


- (void)setupAliveListCellData:(AliveListCellData *)cellData {
    self.cellData = cellData;
    
    self.messageLabel.frame = cellData.messageLabelFrame;
    self.imagesView.frame = cellData.imgsViewFrame;
    self.imagesView.hidden = !cellData.isShowImgView;
    
    self.forwardView.hidden = !cellData.aliveModel.isForward;
    self.forwardView.frame = cellData.forwardFrame;
    
    AliveListModel *aliveModel = cellData.aliveModel;
    
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:aliveModel.masterAvatar] placeholderImage:TDDefaultUserAvatar];
    self.nickNameLabel.text = aliveModel.masterNickName;
    self.timeLabel.text = aliveModel.aliveTime;
    
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
    
    self.imagesView.images = aliveModel.aliveImgs;

    self.tiedanLabel.hidden = cellData.isShowTiedan;
    
    if (cellData.aliveModel.isForward) {
        [self.forwardView setupAliveForward:aliveModel.forwardModel];
    }
    
}

#pragma mark - 
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

- (void)forwardMsgPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:forwardMsgPressed:)]) {
        [self.delegate aliveListTableCell:self forwardMsgPressed:sender];
    }
}

- (void)forwardAvatarPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:forwardAvatarPressed:)]) {
        [self.delegate aliveListTableCell:self forwardAvatarPressed:sender];
    }
}
@end
