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
        _titleLabel.numberOfLines = 2;
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
    
    CGRect frame = self.bounds;
    
    self.titleLabel.text = forwardModel.aliveTitle;
    
    if (forwardModel.aliveType == kAliveHot) {
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(frame)-24, MAXFLOAT)];
        self.titleLabel.frame = CGRectMake(12, 14, size.width, size.height);
        
        self.imageView.frame = CGRectZero;
        self.auhorLabel.frame = CGRectMake(12, CGRectGetHeight(frame)-15-20, CGRectGetWidth(frame)-24, 16);
        self.dateLabel.frame = CGRectMake(CGRectGetWidth(frame)-112, CGRectGetHeight(frame)-15-20, 100, 16);
    } else {
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(frame)-134, MAXFLOAT)];
        self.titleLabel.frame = CGRectMake(122, 14, size.width, size.height);
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:forwardModel.aliveImg] placeholderImage:nil];
        self.imageView.frame = CGRectMake(12, 15, 100, 60);
        self.auhorLabel.frame = CGRectMake(122, CGRectGetHeight(frame)-15-20, CGRectGetWidth(frame)-224, 16);
        self.dateLabel.frame = CGRectMake(CGRectGetWidth(frame)-112, CGRectGetHeight(frame)-15-20, 100, 16);
    }
  
    self.auhorLabel.text = [NSString stringWithFormat:@"作者：%@", forwardModel.masterNickName];
    self.dateLabel.text = forwardModel.aliveTime;
}

@end
