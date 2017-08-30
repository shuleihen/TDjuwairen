//
//  DYRefreshImageView.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/8.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "DYRefreshAliveView.h"

@implementation DYRefreshAliveView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-22)/2, 12, 22, 22)];
        _imageView.image = [UIImage imageNamed:@"icon_refresh.png"];
        _imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 40, frame.size.width-24, 14)];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = TDDetailTextColor;
        [self addSubview:_titleLabel];
        
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, (frame.size.height-27)/2, frame.size.width-24, 27)];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.font = [UIFont systemFontOfSize:14.0f];
        _resultLabel.textColor = [UIColor whiteColor];
        _resultLabel.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#548DF5"];
        _resultLabel.layer.cornerRadius = 7.0f;
        _resultLabel.clipsToBounds = YES;
        _resultLabel.hidden = YES;
        [self addSubview:_resultLabel];
        
        _titleArray = @[@"认真对待你的每一分钱",
                        @"看清真相，把握时机",
                        @"远离垃圾，爱惜生命",
                        @"管理层的素质决定公司价值",
                        @"有时不做交易才是最好的交易",
                        @"短期预测非常不靠谱"];
        [self reset];
    }
    return self;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    
    UIImage *image = [UIImage imageNamed:imageName];
    self.imageView.image = image;
}

- (void)setProgress:(CGFloat)progress {
    [super setProgress:progress];
    
    CGAffineTransform tran = CGAffineTransformMakeRotation(M_PI *progress);
    self.imageView.transform = tran;
}

- (void)setResult:(NSString *)result {
    [super setResult:result];
    
    self.imageView.hidden = YES;
    self.titleLabel.hidden = YES;
    self.resultLabel.hidden = NO;
    
    self.resultLabel.text = result;
    CGSize size = [self.resultLabel sizeThatFits:CGSizeMake(self.frame.size.width, 27)];
    self.resultLabel.bounds = CGRectMake(0, 0, size.width+16, 27);
    self.resultLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
}

- (void)startAnimation {
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = @(M_PI);
    rotateAnimation.toValue = @(M_PI*2);
    rotateAnimation.duration = 0.55f;
    rotateAnimation.repeatCount = MAXFLOAT;
    
    [self.imageView.layer addAnimation:rotateAnimation forKey:@"cicleAnimation"];
}

- (void)stopAnimation {
    [self.imageView.layer removeAnimationForKey:@"cicleAnimation"];
    self.imageView.transform = CGAffineTransformIdentity;
}

- (void)reset {
    self.imageView.hidden = NO;
    self.titleLabel.hidden = NO;
    self.resultLabel.hidden = YES;
    
    int x = arc4random() % self.titleArray.count;
    self.titleLabel.text = self.titleArray[x];
}

@end
