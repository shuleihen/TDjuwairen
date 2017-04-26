//
//  GradeReplyToolView.m
//  TDjuwairen
//
//  Created by zdy on 2017/4/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeReplyToolView.h"
#import "HexColors.h"
#import "NSString+Emoji.h"

@implementation GradeReplyToolView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(12, 5, frame.size.width-12-60, frame.size.height-10)];
        self.textView.font = [UIFont systemFontOfSize:15.0f];
        self.textView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f8f8f8"];
        self.textView.layer.cornerRadius = 2.0f;
        self.textView.delegate = self;
        [self addSubview:self.textView];
        
        self.sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-48, (frame.size.height-40)/2, 36, 40)];
        self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [self.sendBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#3371e2"] forState:UIControlStateNormal];
        [self.sendBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#999999"] forState:UIControlStateDisabled];
        [self.sendBtn addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sendBtn];
        self.sendBtn.enabled = NO;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)textViewDidChange:(UITextView *)textView {
    CGRect rect = self.frame;
    CGFloat height = [textView sizeThatFits:CGSizeMake(rect.size.width-12-60, MAXFLOAT)].height;
    height = MAX(height+10, 44);
    
    rect.origin.y -= (height - rect.size.height);
    rect.size.height = MAX(height, 44);
    
    self.frame = rect;
    
    self.sendBtn.enabled = textView.text.length;
}

- (void)setFrame:(CGRect)frame {
    if (frame.size.height >= 120) {
        return;
    }
    
    [super setFrame:frame];
    
    self.textView.frame = CGRectMake(12, 5, frame.size.width-12-60, frame.size.height-10);
    [self.textView setNeedsLayout];
    self.sendBtn.frame = CGRectMake(frame.size.width-48, (frame.size.height-40)/2, 36, 40);
}

- (void)sendPressed:(id)sender {
    NSString *string = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    string = [string stringByReplacingEmojiUnicodeWithCheatCodes];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendReplyWithContent:withReviewId:)]) {
        [self.delegate sendReplyWithContent:string withReviewId:self.reviewId];
    }
}
@end
