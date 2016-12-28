//
//  GuessCommentPublishViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/28.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "GuessCommentPublishViewController.h"
#import "HexColors.h"
#import "STPopup.h"

@interface GuessCommentPublishViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end

@implementation GuessCommentPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sendBtn.enabled = NO;
    
    self.textView.layer.borderWidth = 0.5f;
    self.textView.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#dfdfdf"].CGColor;
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
}

- (IBAction)cancelPressed:(id)sender {
    [self.popupController dismiss];
}

- (IBAction)sendPressed:(id)sender {
    NSString *content = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(guessCommentPublishType:withContent:withReplyCommentId:)]) {
        [self.delegate guessCommentPublishType:self.type withContent:content withReplyCommentId:self.replyCommentId];
    }
    
    [self.popupController dismiss];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.sendBtn.enabled = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}
@end
