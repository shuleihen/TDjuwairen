//
//  YXNoDataView.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/27.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "YXNoDataView.h"

@implementation YXNoDataView

- (id)initWithImage:(UIImage *)image withMessage:(NSString *)message withOffy:(CGFloat)offy {
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)]) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        imageView.center = CGPointMake(kScreenWidth/2, offy+image.size.height/2);
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        label.text = message;
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, kScreenWidth, 15);
        [self addSubview:label];
    }
    return self;
}

@end
