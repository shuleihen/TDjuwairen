//
//  LeftRightBtn.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/1.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftRightBtn : UIButton

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *textLabel;

- (instancetype)initWithFrame:(CGRect)frame andImg:(NSString *)img;

- (instancetype)initWithFrame:(CGRect)frame withImg:(NSString *)img andText:(NSString *)text;

@end
