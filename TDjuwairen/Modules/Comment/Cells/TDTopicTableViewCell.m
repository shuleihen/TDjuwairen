//
//  TDTopicTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDTopicTableViewCell.h"
#import "TDAvatar.h"

@implementation TDTopicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _avatar = [[TDAvatar alloc] initWithFrame:CGRectMake(12, 13, 40, 40)];
        [self.contentView addSubview:_avatar];
        
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 12, kScreenWidth-76, 16)];
        _nickNameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nickNameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#3371E2"];
        [self.contentView addSubview:_nickNameLabel];
        
        _topicTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 38, kScreenWidth-76, 16)];
        _topicTitleLabel.font = [UIFont systemFontOfSize:15.0f];
        _topicTitleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        [self.contentView addSubview:_topicTitleLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTopicModel:(TDTopicModel *)topicModel {
    
}
@end
