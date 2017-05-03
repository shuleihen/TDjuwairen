//
//  CenterItemView.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "CenterItemView.h"
#import "HexColors.h"

@implementation CenterItemView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}


- (void)setupNumber:(NSInteger)number{
    NSString *numberString = [NSString stringWithFormat:@"%ld",(long)number];
    
    NSString *title = [self.titleLabel.text substringFromIndex:self.titleLabel.text.length-2];
    
    NSString *string = [NSString stringWithFormat:@"%@ %@",numberString, title];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:string];
    [attri addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]} range:NSMakeRange(0, numberString.length)];
    [attri addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#999999"]} range:NSMakeRange(numberString.length+1, title.length)];
    self.titleLabel.attributedText = attri;
    
}
@end
