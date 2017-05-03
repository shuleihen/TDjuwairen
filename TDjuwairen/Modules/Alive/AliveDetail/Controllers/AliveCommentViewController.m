//
//  AliveCommentViewController.m
//  TDjuwairen
//
//  Created by deng shu on 2017/3/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#define MAX_Count 140

#import "AliveCommentViewController.h"
#import "UIButton+Align.h"
#import "NetworkManager.h"
@interface AliveCommentViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label_residue_count;
@property (weak, nonatomic) IBOutlet UILabel *label_placeHolder;
@property (weak, nonatomic) IBOutlet UITextView *textView_input;
@property (strong, nonatomic) UIButton *button_send;
@property (nonatomic, copy) NSString *commentText;

@end

@implementation AliveCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论";
    [self initViews];
}


- (void)initViews
{
    
    _textView_input.delegate = self;
    
    self.button_send = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button_send.frame = CGRectMake(0, 0, 30, 44);
    [self.button_send setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -20, -10, -20)];
    [self.button_send setTitle:@"发送" forState:UIControlStateNormal];
    self.button_send.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.button_send setTitle:@"发送" forState:UIControlStateDisabled];
    [self.button_send setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.button_send setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button_send addTarget:self action:@selector(sendCommentClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.button_send];
    [self.button_send setEnabled:NO];
}


- (void)sendCommentClick:(id)sender {
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{@"alive_id":SafeValue(self.alive_ID),
                           @"alive_type" :SafeValue(_alive_type),
                           @"content":SafeValue(_commentText)};
    
    __weak typeof(self)wSelf = self;
    [manager POST:API_AliveAddRoomComment parameters:dict completion:^(id data, NSError *error) {
        
        if (!error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KnotifierGoPingLun object:nil];
            
            [wSelf.navigationController popViewControllerAnimated:YES];
            
            if (wSelf.commentBlock) {
                wSelf.commentBlock();
            }
        }
        
    }];
}


- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length>MAX_Count) {
        [textView endEditing:YES];
        return;
    }
    
    _label_placeHolder.hidden = textView.text.length;
    _label_residue_count.text = [NSString stringWithFormat:@"还能输入%u",(int)(MAX_Count-textView.text.length)];
    [Tool mtextviewDidChangeLimitLetter:textView andLimitLength:MAX_Count];
    _commentText = textView.text;
    
    if (textView.text.length > 0) {
        if (self.button_send.enabled == NO) {
            self.button_send.enabled = YES;
        }
    }else {
        if (self.button_send.enabled == YES) {
           self.button_send.enabled = NO;
        }
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textView_input resignFirstResponder];
}

@end
