//
//  SecondEdit.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/1.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftRightBtn.h"

@protocol SecondEditDelegate <NSObject>

- (void)selectFont:(UIButton *)sender;
- (void)sliderAction:(UISlider *)slider;
- (void)clickSecBtn:(LeftRightBtn *)sender;
@end

@interface SecondEdit : UIView
@property (nonatomic,assign) id<SecondEditDelegate>delegate;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) UILabel *fontLab;
- (instancetype)initWithFrame:(CGRect)frame andImgArr:(NSArray *)imgArr andTextArr:(NSArray *)textArr;

@end
