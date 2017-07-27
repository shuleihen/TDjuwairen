//
//  YXNoDataView.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/27.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXNoDataView : UIView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *message;

- (id)initWithImage:(UIImage *)image withMessage:(NSString *)message withOffy:(CGFloat)offy;
@end
