//
//  SurveyAnsView.m
//  TDjuwairen
//
//  Created by zdy on 2017/4/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SurveyAnsView.h"
#import "AnsModel.h"

@implementation SurveyAnsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (CGFloat)heightWithAnsList:(NSArray *)ansList withWidth:(CGFloat)width {
    CGFloat height =0.0f;
    
    for (AnsModel *ans in ansList) {
        
        NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]};
        
        CGSize size = [ans.ansContent boundingRectWithSize:CGSizeMake(width-24, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:dict
                                                       context:nil].size;
        
        
        height += (20+size.height);
    }
    
    if (ansList.count) {
        height += 24.0f;
    }
    
    return height;
}

- (void)setAnsList:(NSArray *)ansList {
    _ansList = ansList;
    
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    CGFloat offy = 12.0f;
    CGFloat offx = 12.0f;
    
    for (AnsModel *ans in self.ansList) {
        [ans.ansUserName drawInRect:CGRectMake(offx, offy, rect.size.width-offx*2, 16)
                    withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#666666"]}];
        
        NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                               NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]};
        
        CGSize size = [ans.ansContent boundingRectWithSize:CGSizeMake(rect.size.width-offx*2, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:dict
                                                       context:nil].size;
        [ans.ansContent drawInRect:CGRectMake(offx, offy+20, size.width, size.height)
                        withAttributes:dict];
        
        offy += (20+size.height);
    }
}
@end
