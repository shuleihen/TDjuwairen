//
//  MGCellWinKeyView.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "MGCellWinKeyView.h"
#import "HexColors.h"

@implementation MGCellWinKeyView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10.5f;
    self.clipsToBounds = YES;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.statusString.length == 0) {
        return;
    }
    
    UIImage *key = [UIImage imageNamed:@"icon_key_record.png"];
    [key drawInRect:CGRectMake(0, 0, 21, 21)];
    
    [self.statusString drawInRect:CGRectMake(25, 3, rect.size.width-30, 14) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#EC9C1D"]}];
}


- (void)setStatusString:(NSString *)statusString {
    _statusString = statusString;
    
    if (statusString.length) {
        self.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#FFEDD0"];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    [self setNeedsDisplay];
}
@end
