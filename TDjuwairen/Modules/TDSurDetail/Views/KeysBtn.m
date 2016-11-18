//
//  KeysBtn.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "KeysBtn.h"
#import "Masonry.h"
#import "HexColors.h"

@implementation KeysBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *keyImg = [[UIImageView alloc] init];
        keyImg.image = [UIImage imageNamed:@"key_yello"];
        keyImg.contentMode = UIViewContentModeScaleAspectFit;
        
        self.keyNum = [[UILabel alloc] init];
        self.keyNum.font = [UIFont systemFontOfSize:18];
        self.keyNum.textColor = [HXColor hx_colorWithHexRGBAString:@"#F2BA2C"];
        self.keyNum.textAlignment = NSTextAlignmentCenter;
        
        UIImageView *jiage = [[UIImageView alloc] init];
        jiage.image = [UIImage imageNamed:@"icon_jiage"];
        jiage.contentMode = UIViewContentModeScaleAspectFit;
        
        self.jiageLab = [[UILabel alloc] init];
        self.jiageLab.textColor = [HXColor hx_colorWithHexRGBAString:@"#999999"];
        self.jiageLab.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:keyImg];
        [self addSubview:self.keyNum];
        [self addSubview:jiage];
        [self addSubview:self.jiageLab];
        
        [keyImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.right.equalTo(self.mas_centerX).with.offset(0);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
        }];
        
        [self.keyNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.left.equalTo(self.mas_centerX).with.offset(0);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
        }];
        
        [jiage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(keyImg.mas_bottom).with.offset(10);
            make.left.equalTo(self.mas_centerX).with.offset((frame.size.width-45)/2);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15);
        }];
        
        [self.jiageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(keyImg.mas_bottom).with.offset(10);
            make.left.equalTo(jiage.mas_right).with.offset(0);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(15);
        }];
    }
    return self;
}

@end
