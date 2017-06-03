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
                
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 40, 40)];
        _avatar.layer.cornerRadius = 20.0f;
        _avatar.clipsToBounds = YES;
        _avatar.userInteractionEnabled = YES;
        [self.contentView addSubview:_avatar];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarPressed:)];
        [_avatar addGestureRecognizer:tap];
        
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 14, kScreenWidth-92-64, 18)];
        _nickNameLabel.font = [UIFont systemFontOfSize:16.0f];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#3371E2"];
        _nickNameLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:_nickNameLabel];
        
        UITapGestureRecognizer *nickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarPressed:)];
        [_nickNameLabel addGestureRecognizer:nickTap];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 36, 80, 12)];
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        [self.contentView addSubview:_timeLabel];
        
        _officialImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_official.png"]];
        _officialImageView.hidden = YES;
        [self.contentView addSubview:_officialImageView];
        
        
        _arrowButton = [[UIButton alloc] init];
        [_arrowButton setImage:[UIImage imageNamed:@"icon_arrow_down.png"] forState:UIControlStateNormal];
        _arrowButton.frame = CGRectMake(kScreenWidth-42, 12, 30, 30);
        [_arrowButton addTarget:self action:@selector(arrowPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_arrowButton];
        
        _messageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _messageLabel.font = [UIFont systemFontOfSize:16.0f];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        _messageLabel.numberOfLines = 0;
        _messageLabel.delegate = self;
        [self.contentView addSubview:_messageLabel];
        
        _imagesView = [[AliveListImagesView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imagesView];
        
        _tagsView = [[AliveListTagsView alloc] initWithFrame:CGRectZero];
        _tagsView.hidden = YES;
        [self.contentView addSubview:_tagsView];
        
        _forwardView = [[AliveListForwardView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-24, 80)];
        _forwardView.hidden = YES;
        [self.contentView addSubview:_forwardView];
        
        _viewpointImageView = [[AliveListViewpointImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-24, 178)];
        _viewpointImageView.hidden = YES;
        [self.contentView addSubview:_viewpointImageView];
        
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

- (void)setupAliveListCellData:(AliveListCellData *)cellData {
    
    self.cellData = cellData;
    AliveListModel *aliveModel = cellData.aliveModel;
    
    // 头像、昵称
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:aliveModel.masterAvatar] placeholderImage:TDDefaultUserAvatar];
    self.nickNameLabel.text = aliveModel.masterNickName;
    
    // 官方认证标示
    if (aliveModel.isOfficial) {
        CGSize nickNameSize = [aliveModel.masterNickName boundingRectWithSize:CGSizeMake(kScreenWidth-12-64, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0f]} context:nil].size;
        self.officialImageView.frame = CGRectMake(CGRectGetMinX(self.nickNameLabel.frame)+nickNameSize.width+5, 15, 16, 16);
        self.officialImageView.hidden = NO;
    } else {
        self.officialImageView.hidden = YES;
    }
    
    // 直播动态时间
    self.timeLabel.text = aliveModel.aliveTime;
    
    
    // 直播消息
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
    
    
    // 直播图片
    self.imagesView.frame = cellData.imgsViewFrame;
    self.imagesView.hidden = !cellData.isShowImgView;
    
    if (cellData.isShowImgView) {
        self.imagesView.images = aliveModel.aliveImgs;
    }
    

    // 直播标签
    self.tagsView.hidden = !cellData.isShowTags;
    self.tagsView.frame = cellData.tagsFrame;
    
    if (cellData.isShowTags) {
        self.tagsView.tags = aliveModel.aliveTags;
    }
    
    
    // 直播转发
    self.forwardView.hidden = !cellData.aliveModel.isForward;
    self.forwardView.frame = cellData.forwardFrame;
    
    if (cellData.aliveModel.isForward) {
        [self.forwardView setupAliveForward:aliveModel.forwardModel];
    }
    
    // 直播观点
    self.viewpointImageView.hidden = !cellData.isShowViewpointImageView;
    self.viewpointImageView.frame = cellData.viewpointImageViewFrame;
    
    if (cellData.isShowViewpointImageView) {
        [self.viewpointImageView setupViewpointUrl:aliveModel.aliveImgs.firstObject];
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

- (IBAction)avatarPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:avatarPressed:)]) {
        [self.delegate aliveListTableCell:self avatarPressed:sender];
    }
}

- (void)arrowPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:arrowPressed:)]) {
        [self.delegate aliveListTableCell:self arrowPressed:sender];
    }
}
@end
