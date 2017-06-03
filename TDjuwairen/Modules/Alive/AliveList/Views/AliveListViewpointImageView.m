//
//  AliveListViewpointImageView.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/3.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListViewpointImageView.h"
#import "UIImageView+WebCache.h"

@implementation AliveListViewpointImageView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setupViewpointUrl:(NSString *)imageUrl {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
}
@end
