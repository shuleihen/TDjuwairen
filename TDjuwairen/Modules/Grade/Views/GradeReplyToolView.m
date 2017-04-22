//
//  GradeReplyToolView.m
//  TDjuwairen
//
//  Created by zdy on 2017/4/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeReplyToolView.h"
#import "HexColors.h"

@implementation GradeReplyToolView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(12, 5, frame.size.width-12-60, frame.size.height-10)];
        [self addSubview:self.textView];
        
        self.sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-48, 5, 36, frame.size.height-10)];
        [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [self.sendBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#3371e2"] forState:UIControlStateNormal];
        [self.sendBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#999999"] forState:UIControlStateDisabled];
        [self addSubview:self.sendBtn];
    }
    
    return self;
}


@end
