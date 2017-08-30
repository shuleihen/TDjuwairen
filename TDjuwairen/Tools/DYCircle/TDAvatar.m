//
//  TDAvatar.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDAvatar.h"

@implementation TDAvatar

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = CGRectGetWidth(self.bounds)/2;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.cornerRadius = CGRectGetWidth(self.bounds)/2;
    self.clipsToBounds = YES;
}


@end
