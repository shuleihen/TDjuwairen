//
//  StockAskView.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockAskView.h"
#import "HPGrowingTextView.h"
#import "HexColors.h"
#import "UITextView+Placeholder.h"

@interface StockAskView ()<UITextViewDelegate>
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation StockAskView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        self.panelView.frame = CGRectMake(0, kScreenHeight-160, kScreenWidth, 160);
        self.textView.frame = CGRectMake(12, 14, kScreenWidth-24, 160-28);
        [self.panelView addSubview:self.textView];
        [self addSubview:self.panelView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification 
                                                   object:nil];
    }
    return self;
}
/*
- (HPGrowingTextView *)textView {
    if (!_textView) {
        
        _textView = [[HPGrowingTextView alloc] init];
        _textView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f8f8f8"];
        _textView.layer.borderWidth = 1.0f;
        _textView.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#dfdfdf"].CGColor;
        _textView.delegate = self;
        _textView.placeholder = @"写下你的问题";
        _textView.placeholderColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        _textView.font = [UIFont systemFontOfSize:14.0f];
        _textView.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.maxHeight = 160-28;
        _textView.minHeight = 160-28;
         
    }
    return _textView;
}
*/

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f8f8f8"];
        _textView.layer.borderWidth = 1.0f;
        _textView.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#dfdfdf"].CGColor;
        _textView.placeholder = @"写下你的问题";
        _textView.placeholderColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        _textView.font = [UIFont systemFontOfSize:14.0f];
        _textView.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        _textView.returnKeyType = UIReturnKeySend;
    }
    return _textView;
}

- (UIView *)panelView {
    if (!_panelView) {
        _panelView = [[UIView alloc] init];
        _panelView.backgroundColor = [UIColor whiteColor];
    }
    return _panelView;
}

- (void)showInContainView:(UIView *)containView {
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7];
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.panelView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 160);
    self.textView.text = @"";
    
    [containView addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.panelView.frame = CGRectMake(0, kScreenHeight-160, kScreenWidth, 160);
    } completion:^(BOOL finish){
        [self.textView becomeFirstResponder];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.panelView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 81);
    } completion:^(BOOL finish){
        [self.textView resignFirstResponder];
        self.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
        
        NSString *content = self.textView.text;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(askSendWithContent:)]) {
            
            [self.delegate askSendWithContent:content];
        }
    }];
}

-(void)keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = self.panelView.frame;
    containerFrame.origin.y = self.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.panelView.frame = containerFrame;
    
    
    // commit animations
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = self.panelView.frame;
    containerFrame.origin.y = self.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.panelView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    /*
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = self.panelView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    self.panelView.frame = r;
     */
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self hide];
        
        return NO;
    }
    
    return YES;
}
@end
