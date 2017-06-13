//
//  AliveListForwardSurveyView.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListForwardSurveyView.h"
#import "UIImageView+WebCache.h"

@implementation AliveListForwardSurveyView

- (id)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 100, 60)];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(122, 14, CGRectGetWidth(frame)-134, 30)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        [self addSubview:_titleLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)-112, CGRectGetHeight(frame)-15-20, 100, 16)];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = [UIFont systemFontOfSize:12.0f];
        _dateLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        [self addSubview:_dateLabel];
        
        _auhorLabel = [[UILabel alloc] initWithFrame:CGRectMake(122, CGRectGetHeight(frame)-15-20, CGRectGetWidth(frame)-224, 16)];
        _auhorLabel.textAlignment = NSTextAlignmentLeft;
        _auhorLabel.font = [UIFont systemFontOfSize:12.0f];
        _auhorLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        [self addSubview:_auhorLabel];
    }
    
    return self;
}

- (void)setForwardModel:(AliveListForwardModel *)forwardModel {
    _forwardModel = forwardModel;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:forwardModel.aliveImg] placeholderImage:nil];
    self.titleLabel.text = forwardModel.aliveTitle;
    self.auhorLabel.text = [NSString stringWithFormat:@"作者：%@", forwardModel.masterNickName];
    self.dateLabel.text = forwardModel.aliveTime;
    
}

@end
