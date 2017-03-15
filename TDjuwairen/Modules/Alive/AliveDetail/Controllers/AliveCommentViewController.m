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
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *label_residue_count;
@property (weak, nonatomic) IBOutlet UILabel *label_placeHolder;
@property (weak, nonatomic) IBOutlet UITextView *textView_input;
@property (weak, nonatomic) IBOutlet UIButton *button_send;
@property (nonatomic, copy) NSString *commentText;

@end

@implementation AliveCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
    [self initViews];
    [self initValue];
    // Do any additional setup after loading the view.
}

- (void)initValue
{
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)initViews
{
    [_backButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -30)];
    _textView_input.delegate = self;
    
}



- (void)textViewDidChange:(UITextView *)textView{

    if (textView.text.length>MAX_Count) {
        [textView endEditing:YES];
//        return;
    }
    _label_placeHolder.hidden = textView.text.length;
    _button_send.selected = textView.text.length;
    _label_residue_count.text = [NSString stringWithFormat:@"还能输入%ld字",MAX_Count-textView.text.length];
    [Tool mtextviewDidChangeLimitLetter:textView andLimitLength:MAX_Count];
    
    _commentText = textView.text;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textView_input resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendCommentClick:(id)sender {
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{@"alive_id":SafeValue(self.alive_ID),
                           @"alive_type" :SafeValue(_alive_type),
                           @"content":SafeValue(_commentText)};
 
    __weak typeof(self)wSelf = self;
    [manager POST:API_AliveAddRoomComment parameters:dict completion:^(id data, NSError *error) {
        
        if (!error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KnotifierGoPingLun object:nil];
            [wSelf bachAction:wSelf.button_send];
            
            if (wSelf.commentBlock) {
                wSelf.commentBlock();
            }
        }
        
    }];
    
    
    

    
}
- (IBAction)bachAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
