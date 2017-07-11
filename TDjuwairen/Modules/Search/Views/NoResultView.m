//
//  NoResultView.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "NoResultView.h"
#import "HexColors.h"

@implementation NoResultView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIImage *image = [UIImage imageNamed:@"no_result.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        imageView.center = CGPointMake((frame.size.width)/2, frame.size.height/2 -84);
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        label.numberOfLines = 2;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.bounds = CGRectMake(0, 0, 170, 60);
        label.center = CGPointMake((frame.size.width)/2, frame.size.height/2-20);
        [self addSubview:label];
        
        NSString *string = @"没有搜到您想要的结果哦~试试 深度调研";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttributes:@{NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#3371e2"]} range:NSMakeRange(string.length-4, 4)];
        label.attributedText = attr;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:label.frame];
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (void)buttonPressed:(id)sender {
    if (self.buttonClick) {
        self.buttonClick(sender);
    }
}
@end
