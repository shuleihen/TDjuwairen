//
//  ViewPointTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/25.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ViewPointTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ViewPointTableViewCell

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
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 36, 140, 12)];
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        [self.contentView addSubview:_timeLabel];
        
        _officialImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_official.png"]];
        _officialImageView.hidden = YES;
        [self.contentView addSubview:_officialImageView];
        
        
        UIButton *arrow = [[UIButton alloc] init];
        [arrow setImage:[UIImage imageNamed:@"icon_arrow_down.png"] forState:UIControlStateNormal];
        arrow.frame = CGRectMake(kScreenWidth-42, 12, 30, 30);
        [arrow addTarget:self action:@selector(arrowPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:arrow];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.font = [UIFont systemFontOfSize:16.0f];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        _messageLabel.numberOfLines = 0;
        [self.contentView addSubview:_messageLabel];
        
        _coverImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_coverImageView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (CGFloat)heightWithViewpointModel:(ViewPointListModel *)model {
    CGFloat height = 0.0f;
    
    NSString *string = @"发布了观点：";
    string = [string stringByAppendingString:model.view_title];
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]} context:nil].size;
    
    if (model.view_imgurl.length) {
        height = 62+size.height + 350 + 12;
    } else {
        height = 62+size.height + 12;
    }
    return height;
}

- (void)setupViewPointModel:(ViewPointListModel *)model {
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.user_facemin] placeholderImage:TDDefaultUserAvatar];
    self.nickNameLabel.text = model.user_nickname;
    self.timeLabel.text = model.view_wtime;
    
    NSString *string = @"发布了观点：";
    string = [string stringByAppendingString:model.view_title];
    
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]} context:nil].size;
    self.messageLabel.frame = CGRectMake(12, 62, kScreenWidth-24, size.height);
    self.messageLabel.text = string;
    
    self.coverImageView.frame = CGRectMake(12, 62+size.height, kScreenWidth-24, size.height);
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.view_imgurl] placeholderImage:nil];
}


- (IBAction)avatarPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewpointListTableCell:avatarPressed:)]) {
        [self.delegate viewpointListTableCell:self avatarPressed:sender];
    }
}

- (void)arrowPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewpointListTableCell:arrowPressed:)]) {
        [self.delegate viewpointListTableCell:self arrowPressed:sender];
    }
}
@end
