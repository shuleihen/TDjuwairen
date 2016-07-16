//
//  NSString+Ext.m
//  demo-cellTextAndImage
//
//  Created by administrator on 16/3/5.
//  Copyright © 2016年 xhb. All rights reserved.
//

#import "NSString+Ext.h"

@implementation NSString (Ext)



- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else {
//        expectedLabelSize = [self sizeWithFont:font
//                             constrainedToSize:size
//                                 lineBreakMode:NSLineBreakByWordWrapping];
        NSLog(@"版本小于7.0");
    }
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}


@end
