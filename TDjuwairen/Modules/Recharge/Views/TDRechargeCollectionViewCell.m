//
//  TDRechargeCollectionViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/15.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDRechargeCollectionViewCell.h"
#import "UIImage+Create.h"

@implementation TDRechargeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIImage *normal = [UIImage imageWithSize:self.bounds.size backgroudColor:[UIColor whiteColor] borderColor:[UIColor hx_colorWithHexRGBAString:@"#3370E2"] cornerRadius:5];
    UIImage *selected = [UIImage imageWithSize:self.bounds.size backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#3370E2"] borderColor:[UIColor hx_colorWithHexRGBAString:@"#3370E2"] cornerRadius:5];
    
    self.imageView.image = normal;
    self.imageView.highlightedImage = selected;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.imageView.highlighted = selected;
    self.titleLabel.highlighted = selected;
    self.priceLabel.highlighted = selected;
}


@end
