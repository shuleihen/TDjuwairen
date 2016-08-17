//
//  PhotoTextAttachment.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PhotoTextAttachment.h"

@implementation PhotoTextAttachment
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    return CGRectMake(0, 0, self.photoSize.width, self.photoSize.height);
}

@end
