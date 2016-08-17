//
//  JWRImageView.m
//  juwairen
//
//  Created by tuanda on 16/5/20.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "JWRImageView.h"

@implementation JWRImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews
{
    self.layer.cornerRadius=self.frame.size.width/2;
    self.layer.masksToBounds=YES;
}

@end
