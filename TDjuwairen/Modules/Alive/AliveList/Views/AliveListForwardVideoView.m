//
//  AliveListForwardVideoView.m
//  TDjuwairen
//
//  Created by zdy on 2017/9/4.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListForwardVideoView.h"
#import "UIImageView+WebCache.h"

@implementation AliveListForwardVideoView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, kScreenWidth-24, 18)];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _titleLabel.textColor = TDTitleTextColor;
        [self addSubview:_titleLabel];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 32, kScreenWidth-24, 178)];
        [self addSubview:_imageView];
        
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.image = [UIImage imageNamed:@"button_play.png"];
        _videoImageView.frame = CGRectMake(0, 0, 60, 60);
        _videoImageView.hidden = YES;
        [_imageView addSubview:_videoImageView];
    }
    
    return self;
}

- (void)setAliveModel:(AliveListModel *)aliveModel {
    _aliveModel = aliveModel;

    self.titleLabel.text = aliveModel.aliveTitle;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:aliveModel.aliveImgs.firstObject] placeholderImage:nil];
}
@end
