//
//  GradeCommReplyView.h
//  TDjuwairen
//
//  Created by zdy on 2017/4/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradeCommReplyView : UIView
@property (nonatomic, strong) NSArray *replyList;

+ (CGFloat)heightWithReplyList:(NSArray *)replyList withWidth:(CGFloat)width;
@end
