//
//  AliveListForwardView.m
//  TDjuwairen
//
//  Created by zdy on 2017/4/3.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListForwardView.h"
#import "AliveListForwardModel.h"
#import "UIImageView+WebCache.h"
#import "HexColors.h"

@implementation AliveListForwardView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#EAEAEA"];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        [self addSubview:_imageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, CGRectGetWidth(frame)-90, 16)];
        _nameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#3371e2"];
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        _nameLabel.userInteractionEnabled = YES;
        [self addSubview:_nameLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 26, CGRectGetWidth(frame)-90, CGRectGetHeight(frame)-26-10)];
        _contentLabel.numberOfLines = 2;
        _contentLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_contentLabel];
    }
    return self;
}

- (void)setupAliveForward:(AliveListForwardModel *)foward {
    if (foward.aliveImg) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:foward.aliveImg]];
    } else {
        self.imageView.image = [UIImage imageNamed:@"app_icon.png"];
    }
    
    self.nameLabel.text = [NSString stringWithFormat:@"@%@",foward.masterNickName];
    self.contentLabel.text = foward.aliveTitle;
    
}
@end
