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
#import "AliveListPostView.h"
#import "AliveListViewpointView.h"
#import "AliveListForwardView2.h"

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
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setAliveContentView:(AliveListContentView *)aliveContentView {
    if (_aliveContentView || _aliveContentView.superview) {
        [_aliveContentView removeFromSuperview];
    }
    
    _aliveContentView = aliveContentView;
    [self.contentView addSubview:aliveContentView];
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
    
    if (aliveModel.isForward) {
        AliveListForwardView2 *view = [[AliveListForwardView2 alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, cellData.viewHeight)];
        self.aliveContentView = view;
        [view setCellData:cellData];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forwardMsgPressed:)];
        [view.forwardView addGestureRecognizer:tap2];
    } else {
        switch (aliveModel.aliveType) {
            case kAliveNormal:
            case kAlivePosts: {
                AliveListPostView *view = [[AliveListPostView alloc] initWithFrame:CGRectMake(0, 62, kScreenWidth, cellData.viewHeight)];
                self.aliveContentView = view;
                [view setCellData:cellData];
            }
                break;
            case kAliveViewpoint: {
                AliveListViewpointView *view = [[AliveListViewpointView alloc] initWithFrame:CGRectMake(0, 62, kScreenWidth, cellData.viewHeight)];
                self.aliveContentView = view;
                [view setCellData:cellData];
            }
            default:
                break;
        }
    }
    
//    self.aliveContentView.backgroundColor = [UIColor blueColor];
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
