//
//  AliveListVisitCardView.m
//  TDjuwairen
//
//  Created by zdy on 2017/9/4.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListVisitCardView.h"
#import "UIImageView+WebCache.h"

@implementation AliveListVisitCardView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f1f1f1"];
        [self addSubview:_contentView];
        
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 47, 47)];
        [_contentView addSubview:_avatar];
        
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 12, frame.size.width-76, 16)];
        _nickNameLabel.font = [UIFont systemFontOfSize:14.0f];
        [_contentView addSubview:_nickNameLabel];
        
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 35, frame.size.width-76, 16)];
        _descLabel.font = [UIFont systemFontOfSize:12.0f];
        [_contentView addSubview:_descLabel];
    }
    return self;
}


- (void)setCellData:(AliveListCellData *)cellData {
    [super setCellData:cellData];
    
    AliveListVisitCardCellData *vpCellData = (AliveListVisitCardCellData *)cellData;
    AliveListModel *alive = cellData.aliveModel;
    AliveListVisitCardExtra *extra = alive.extra;
    
    self.contentView.frame = vpCellData.visitCardViewFrame;
    self.nickNameLabel.text = [NSString stringWithFormat:@"@%@ 的个人主页",extra.masterNickName];
    self.descLabel.text = extra.desc.length?extra.desc:TDDefaultRoomDesc;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:extra.avatar] placeholderImage:TDDefaultUserAvatar];
}

@end
